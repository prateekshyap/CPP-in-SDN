function [ fs ] = simulatedAnnealing( mat, n, tMax, tMin, noi, cf )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% tMax = starting temperature
% tMin = final temperature
% noi = number of iterations
% cf = cooling factor
% mat = adjacency matrix
% n = number of nodes
% fs2 = final feasible solution
t = tMax; %t = current temperature
counter = 1; %counts the number of iterations
while (t > tMin)
    t = cf * t;
    counter = counter+1;
end
t = tMax;
x = zeros (1,counter);
xx = zeros (1,counter);
for k = 1 : counter
    xx (1,k) = k;
end
y = zeros (1,counter); %cost
% x = zeros (1,50);
% y = zeros (1,50);
td = 5; %threshold degree
[degrees, controllerPositions] = thresholdDegree (mat, n, td); %finding out the first optimal controller positions according to node degree
fs = controllerPositions + 1;
s = size (controllerPositions);
noc = s (1,2); %noc = number of controllers
ref = fs; %ref = array to store previous positions
cost = capacitedCost (fs, mat, n); %finding out the total cost of the network for fs
x (1,1) = t; %storing the first temperature
y (1,1) = cost; %storing the first cost
in = 2; %index for x and y
while (t > tMin) %current temperature should be more than minimum temperature
    x (1,in) = t; %storing the temperature
    for i = 1 : noi %for each iteration
        fs2 = ref; %copying the reference
        fs2 (1, randi (noc,1,1)) = randi (n,1,1); %generating neighbouring positions of controllers
        flag = 1; %flag is set to 1
        while (flag == 1) %flag must be 1 to start the loop
            flag = 0; %flag is set to 0
            for j = 1 : noc %for each reference controller
                for k = 1 : noc %for each current controller
                    if ((ref (1,j) == fs2 (1,k)) && (j ~= k)) %if the controllers present at different indices are same
                        fs2 (1,k) = randi (n,1,1); %again generate the neighbour
                        flag = 1; %flag is set to 1
                    end
                end
            end
        end
        ref = fs2; %reference is updated
        cost2 = capacitedCost (fs2, mat, n); %cost for new combination fs2
        if (i == 1) %for the first iteration
            y (1,in) = cost2; %store the cost
        else %for next iterations
            if (cost2 < y (1,in)) %compare the new cost to the stored cost and if the new cost is less than the stored one
                y (1,in) = cost2; %update the cost
            end
        end
        delC = cost2 - cost; %cost difference
        if (cost2 <= cost) %if the new cost is smaller than previous one
            fs = fs2; %update the optimal positions of controllers
        else
            r = rand (1,1); %random number between 0 and 1
            if ( r < exp (-delC / t)) %metropolis function
                fs = fs2; %update the optimal positions of controllers
            end
        end
    end
    in = in + 1; %increment the index
    t = cf * t; %reduce the temperature
end
figure (1);
plot (x,y);
xlabel ('Temperature');
ylabel ('Objective Function');
figure (2);
plot (xx,y);
ylabel ('Objective Function');
end
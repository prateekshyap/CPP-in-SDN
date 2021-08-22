function [ fs ] = simulatedAnnealingWithFailure( mat, n, tMax, tMin, noi, cf )
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
y1 = zeros (1,counter); %cost for level 0
y2 = zeros (1,counter); %cost for level 1
% x = zeros (1,50);
% y = zeros (1,50);
td = 5; %threshold degree
[degrees, controllerPositions] = thresholdDegree (mat, n, td); %finding out the first optimal controller positions according to node degree
fs = controllerPositions + 1;
fs
s = size (controllerPositions);
noc = s (1,2); %noc = number of controllers
ref = fs; %ref = array to store previous positions
cost = capacitedCost (fs, mat, n); %finding out the total cost of the network for fs
costF = plannedControllerPlacement (fs, mat, n, 1); %finding out the total cost for 1 failure
x (1,1) = t; %storing the first temperature
y1 (1,1) = cost; %storing the first cost
y2 (1,1) = costF; %storing the failure cost
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
        costF2 = plannedControllerPlacement (fs2, mat, n, 1); %cost for one failure
        if (i == 1) %for the first iteration
            y1 (1,in) = cost2; %store the cost
            y2 (1,in) = costF2; %store the failure cost
        else %for next iterations
            if (cost2 < y1 (1,in)) %compare the new cost to the stored cost and if the new cost is less than the stored one
                y1 (1,in) = cost2; %update the cost
            end
            if (costF2 < y2 (1,in)) %compare the new failure cost to the stored failure cost and if the new failulre cost is less than the stored one
                y2 (1,in) = costF2; %update the failure cost
            end
        end
        delC = cost2 - cost; %cost difference
        delCF = costF- costF2; %failure cost difference
        if ((cost2 <= cost) || costF <= costF2) %if the new cost is smaller than previous one
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
fs
xx
x
y1
y2
figure (1);
plot (x,y1);
title ('No failure');
xlabel ('Temperature');
ylabel ('Objective Function');
figure (2);
plot (xx,y1);
title ('No Failure');
ylabel ('Objective Function');
figure (3);
plot (x,y2);
title ('One failure');
xlabel ('Temperature');
ylabel ('Objective Function');
figure (4);
plot (xx,y2);
title ('One Failure');
ylabel ('Objective Function');
figure (5);
plot (x,y1);
hold on;
plot (x,y2);
legend ('No failure','One failure');
xlabel ('Temperature');
ylabel ('Objective Function');
figure (6);
plot (xx,y1);
hold on;
plot (xx,y2);
legend ('No Failure','One Failure');
ylabel ('Objective Function');
end


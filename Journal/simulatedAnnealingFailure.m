% function [ fs, optCost, optCostF, optLat, optLoad, x, y1, y2, xx, counter, retRand, optConn ] = simulatedAnnealingFailure( mat, n, tMax, tMin, noi, cf, noc, shortestPathMatrix )
function [ fs, optCost, optCostF, optCostF2, optLat, optLoad, x, y1, y2, y3, xx, counter, retRand, optConn ] = simulatedAnnealingFailure( mat, n, tMax, tMin, noi, cf, noc, shortestPathMatrix )
%UNTITLED2 Summary of this function goes here
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
y1 = zeros(1,counter); %cost for level 0
y2 = zeros(1,counter); %cost for level 1
y3 = zeros(1,counter); %cost for level 2
yl1 = zeros(1,counter); %latency for level 0
yl2 = zeros(1,counter); %latency for level 1
yl3 = zeros(1,counter); %latency for level 2
% x = zeros (1,50);
% y = zeros (1,50);
fprintf('\n\n\n');
fs = randi(n,1,noc)
m = 2; %maximum level of failure
%creating the network structure
[sp, connections, connectionsF, controllersList, switchController] = createNetwork(shortestPathMatrix, m, n, noc, fs);
sp
connections
connectionsF
controllersList
switchController
retRand = fs;
optCost = 1000000; %to store the optimal cost value for no failure
optCostF = 1000000; %to store the optimal cost value for one failure
optCostF2 = 1000000; %to store the optimal cost value for second failure
optLoad = 0; %storing the optimal loads for no failure
optLoadF = 0; %storing the optimal loads for one failure
optLoadF2 = 0; %storing the optimal loads for second failure
% td = 5; %threshold degree
% [degrees, controllerPositions] = thresholdDegree (mat, n, td); %finding out the first optimal controller positions according to node degree
% fs = controllerPositions + 1;
% s = size (controllerPositions);
% noc = s (1,2); %noc = number of controllers
ref = fs; %ref = array to store previous positions
[l, cost, lat, conn] = costWithFailure(fs, mat, n, 0, controllersList, switchController, connectionsF); %finding out the total cost of the network for fs
[lF, costF, latF, connF] = costWithFailure(fs, mat, n, 1, controllersList, switchController, connectionsF); %finding out the total cost for 1 failure
[lF3, costF3, latF3, connF3] = costWithFailure(fs, mat, n, 2, controllersList, switchController, connectionsF); %finding out the total cost for second failure
x(1,1) = t; %storing the first temperature
y1(1,1) = cost; %storing the first cost
y2(1,1) = costF; %storing the first failure cost
y3(1,1) = costF3; %storing the second failure cost
yl1(1,1) = lat; %storing the first latency
yl2(1,1) = latF; %storing the first failure latency
yl3(1,1) = latF3; %storing the second failure latency
optConn = conn;
optConnF = connF;
optConnF3 = connF3;
in = 2;
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
        %recreating the network structure for new controllers
        [sp, connections, connectionsF, controllersList, switchController] = createNetwork(shortestPathMatrix, m, n, noc, fs2);
        [l2, cost2, lat2, conn2] = capacitedCostLatency (fs2, mat, n, sp, connections); %cost for new combination fs2
        [lF2, costF2, latF2, connF2] = costWithFailure (fs2, mat, n, 1, controllersList, switchController, connectionsF); %cost for one failure
        [lF22, costF22, latF22, connF22] = costWithFailure (fs2, mat, n, 2, controllersList, switchController, connectionsF); %cost for second failure
        if (i == 1) %for the first iteration
            y1(1,in) = cost2; %update the cost
            y2(1,in) = costF2; %update the failure cost
            y3(1,in) = costF22; %update the failure cost for second level
            yl1(1,in) = lat2; %update the latency
            yl2(1,in) = latF2; %update the failure latency
            yl3(1,in) = latF22; %update the failure latency for second level
        else %for next iterations
            if (cost2 < y1 (1,in)) %compare the new cost to the stored cost and if the new cost is less than the stored one
                y1(1,in) = cost2; %update the cost
                yl1(1,in) = lat2; %update the latency
            end
            if (costF2 < y2 (1,in)) %compare the new failure cost to the stored failure cost and if the new failure cost is less than the stored one
                y2(1,in) = costF2; %update the failure cost
                yl2(1,in) = latF2; %update the failure latency
            end
            if (costF22 < y3(1,in)) %compare the new second failure cost to the stored failure cost and if the new failure cost is less than the stored one
                y3(1,in) = costF22; %update the second failure cost
                yl3(1,in) = latF22; %update the second failure latency
            end
        end
        delC = cost2 - cost; %cost difference
        delCF = costF2 - costF; %failure cost difference
        delCF2 = costF22 - costF3; %failure cost
        if ((cost2 <= cost) || costF2 <= costF || costF22 <= costF3) %if the new cost is smaller than previous one
            cost = cost2;
            costF = costF2;
            costF3 = costF22;
            fs = fs2; %update the optimal positions of controllers
            optCost = cost2; %update the optimal cost
            optCostF = costF2; %update the optimal cost for failure case
            optCostF2 = costF22; %update the optimal cost for second failure
            optLat = lat2; %update the optimal latency
            optLatF = latF2; %update the optimal latency for failure case
            optLatF2 = latF22; %update the optimal latency for second failure
            optLoad = l2; %update the optimal loads
            optLoadF = lF2; %update the optimal loads in failure case
            optLoadF2 = lF22; %update the optimal loads in second failure case
            optConn = conn2; %update the optimal connections
            optConnF = connF2; %update the optimal connections in failure case
            optConnF2 = connF22; %update the optimal connections in second failure case
        else
            r = rand (1,1); %random number between 0 and 1
            if ( r < exp (-delC / t)) %metropolis function
                cost = cost2;
                costF = costF2;
                costF3 = costF22;
                fs = fs2; %update the optimal positions of controllers
                optCost = cost2; %update the optimal cost
                optCostF = costF2; %update the optimal cost for failure case
                optCostF2 = costF22; %update the optimal cost for second failure
                optLat = lat2; %update the optimal latency
                optLatF = latF2; %update the optimal latency for failure case
                optLatF2 = latF22; %update the optimal latency for second failure
                optLoad = l2; %update the optimal loads
                optLoadF = lF2; %update the optimal loads in failure case
                optLoadF2 = lF22; %update the optimal loads in second failure case
                optConn = conn2; %update the optimal connections
                optConnF = connF2; %update the optimal connections in failure case
                optConnF2 = connF22; %update the optimal connections in second failure case
            end
        end
    end
    in = in + 1; %increment the index
    t = cf * t; %reduce the temperature
end
end
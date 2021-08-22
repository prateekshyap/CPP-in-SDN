function [ fs, optCost, optLat, optLoad, x, y1, xx, counter, retRand ] = simulatedAnnealingLB ( mat, n, tMax, tMin, noi, cf, noc )
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
    y1 = zeros (1,counter); %cost
    y2 = zeros (1,counter); %latency
    % x = zeros (1,50);
    % y = zeros (1,50);
    fs = randi (n,1,noc);
    retRand = fs;
    optCost = 1000000; %to store the optimal cost value
    optLoad = 0; %storing the optimal loads
    optLat = 0;
    optConn = 0;
    optSp = 0;
    optPackets = zeros (1,1);
    % td = 5; %threshold degree
    % [degrees, controllerPositions] = thresholdDegree (mat, n, td); %finding out the first optimal controller positions according to node degree
    % fs = controllerPositions + 1;
    % s = size (controllerPositions);
    % noc = s (1,2); %noc = number of controllers
    ref = fs; %ref = array to store previous positions
    [l, cost, conn, sp, packets, lat] = capacitedRandomCost (fs, mat, n, 1); %finding out the total cost of the network for fs
    x (1,1) = t; %storing the first temperature
    y1 (1,1) = cost; %storing the first cost
    y2 (1,1) = lat; %storing the first latency
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
            [l2, cost2, conn, sp, packets, lat2] = capacitedRandomCost (fs2, mat, n, 1); %cost for new combination fs2
            if (i == 1) %for the first iteration
                y1 (1,in) = cost2; %store the cost
                y2 (1,in) = lat2; %store the latency
            else %for next iterations
                if (cost2 < y1 (1,in)) %compare the new cost to the stored cost and if the new cost is less than the stored one
                    y1 (1,in) = cost2; %update the cost
                    y2 (1,in) = lat2; %update the latency
                end
            end
            delC = cost2 - cost; %cost difference
            if ((cost2 <= cost)) %if the new cost is smaller than previous one
                fs = fs2; %update the optimal positions of controllers
                optCost = cost2; %update the optimal cost
                optLat = lat2; %update the optimal latency
                optLoad = l2; %update the optimal loads
                optConn = conn;
                optSp = sp;
                optPackets = packets;
            else
                r = rand (1,1); %random number between 0 and 1
                if (( r < exp (-delC / t))) %metropolis function
                    fs = fs2; %update the optimal positions of controllers
                    optCost = cost2; %update the optimal cost
                    optLat = lat2; %update the optimal latency
                    optLoad = l2; %update the optimal loads
                    optConn = conn;
                    optSp = sp;
                    optPackets = packets;
                end
            end
        end
        in = in + 1; %increment the index
        t = cf * t; %reduce the temperature
    end
    
    %run load balancing algorithm 
    flag = 1; %indicator
    % overloadedController = 0; %the controller which is overloaded
    modifyIndex = 0; %the index of the controller in the controllers list which is overloaded
    totalLoad = 0; %to store the total load
    for j = 1 : noc %for each controller
        totalLoad = totalLoad + optLoad(1,j); %add the load of jth controller
    end
    if ((totalLoad/noc) <= 7800)
        optLoad
        totalLoad2 = 0;
        while (flag == 1 && totalLoad2/noc <= 7800) %load balancing will be done till any overloaded controller is found
            flag = 0; %reset flag to 0
            for i = 1 : noc %for each controller
                if (optLoad(2,i) == 0) %if it is overloaded or idle
                    flag = 1; %update the indicator
                    modifyIndex = i; %index of the overloaded controller in controllers list
%                     overloadedController = controllerList (i); %update the overloaded controller position
                    break; %break the loop
                end
            end
            if (flag == 1) %if indicator is updated
                [balance, newConnections, newLoads, ccc] = loadBalancing (fs, optLoad, optSp, optPackets, optConn, modifyIndex, n, noc, 1, 7800); %run load balancing algorithm
                optLoad = newLoads %update the loads
                optConn = newConnections; %update the connections
                totalLoad2 = 0; %to store the total load
                noc
                for j = 1 : noc %for each controller
                    totalLoad2 = totalLoad2 + optLoad(1,j); %add the load of jth controller
                end
            end
        end
    end
    %updating the toal cost
    optCost = optCost - totalLoad;
    for j = 1 : noc
        optCost = optCost + optLoad(1,j);
    end
    optLat = avgLatency(optConn, n, n, noc, fs);
end
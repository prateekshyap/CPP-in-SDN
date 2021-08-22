function [ bestCosts, globBestPos, globBest, controllerLoad, val ] = particleSwarmOptimization( iterations, c1, c2, r1, r2, w, wDamp, initialPositions, populations, populationSize, coOrd, mat, n, latlong )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%{
%%    c1, c2, r1, r2, w are constants
%%    initialPositions = matrix which stores the initial positions x(t)
%%    vel = matrix which stores the initial velocities v(t)
%%    fitnessValues = array to store the fitness values
%%    nextVel = matrix to store the new velocitites v(t+1)
%%    bestPositions = matrix to store the local best positions
%%    globBest = stores the global best fitness value
%%    globBestPos = stores the global best positions
%%    nextPos = matrix to store the new positions x(t+1) 
%}
%% initialization
val = 0;
initPosMat = zeros(populationSize,coOrd);
for kk = 1 : populationSize
    index = 1;
    for j = 1 : coOrd/2
        initPosMat(kk,index) = initialPositions(kk,j).xCoord;
        index = index + 1;
        initPosMat(kk,index) = initialPositions(kk,j).yCoord;
        index = index + 1;
    end
end
fitnessValues = zeros (1,populationSize);
vel = zeros (populationSize,coOrd);
nextVel = zeros (populationSize,coOrd);
bestSol = 10000000 * ones (1,populationSize);
bestPositions = zeros(populationSize,(coOrd/2));
bestCoordinates = zeros(populationSize,coOrd);
globBest = 10000000;
globBestPos = zeros(1,(coOrd/2));
globBestCoord = zeros(1,coOrd);
nextPos = zeros (populationSize,coOrd);
bestCosts = zeros(1,iterations);
bestConn = zeros(1,1);

%% main loop of pso
for it = 1 : iterations
%     fprintf('\n\n\n');
%     it
%     initPosMat
%     populations
    
    %% calculating the velocity and new positions for the particles
    for i = 1 : populationSize %for each position
        nextVel (i, 1:coOrd) = (w * vel (i, 1:coOrd)) + (c1 * rand * (bestCoordinates (i, 1:coOrd) - initPosMat (i, 1:coOrd))) + (c2 * rand * (globBestCoord - initPosMat (i, 1:coOrd))); %calculate the new velocities v(t+1)
    end
    for i = 1 : populationSize %for each position
        nextPos (i, 1:coOrd) = initPosMat (i, 1:coOrd) + nextVel (i, 1:coOrd); %nextPos stores the initial values for next iteration i.e. table-3
    end
    
    %% calculating the nearest controllers
    for kk = 1 : populationSize
        index = 1;
        for j = 1 : coOrd/2
            initialPositions(kk,j).xCoord = initPosMat(kk,index);
            index = index + 1;
            initialPositions(kk,j).yCoord = initPosMat(kk,index);
            index = index + 1;
        end
    end
    for i = 1 : populationSize
        distances = zeros(n,(coOrd/2));
        for j = 1 : (coOrd/2)
            for k = 1 : n
                distances(k,j) = sqrt(((initialPositions(i,j).xCoord-latlong(k,1))*(initialPositions(i,j).xCoord-latlong(k,1)))+((initialPositions(i,j).yCoord-latlong(k,2))*(initialPositions(i,j).yCoord-latlong(k,2))));
            end
        end
        newPop = zeros(1,(coOrd/2));
        for j = 1 : (coOrd/2)
            min = 1e+1000;
            minIndex = 0;
            for k = 1 : n
                if (distances(k,j) < min)
                    min = distances(k,j);
                    minIndex = k;
                end
            end
            newPop(j) = minIndex;
            distances(minIndex,1:(coOrd/2)) = 1e+1000;
        end
        populations(i,1:(coOrd/2)) = newPop;
    end
    for i = 1 : populationSize
        for j = 1 : (coOrd/2)
            initialPositions(i,j).xCoord = latlong(populations(i,j),1);
            initialPositions(i,j).yCoord = latlong(populations(i,j),2);
        end
    end
    for kk = 1 : populationSize
        index = 1;
        for j = 1 : coOrd/2
            initPosMat(kk,index) = initialPositions(kk,j).xCoord;
            index = index + 1;
            initPosMat(kk,index) = initialPositions(kk,j).yCoord;
            index = index + 1;
        end
    end
    
%     populations
    
    %% finding out the local best and global best positions and costs
    for i = 1 : populationSize %for each position
%         pop = populations(i,1:(coOrd/2));
        [controllerLoad, costVal, ll, cc] = capacitedCostLatency(populations(i,1:(coOrd/2)),mat,n); %calculate the fitness value
        fitnessValues(1,i) = costVal;
        %% load balancing    
%         flag = 1; %indicator
%         cap = 5000;
%         ld = 0;
%         for l = 1 : (coOrd/2)
%             ld = ld + controllerLoad(1,l);
%         end
%         % overloadedController = 0; %the controller which is overloaded
%         modifyIndex = 0; %the index of the controller in the controllers list which is overloaded
%         while (flag == 1 && (ld < (cap*(coOrd/2)*0.75))) %load balancing will be done till any overloaded controller is found
%             flag = 0; %reset flag to 0
%             for i = 1 : (coOrd/2) %for each controller
%                 if (controllerLoad(2,i) == 0) %if it is overloaded or idle
%                     flag = 1; %update the indicator
%                     modifyIndex = i; %index of the overloaded controller in controllers list
% %                     overloadedController = controllerList (i); %update the overloaded controller position
%                     break; %break the loop
%                 end
%             end
%             if (flag == 1) %if indicator is updated
%                 [balance, newConnections, newLoads, noc] = loadBalancing (populations(i,1:(coOrd/2)), controllerLoad, sp, packets, connections, modifyIndex, n, (coOrd/2), 1, cap); %run load balancing algorithm
% %                 [balance, newConnections, newLoads, noc] = loadBalancingRandomCapacity (controllerList, controllerLoad, sp, packets, connections, modifyIndex, n, noc, alpha, controllerCapacity); %run load balancing algorithm
%                 controllerLoad = newLoads; %update the loads
%                 connections = newConnections; %update the connections
%             end
%         end
%         fitnessValues(1,i) = 0;
%         for tt = 1 : (coOrd/2)
%             fitnessValues(1,i) = fitnessValues(1,i) + controllerLoad(1,tt);
%         end
        if (bestSol(1,i) > fitnessValues(1,i)) %if new fitness value is better than local best
            bestSol(1,i) = fitnessValues(1,i); %update the local best value
            bestPositions(i,1:(coOrd/2)) = populations(i,(1:coOrd/2)); %update the local best positions
            bestCoordinates(i,1:coOrd) = initPosMat(i,1:coOrd);
        end
        if (globBest > bestSol(1,i)) %if local best value is better than global best value
            globBest = bestSol(1,i); %update the global best value
            globBestPos = bestPositions(i,1:(coOrd/2)); %update the global best positions
            globBestCoord = bestCoordinates(i,1:coOrd);
        end
    end
%     bestPositions
%     fitnessValues
%     bestSol
%     globBest
%     globBestPos
    bestCosts(it) = globBest;
%     w = w * wDamp; %multiplying the damping factor
    initPosMat = nextPos; %updating the initial positions for the next iteration
%     initPosMat
%     nextVel
    vel = nextVel; %updating the velocities for the next iteration
%     vel
end
% bestConn
end
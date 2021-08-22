function [ bestFitness, bestLocations, bestLoads, optLat ] = modifiedGeneticAlgorithmImpl052LB( mat, n, ps, mi, noc )
global mutProb;
global randomIterations;
%UNTITLED Summary of this function goes here
%{
cost is the fitness function here
ps = population size
mi = maximum no of iterations
mat = adjacency matrix
n = number of nodes
noc = number of controller
bestFitness = a variable to store the best fitness value
worstFitness = a variable to store the worst fitness value
fitnessValues = an array to store all the fitness values
populations = a matrix to store all the populations
draft = an array to store the draft
%}
%   Detailed explanation goes here

% c = combnk (1 : n,noc); %storing all the combinations possible
% s = size (c);
% lim = s (1,1); %this is needed to generate the random indices
% randInd = randi ([1 lim],1,ps); %generating the random indices
populations = zeros (ps, noc); %a matrix to store the populations
fitnessValues = zeros (1, ps); %an array to store the fitness values for each combination present in populations matrix
packets = zeros (ps, n); %a matrix to store the packets
loads = zeros (ps, noc); %a matrix to store the loads on the controllers
bestIndex = 1; %stores the best fitness index
worstIndex = 1; %stores the worst fitness index
bestFitness = 0; %stores the best fitness value
worstFitness = 0; %stores the worst fitness value
bestPackets = 0;
bestLocations = zeros (1,noc); %stores the best locations
worstLocations = zeros (1,noc); %stores the worst locations
bestLoads = zeros (2,noc); %stores the best loads
worstLoads = zeros (1,noc); %stores the worst loads

% finding out the initial populations, their fitness values, the best and the worst fitness values
for g = 1 : ps %for each population
    populations (g, 1:noc) = randi (n,1,noc); %storing the combinations into populations matrix
    [l, f, conn2, sp2, packet2, lat2] = capacitedRandomCost (populations (g,1:noc), mat, n, 1); %storing the fitness value for the combination
    loads (g, 1:noc) = l (1,1:noc);
    fitnessValues (1, g) = f;
    packets (g,1:n) = packet2;
    if (g > 1) %if we have more than one fitness values
        if (fitnessValues (1, g) < fitnessValues (1, bestIndex)) %if the newly calculated fitness value is less than the best fitness value
            bestIndex = g; %update the best fitness
        end
        if (fitnessValues (1, g) > fitnessValues (1, worstIndex)) %if the newly calculated fitness value is greater than the worst fitness value
            worstIndex = g; %update the worst fitness
        end
    end
end

%generation, mutation and replacement
for counter = 1 : mi %the procedure of modified genetic algorithm will be repeated according to the maximum iterations
%finding out the members to draft
%     [c1, c2] = membersForDrafting (lim, probOfOcc, noc, c, populations, ps); %call this function to find out two members
%     [c1, c2] = rouletteWheelForGeneticAlgorithm (noc, c, populations, ps, fitnessValues); %call roulette wheel function
    [c1, c2] = randomSelection (ps); %random selection
%drafting
    draft = drafting (noc, populations, c1, c2); %calling the drafting function
%deletion
    [candidate, fitnessVal, optimalLoad, optConn, optSp, optLat, optPackets] = optimalCandidates (draft, noc, mat, n); %calling optimalCandidates function to find out the new candidate
%mutation
mutProb = mutProb + 1;
if (mutProb == randomIterations (1,1) || mutProb == randomIterations (1,2) || mutProb == randomIterations (1,3) || mutProb == randomIterations (1,4) || mutProb == randomIterations (1,5)) %mutation will be done in each 100th iteration
%     mutProb
%     fprintf (' done\n');
    randomIndex = randi ([1 noc], 1, 1); %generate a random index from the candidate list
    randomController = randi ([1 n], 1, 1); %generate a random controller position to do the mutation
    flag0 = 0; %an indicator variable
    while (flag0 == 0) %if indicator is not updated
        for b = 1 : noc %for each controller present in the candidate
            if (candidate (1,b) == randomController) %if the newly generated controller is already present
                randomController = randi ([1,n], 1, 1); %generate a new controller
                flag0 = 1; %update the flag
                break; %break the loop
            end
        end
        if (flag0 == 1) %if flag is 1 that means a new controller has been generated so we need to continue the while loop again
            flag0 = 0; %hence update it to 0
        else %if flag is not updated
            break; %break the while loop also
        end
    end
    candidate (1,randomIndex) = randomController; %update the candidate
    if (mutProb == 100) %if 100 iterations are over
        mutProb = 0; %reset the variable to start counting again
        randomIterations = randi ([1 100],1,5); %generate new iterations
%         randomIterations
    end
else
%     mutProb
%     fprintf (' not done\n');
    if (mutProb == 100) %if 100 iterations are over
        mutProb = 0; %reset the variable to start counting again
        randomIterations = randi ([1 100],1,5); %generate new iterations
%         randomIterations
    end
end
%replacement
    %check whether the newly found candidate is actually a new one or it already exists in the populations array
    indicator = 0; %a variable to keep track of the candidate
    for y = 1 : ps %for each population
        if (populations (y,1:noc) == candidate (1,1:noc)) %if the candidate is equal to yth combination
            indicator = 1; %update the indicator
            break; %break the loop
        end
    end
    if (indicator == 0) %if indicator is not updated that means the candidate is new
        %find out the maximum fitness value to replace
        maxFitnessIndex = 1;
        for z = 2 : ps %for each population
            if (fitnessValues (1,z) > fitnessValues (1,maxFitnessIndex)) %if the new value is greater than the maximum fitness value
                maxFitnessIndex = z; %update the maximum fitness index
            end
        end
        if (fitnessValues (1,maxFitnessIndex) > fitnessVal) %if the maximum value is greater than the new value
            populations (maxFitnessIndex, 1:noc) = candidate (1,1:noc); %replace the corresponding combination with the newly found candidate
            fitnessValues (1, maxFitnessIndex) = fitnessVal; %replace the corresponding fitness value with the newly found fitness value 
            packets (maxFitnessIndex, 1:n) = optPackets;
            loads (maxFitnessIndex, 1:noc) = optimalLoad (1,1:noc); %replace the load values
        end
    end
end

%finding out the best and worst values again
for g = 1 : ps %for each population
    if (fitnessValues (1, g) < fitnessValues (1, bestIndex)) %if the newly calculated fitness value is less than the best fitness value
        bestIndex = g; %update the best fitness
    end
    if (fitnessValues (1, g) > fitnessValues (1, worstIndex)) %if the newly calculated fitness value is greater than the worst fitness value
        worstIndex = g; %update the worst fitness
    end
end

%updating the values and locations
bestFitness = fitnessValues (1,bestIndex);
worstFitness = fitnessValues (1,worstIndex);
bestLocations (1,1:noc) = populations (bestIndex, 1:noc);
worstLocations (1,1:noc) = populations (worstIndex, 1:noc);
bestLoads (1,1:noc) = loads (bestIndex, 1:noc);
worstLoads (1,1:noc) = loads (worstIndex, 1:noc);
bestPackets (1,1:n) = packets (bestIndex, 1:n);
cap = 7800;
for m = 1 : noc
    if (bestLoads(1,m) > cap)
        bestLoads(2,m) = 0;
    else
        bestLoads(2,m) = 1;
    end
end
[xx1, xx2, optConn2, optSp2, xx3, xx4] = capacitedRandomCost (bestLocations, mat, n, 1);
optConn = optConn2;
optSp = optSp2;

%run load balancing algorithm 
    flag = 1; %indicator
    % overloadedController = 0; %the controller which is overloaded
    modifyIndex = 0; %the index of the controller in the controllers list which is overloaded
    totalLoad = 0; %to store the total load
    for j = 1 : noc %for each controller
        totalLoad = totalLoad + bestLoads(1,j); %add the load of jth controller
    end
    if ((totalLoad/noc) <= cap)
        bestLoads
        totalLoad2 = 0;
        while (flag == 1 && totalLoad2/noc <= cap) %load balancing will be done till any overloaded controller is found
            flag = 0; %reset flag to 0
            for i = 1 : noc %for each controller
                if (bestLoads(2,i) == 0) %if it is overloaded or idle
                    flag = 1; %update the indicator
                    modifyIndex = i; %index of the overloaded controller in controllers list
%                     overloadedController = controllerList (i); %update the overloaded controller position
                    break; %break the loop
                end
            end
            if (flag == 1) %if indicator is updated
                [balance, newConnections, newLoads, ccc] = loadBalancing (bestLocations, bestLoads, optSp, bestPackets, optConn, modifyIndex, n, noc, 1, cap); %run load balancing algorithm
                bestLoads = newLoads %update the loads
                optConn = newConnections; %update the connections
                totalLoad2 = 0; %to store the total load
                for j = 1 : noc %for each controller
                    totalLoad2 = totalLoad2 + bestLoads(1,j); %add the load of jth controller
                end
%                 newNoc = ccc;
            end
        end
    end
    %updating the toal cost
    bestFitness = bestFitness - totalLoad;
    for j = 1 : noc
        bestFitness = bestFitness + bestLoads(1,j);
    end
    optLat = avgLatency(optConn, n, n, noc, bestLocations);
end
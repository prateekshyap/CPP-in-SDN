function [ cand, candF, candF2, minFitness, minFitnessF, minFitnessF2, optLoad, optConn] = optimalCandidatesFailure( d, dF, dF2, noc, mat, n )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    c = combnk (d,noc); %storing all the combinations
    cF = combnk (dF,noc);
    cF2 = combnk (dF2,noc);
    s = size(c);
    optConn = 0;
    noi = s(1,1); %no of iterations
    s = size(cF);
    noiF = s(1,1); %no of iterations for one failure
    s = size(cF2);
    noiF2 = s(1,1); %no of iterations for second failure
    cand = zeros (1,noc); %candidate combination
    minFitness = 1000000; %a variable to store the minimum fitness value
    minFitnessF = 1000000; %a variable to store the minimum fitness value for one failure
    minFitnessF2 = 1000000; %a variable to store the minimum fitness value for second failure
    optLoad = zeros (1,noc); %an array to store the minimum loads
    for i = 1 : noi %for each combination of controllers
        [l, f, lat, conn] = capacitedCostLatency(c(i,1:noc), mat, n); %finding out the total cost of the network for fs
        if (f < minFitness) %if the new fitness value is less than the optimal value
            minFitness = f; %update the minimum fitness value
            cand = c(i,1:noc); %update the candidate combination
            optLoad = l; %update the optimal loads
            optConn = conn;
        end
    end
    for i = 1 : noiF %for each combination of controllers for one failure
        [lF, fF, latF, connF] = costWithFailure(cF(i,1:noc), mat, n, 1); %finding out the total cost for 1 failure
        if (fF < minFitnessF) %if the new fitness value is less than the optimal value
            minFitnessF = fF; %update the minimum fitness value
            candF = cF(i,1:noc); %update the candidate combination
%             optLoad = loads; %update the optimal loads
%             optConn = conn;
        end
    end
    for i = 1 : noiF2 %for each combination of controllers for second failure
        [lF3, fF2, latF2, connF2] = costWithFailure(cF2(i,1:noc), mat, n, 2); %finding out the total cost for second failure
        if (fF2 < minFitnessF2) %if the new fitness value is less than the optimal value
            minFitnessF2 = fF2; %update the minimum fitness value
            candF2 = cF2(i,1:noc); %update the candidate combination
%             optLoad = loads; %update the optimal loads
%             optConn = conn;
        end   
    end
end
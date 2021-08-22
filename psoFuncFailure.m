function [ optCost, optCostF, optCostF2, optLoc, optLoad, lat ] = psoFuncFailure( iterations, c1, c2, r1, r2, w, wDamp, populationSize, mat, n, latlong, noc, populations )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lat = 0;
coOrd = 2*noc; %total number of coordinates for a single position
    
    %% storing the latitude and longitude values of the initial population
    % node is a structure containing x and y coordinates of any node
    node.xCoord = [];
    node.yCoord = [];
    
    initialPositions = repmat(node,populationSize,noc);
    for i = 1 : populationSize
        for j = 1 : noc
            initialPositions(i,j).xCoord = latlong(populations(i,j),1);
            initialPositions(i,j).yCoord = latlong(populations(i,j),2);
        end
    end
    
    %% printing the coordinates of the population
%     for kk = 1 : populationSize
%         for j = 1 : noc
%             xVal = initialPositions(kk,j).xCoord;
%             yVal = initialPositions(kk,j).yCoord;
%             fprintf('%4.4f\t%4.4f\t',xVal,yVal);
%         end
%         fprintf('\n');
%     end
    
    %% running the pso algorithm
    [bestCosts, optLoc, optCost, optLoad, latVal] = particleSwarmOptimization(iterations, c1, c2, r1, r2, w, wDamp, initialPositions, populations, populationSize, coOrd, mat, n, latlong);
    lat = latVal;
    [l, optCostF, t, con] = costWithFailure(optLoc,mat,n,1);
    [l, optCostF2, t, con] = costWithFailure(optLoc,mat,n,2);
%     y(noc) = optCost;
%     optLoc
end
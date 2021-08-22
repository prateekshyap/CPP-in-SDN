function [controllerPositions, chromosome] = findInitialChromosome (mat, n, threshold)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%calculating the degree
k = 1; %index for controllerPositions
degrees = zeros (1,n); %to hold the degrees of all the nodes
chromosome = zeros (1,n); %a binary array to represent the chromosome string
for i = 1 : n %for each node
    for j = 1 : n %for each other node
        if ((i ~= j)&&(mat (i,j) ~= 0)) %if the node is connected to other node
            degrees (1,i) = degrees(1,i) + 1; %increment its degree by 1
        end
    end
    if (degrees (1,i) >= threshold) %if the node degree is greater than the threshold degree
        controllerPositions (1,k) = i;  %store the node as a controller, i-1 will be i if graph doesn't contain 0th node
        chromosome (1,i) = 1; %store 1 for the particular node (as it is a controller)
        k = k + 1; %increment the index by 1
    else
        chromosome (1,i) = 0; %store 0 for the particular node (as it is not a controller)
    end
end
end
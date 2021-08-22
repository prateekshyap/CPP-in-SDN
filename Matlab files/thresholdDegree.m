function [degrees, controllerPositions] = thresholdDegree (mat, n, threshold)
% function [degrees, controllerPositions] = thresholdDegree( mat, n, threshold )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%calculating the degree
k = 1; %index for controllerPositions
maxDegree = 0; %a variable to store the maximum degree of the network
degrees = zeros (1,n); %to hold the degrees of all the nodes
for i = 1 : n %for each node
    for j = 1 : n %for each other node
        if ((i ~= j)&&(mat (i,j) ~= 0)) %if the node is connected to other node
            degrees (1,i) = degrees(1,i) + 1; %increment its degree by 1
        end
    end
    if (degrees (1,i) >= threshold) %if the node degree is greater than the threshold degree
        controllerPositions (1,k) = i;  %store the node as a controller, i-1 will be i if graph doesn't contain 0th node
        k = k + 1; %increment the index by 1
    end
    if (degrees (1,i) >= maxDegree) %if the node degree is greater than maximum degree
        maxDegree = degrees (1,i); %update the maximum degree
    end
end
%normalizing the degrees
% for i = 1 : n
%     degrees (1,i) = 1 + (degrees (1,i)/maxDegree);
% end
end
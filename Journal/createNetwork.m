function [ sp, connections, connectionsF, controllersList, switchController ] = createNetwork( shortestPathMatrix, m, n, noc, fs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%create the shortest path matrix for the required controllers
for i = 1 : noc
    sp(i,1:n) = shortestPathMatrix(fs(i),1:n);
end
fs = sort(fs);
connections = sp; %for no failure
connectionsF = sp; %for failure 
controllersList = zeros (m+1, n); %List of controllers for each level for all the switches
controllerMesh = zeros (noc, noc); %Shortest path distances between the controllers
switchController = zeros (m+1, n); %List of distances for each level of controllers
cIn = 1; %controllers index
%divide the switches among the controllers
for k = 1 : n %for each node
    %finding out the minimum distance
    min = connections (1,k); %the shortest path from 1st controller is assumed to be the minimum
    for j = 2 : noc %for each controller except the 1st one
        if (connections (j,k) == 0) %if minimum distance is 0 or shortest path is 0
            break; %stop the inner loop
        elseif (min == 0) %if minimum is zero
            min = connections (j,k); %update it to the next value
        elseif (connections (j,k) >= min) %if the node has shortest path from 1st controller less than that of the current controller
            connections (j,k) = 0; %connect the node to the 1st controller
        else %if the node is closer to any controller other than the 1st one
            min = connections (j,k); %minimum distance is updated
        end
    end
    %disconnecting from other nodes
    for mm = 1 : noc %for each controller
        if (connections (mm,k) ~= min) %if the distance is not minimum
            connections (mm,k) = 0; %disconnect them
        end
    end 
%     %adding 0 to every controller
%     for nn = 1 : noc %for each controller
%         connections(1:noc,fs(nn)) = zeros(noc,1);
%     end
    connectionsF = connections;
    %disconnecting from other nodes and updating the first level controllers
    for g = 1 : noc %for each controller
        if (connectionsF (g,k) ~= min) %if the distance is not minimum
            connectionsF (g,k) = 0; %disconnect them
        elseif (k == fs (cIn)) %if the distance is minimum and kth node is not a controller
            cIn = cIn + 1; %increment the index by 1
            if (cIn > noc) %if all the controllers are checked
                cIn = 1; %update the index to 1
            end
        elseif (k ~= fs(cIn)) %if kth node is a controller
            controllersList (1,k) = fs(1,g); %update the first level controller for the node
            switchController (1,k) = sp(g,k); %update the first level distance for the node
        end
    end
end
%updating the controller connections
ind = 1; %index for the controllers
for j = 1 : n %for each node
    controllerMesh (1:noc, ind) =  sp (1:noc, fs(1,ind)); %storing the controller distances to the matrix
    ind = ind + 1; %increment the index by 1
    if (ind > noc) %if all the distances are stored
        break; %break the loop
    end
end
%updating the next level controllers for all the switches
for j = 1 : n %for each switch
    if (controllersList (1,j) == 0) %if the jth node is a controller itself
        continue; %don't execute the loop further
    end
    pp = controllerMesh; %copying the controllerMesh matrix to pp
    %updating the diagonal to infinite value
    for t = 1 : noc %for each controller
        pp (t,t) =999; %disconnect the principal diagonal
    end
    for r = 2 : m+1 %for each level
        previousController = controllersList (r-1, j); %previous level controller
        previousIndex = 0; %index of previousController in 'controllers' array
        %finding out the index of the previous controller
        for t = 1 : noc %for each controller present in controllers array
            if (previousController == fs (1,t)) %if previousController is equal to the 't'th controller
                previousIndex = t; %update the index to be t
            end
        end
        %finding out the closest controller for next level
        minControllerIndex = 1; %let the index of the closest controller be 1
        for u = 1 : noc %for each controller
            if (pp (previousIndex, u) < pp (previousIndex,minControllerIndex)) %if the distance is found to be less
                minControllerIndex = u; %update the index of the closest controller
            end
        end
        controllersList (r,j) = fs (1,minControllerIndex); %store the next level controller
        switchController (r,j) = switchController (r-1,j) + sp(previousIndex,fs(1,minControllerIndex));%store the level distances
        %updating the previous controller connections to infinite
        for t = 1 : noc %for each controller
            pp (previousIndex, t) = 999; %disconnect the failed controller from each other controller
            pp (t, previousIndex) = 999; %disconnect all the controllers from the failed controller
        end
    end
end
end


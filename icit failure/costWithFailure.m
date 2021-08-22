function [ controllerLoad, totalCost, totalLat, connections ] = costWithFailure( controllers,mat,n,m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    s = size (controllers);
    noc = s (1,2); %noc = no of controllers
    sp = zeros (noc, n); %to store the shortest paths from all the controllers individually taken as sources
    connections = zeros (noc, n); %to store the connections
    totalCost = 0; %a variable to store the total cost
    controllerLoad = zeros (2,noc); %to store the loads of individual controllers
    controllerCost = 0; %to store the total cost of the controllers
    %find out the shortest paths
    for i = 1 : noc %for each conttroller
%         n
        sp (i, 1:n) = bellmanFord (n, mat, controllers(i)); %calculate the shortest paths
%         sp
        connections = sp; %copying the values to connections
    end
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
        %disconnecting from other nodes and updating the first level controllers
        for g = 1 : noc %for each controller
            if (connections (g,k) ~= min) %if the distance is not minimum
                connections (g,k) = 0; %disconnect them
            elseif (k ~= controllers (1,cIn)) %if the distance is minimum and kth node is not a controller
                controllersList (1,k) = controllers (1,g); %update the first level controller for the node
                switchController (1,k) = sp (g,k); %update the first level distance for the node
            else %if kth node is a controller
                cIn = cIn + 1; %increment the index by 1
                if (cIn > noc) %if all the controllers are checked
                    cIn = 1; %update the index to 1
                end
            end
        end
    end
    %updating the controller connections
    in = 1; %index for the controllers
    for j = 1 : n %for each node
%         in
%         noc
%         sp
%         controllerMesh
%         controllers
        controllerMesh (1:noc, in) =  sp (1:noc, controllers (1,in)); %storing the controller distances to the matrix
        in = in + 1; %increment the index by 1
        if (in > noc) %if all the distances are stored
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
                if (previousController == controllers (1,t)) %if previousController is equal to the 't'th controller
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
            controllersList (r,j) = controllers (1,minControllerIndex); %store the next level controller
            switchController (r,j) = switchController (r-1,j) + sp(previousIndex,controllers(1,minControllerIndex));%store the level distances
            %updating the previous controller connections to infinite
            for t = 1 : noc %for each controller
                pp (previousIndex, t) = 999; %disconnect the failed controller from each other controller
                pp (t, previousIndex) = 999; %disconnect all the controllers from the failed controller
            end
        end
    end
%   finding out the cost
%     fixedCost = 0.65; %fixed cost for the controllers
    fixedCost = 6500; %fixed cost for the controllers
    packets = 500; %in kilo requests per second
%     packets = randi ([200 600], 1, n); %in kilo requests per second
    controllerCapacity = 7800; %in kilo requests for second
    costPerUnit = 1; %in dollars
%     pf = 0.25; %probability of failure
    pf = 0.01 + (0.25-0.01).*rand (1,n); 
    x = 0; %binary variable for controller
    y = 0; %binary variable for switch connection
    p = 1; %index for controllers
    for i = 1 : noc %for each controller
        for j = 1 : n %for each node
            for r = 1 : m+1 %for each level
                %setting the value of x
                if (p <= noc && j == controllers (1,p)) %if the controller is not counted and jth node is equal to the controller
                    x = 1; %set x to 1 to add the controller cost
                    p = p + 1; %increment the index
                else
                    x = 0; %set x to 0 to keep the node out of counting
                end
                %setting the value of y
                if ((x == 0)&&(controllersList (r,j) ~= 0)&&(controllersList (r,j) == controllers (1,i))) %if jth node is not a controller and ith node is a controller at rth level for jth node
                    y = 1; %set y to 1
                else
                    y = 0; %set y to 0 to keep the node out of counting
                end
                %calculating total cost, cost of controllers, loads of individual controllers
                if (x <= noc) %x must be less than the number of controllers
%                     controllerLoad (1,i) = controllerLoad (1,i) + (packets * sp (i,j) * costPerUnit * y);
                    controllerLoad (1,i) = controllerLoad (1,i) + (packets * y);
                    controllerCost = controllerCost + (fixedCost *x);
%                     totalCost = totalCost + (fixedCost * x) + (packets * sp (i,j) * costPerUnit * y); %calculating the total cost
                    totalCost = totalCost + (fixedCost * x) + (packets * switchController (r,j) * (pf (1,j) ^ (r-1)) * (1-pf (1,j)) * y); %calculating the total cost
                end
%                 controllerLoad
            end    
        end
    end
    totalLat = avgLatency (connections, n, n, noc, controllers);
    for i = 1 : noc %for each controller
        if (controllerLoad (1,i) > controllerCapacity) %if the load is more than capacity
            controllerLoad (2,i) = 0; %store 0
        else
            controllerLoad (2,i) = 1; %store 1
        end
    end
end
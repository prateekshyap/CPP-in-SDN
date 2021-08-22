function [ avgLat ] = plannedAverageLatency (controllers, mat, n, m)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    s = size (controllers);
    noc = s (1,2); %noc = no of controllers
    sp = zeros (noc, n); %to store the shortest paths from all the controllers individually taken as sources
    connections = zeros (noc, n); %to store the connections
    totalCost = 0; %a variable to store the total cost
    controllerCost = 0; %to store the total cost of the controllers
    %find out the shortest paths
    for i = 1 : noc %for each controller
        sp (i, 1:n) = bellmanFord (n, mat, controllers (i)); %calculate the shortest paths
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
    %calculating the average latency
    avgLat = zeros (1,m+1); %an array to store the average latency for each level
    %for no failure
    switchSum = 0;
    controllerSum = 0;
    for j = 1 : n %for each switch
        switchSum = switchSum + switchController (1,j); %adding the 1st level latencies
    end
    for i = 1 : noc %for each controller
        for ii = 1 : noc %for each other controller
            if (i<ii)
                controllerSum = controllerSum + controllerMesh (i,ii); %add the controller latencies
            end
        end
    end
%     avgLat (1,1) = (switchSum / n) + (controllerSum / noc);
    avgLat (1,1) = switchSum / n;
    %for one failure
    noOfCases = noc; %number of failure cases
    caseSum = 0; %sum of latencies of all teh failure cases
    for i = 1 : noc %for each failed controller 
        failedControllers = 1; %number of failed controllers
        switchSum = 0;
        controllerSum = 0;
        %finding out the intercontroller latencies
        pp = controllerMesh;
        for t = 1 : noc %for each controller
            %disconnect the failed controller
            pp (i,t) = 0;
            pp (t,i) = 0;
        end
        for k = 1 : noc %for each controller
            for ii = 1 : noc %for each other controller
                if (k<ii)
                    controllerSum = controllerSum + pp (k,ii); %add the controller latencies
                end
            end
        end
        %finding out the sum of latencies of switch and controller
        for j = 1 : n %for each switch
            if (controllersList (1,j) == controllers (1,i)) %if the primary controller is i i.e. the failed controller
                switchSum = switchSum + switchController (2,j); %add the backup distance
            else
                switchSum = switchSum + switchController (1,j); %add the primary distance
            end
        end
        %finding out the total latency for all the cases
%         caseSum = caseSum + ((switchSum / n) + (controllerSum / (noc - failedControllers)));
        caseSum = caseSum + (switchSum / n);
    end
    avgLat (1,2) = caseSum / noOfCases; %storing the average latency for backup level
    %for load balancing
    noOfCases = noc; %number of failure cases
%     controllerCapacity = 5000; %capacity of the controller in kilo requests per second
    caseSum = 0; %sum of latencies of all teh failure cases
    for i = 1 : noc %for each failed controller 
        failedControllers = 1; %number of failed controllers
        switchSum = 0;
        controllerSum = 0;
        %finding out the intercontroller latencies
        pp = controllerMesh;
        for t = 1 : noc %for each controller
            %disconnect the failed controller
            pp (i,t) = 0;
            pp (t,i) = 0;
        end
        for k = 1 : noc %for each controller
            for ii = 1 : noc %for each other controller
                if (k<ii)
                    controllerSum = controllerSum + pp (k,ii); %add the controller latencies
                end
            end
        end
        %finding out the sum of latencies of switch and controller
        for j = 1 : n %for each switch
            workingControllers = zeros (1,noc-1); %to store the working controllers
            index = 1; %index for working controllers
            %finding out the list of working controllers
            for d = 1 : noc %for each controller
                if (d ~= i) %if the controller is not failed
                    workingControllers (1,index) = controllers (1,d); %add it to the list of working controllers
                    index = index + 1;
                end
            end
            controllerLoad = controllerLoadPlanning (controllers, workingControllers, mat, n, controllers (1,i), controllersList, switchController, sp, connections); %find out the load of each controller
            if (controllersList (1,j) == controllers (1,i)) %if the primary controller is i i.e. the failed controller
                %finding out the index of the backup level working
                %controller
                backupIndex = 1;
                for h = 1 : noc-1 %for each working controller
                    if (controllersList (2,j) == workingControllers (1,h)) %if the backup controller is equal to 'h'th working controller
                        backupIndex = h; %update the index of the backup controller
                    end
                end
                if (controllerLoad (2,h) == 0) %if the backup controller is unable to handle the load
                    switchSum = switchSum + switchController (3,j); %add the load balancing distance
                else
                    switchSum = switchSum + switchController (2,j); %add the backup distance
                end
            else
                switchSum = switchSum + switchController (1,j); %add the primary distance
            end
        end
        %finding out the total latency for all the cases
%         caseSum = caseSum + ((switchSum / n) + (controllerSum / (noc - failedControllers)));
        caseSum = caseSum + (switchSum / n);
    end
    avgLat (1,3) = caseSum / noOfCases; %storing the average latency for backup level
end
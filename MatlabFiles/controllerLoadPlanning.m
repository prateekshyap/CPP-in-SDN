function [ controllerLoad ] = controllerLoadPlanning(controllers, wc, mat, n, f, controllersList, switchController, sp, connections)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% controllers = original list of controllers
% wc = list of working controllers after failure of a controller
% mat = adjacency matrix of the network
% n = number of nodes
% f = failed controller
    s = size (controllers);
    noc = s (1,2);
    ntc = noc; %ntc = total number of controllers
    noc = noc - 1; %noc = number of working controllers
    totalCost = 0; %a variable to store the total cost
    controllerLoad = zeros (2,noc); %to store the loads of individual controllers
    controllerCost = 0; %to store the total cost of the controllers
    %calculate the index of the failed controller
    failedIndex = 1;
    for fi = 1 : ntc %for each controller
        if (controllers (1,fi) == f)
            failedIndex = fi;
        end
    end
    %updating the distance for all the switched connected to failed
    %controller at first level
    in = 1; %to keep track of the controllers
    for j = 1 : n %for each node
        if (j == controllers (1,in)) %if the node is a controller
            in = in + 1; %increment the controller index
            if (in > ntc) %if all the controllers are checked
                in = 1; %ignore the controller index
            end
            continue; %don't execute the loop
        else
            if (controllersList (1,j) == f) %if the 1st level controller of jth switch is the failed controller
                sp (failedIndex, j) = switchController (2,j); %update the shortest path for jth switch
            end
        end
    end
    %disconnecting the failed controller
    for t = 1 : ntc %for each controller
        connections (t,f) = 0;
    end
    %calculating the controller load
    fixedCost = 0.65; %fixed cost for the controllers
%    fixedCost = 6500; %fixed cost for the controllers
    packets = 400; %in kilo requests per second
%     controllerCapacity = 7.8e+6; %in kilo requests per second
    controllerCapacity = 5000; %in kilo requests per second
    costPerUnit = 29; %in dollars
%     x = 0; %binary variable for controller
%     y = 0; %binary variable for switch connection
    p = 1; %index for controllers
    for i = 1 : noc %for each controller
        for j = 1 : n %for each node
            %setting the value of x
            if (p <= noc && j == wc (1,p)) %if the controller is not counted and j is equal to the controller
                 x = 1; %set x to 1 to add the controller cost
                 p = p + 1; %increment the index
            else
                 x = 0; %set x to 0 to keep the node out of counting
            end
            %setting the value of y
            if ((connections (i,j) ~= 0)&&(x == 0)) %if jth node is connected to the ith controller and jth node is not counted with x
                y = 1; %set y to 1 to count the node
                for k = 1 : noc %for each controller
                    if (j == wc (1,k)) %if jth node is a controller
                        y = 0; %keep the node out of counting
                    end
                end
            else
                y = 0; %keep the node out of counting
            end
            %calculating total cost, cost of controllers, loads of individual controllers
            if (x <= noc) %x must be less than the number of controllers
%                 controllerLoad (1,i) = controllerLoad (1,i) + (packets * sp (i,j) * costPerUnit * y);
                controllerLoad (1,i) = controllerLoad (1,i) + (packets * sp (i,j) * y);
                controllerCost = controllerCost + (fixedCost *x);
%                 totalCost = totalCost + (fixedCost * x) + (packets * sp (i,j) * costPerUnit * y); %calculating the total cost
                totalCost = totalCost + (fixedCost * x) + (packets * sp (i,j) * y); %calculating the total cost
            end
        end
    end
    for i = 1 : noc %for each controller
        if (controllerLoad (1,i) > controllerCapacity) %if the load is more than capacity
            controllerLoad (2,i) = 0; %store 0
        else
            controllerLoad (2,i) = 1; %store 1
        end
    end
end
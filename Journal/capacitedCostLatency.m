function [ controllerLoad, totalCost, totalLat, connections ] = capacitedCostLatency( controllers, mat, n, sp, connections )
%%function [ controllerLoad ] = capacitedCost( controllers, mat, n)
%%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    s = size (controllers);
    noc = s (1,2); %noc = no of controllers
    sp = zeros (noc, n); %to store the shortest paths from all the controllers individually taken as sources
    connections = zeros (noc, n); %to store the connections
    totalCost = 0; %a variable to store the total cost
    totalLat = 0;
%     controllerLoad = zeros (2,noc); %to store the loads of individual controllers
    controllerLoad = zeros (1,noc); %to store the loads of individual controllers
    controllerCost = 0; %to store the total cost of the controllers
%     fixedCost = 0.65; %fixed cost for the controllers
   fixedCost = 6500; %fixed cost for the controllers
%     fixedCost = 0;
   packets = 500; %in kilo requests per second
%     controllerCapacity = 7.8e+6; %in kilo requests per second
    controllerCapacity = 7800; %in kilo requests per second
%     packets = randi ([200 600], 1, n); %in kilo requests per second
%     controllerCapacity = 7800; %in kilo requests for second
    costPerUnit = 1; %in dollars
%     x = 0; %binary variable for controller
%     y = 0; %binary variable for switch connection
    p = 1; %index for controllers
    for i = 1 : noc %for each controller
        for j = 1 : n %for each node
            %setting the value of x
            if (p <= noc && j == controllers (1,p)) %if the controller is not counted and j is equal to the controller
                 x = 1; %set x to 1 to add the controller cost
                 p = p + 1; %increment the index
            else
                 x = 0; %set x to 0 to keep the node out of counting
            end
            %setting the value of y
            if ((connections (i,j) ~= 0)&&(x == 0)) %if jth node is connected to the ith controller and jth node is not counted with x
                y = 1; %set y to 1 to count the node
                for k = 1 : noc %for each controller
                    if (j == controllers (1,k)) %if jth node is a controller
                        y = 0; %keep the node out of counting
                    end
                end
            else
                y = 0; %keep the node out of counting
            end
            %calculating total cost, cost of controllers, loads of individual controllers
            if (x <= noc) %x must be less than the number of controllers
%                 controllerLoad (1,i) = controllerLoad (1,i) + (packets (1,j) * sp (i,j) * costPerUnit * y);
                controllerLoad (1,i) = controllerLoad (1,i) + (packets * sp (i,j)* y);
                controllerCost = controllerCost + (fixedCost *x);
%                 totalCost = totalCost + (fixedCost * x) + (packets (1,j) * sp (i,j) * costPerUnit * y); %calculating the total cost
                totalCost = totalCost + (fixedCost * x) + (packets * sp (i,j) * y); %calculating the total cost
%                 totalCost = totalCost + (packets (1,j) * sp (i,j) * y); %calculating the total cost
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
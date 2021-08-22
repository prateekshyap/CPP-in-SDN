fileName = 'Janetbackbone.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
th = 5; %threshold
% %           1  2  3  4  5  6  7  8  9 10 11 12 13
% mat =     [ 0  4  4  6  0  0  0  0  0  0  0  0  0; %1
% 			4  0  5  0  0  0  0  7  0  0  0  0  0; %2
% 			4  5  0  8  1  0  0  0  0  0  0  0  0; %3
% 			6  0  8  0  0  3  0  0  0  0  0  0  0; %4
% 			0  0  1  0  0  0  3  0  0  0  0  0  0; %5
% 			0  0  0  3  0  0  4  0  0  6  0  0  0; %6
% 			0  0  0  0  3  4  0  3  2  0  0  0  0; %7
% 			0  7  0  0  0  0  3  0  0  0  0  5  0; %8
% 			0  0  0  0  0  0  2  0  0  0  4  0  0; %9
% 			0  0  0  0  0  6  0  0  0  0  7  0  8; %10
% 			0  0  0  0  0  0  0  0  4  7  0  5  6; %11
% 			0  0  0  0  0  0  0  5  0  0  5  0  7; %12
% 			0  0  0  0  0  0  0  0  0  8  6  7  0; %13
%  			];
%         n = 13;
%         th = 4;
alpha = 1; %constant
cap = 5000; %capacity of the controller
[d, controllerList] = thresholdDegree (mat, n, th); %obtaining the controller positions
controllerList
s = size (controllerList);
noc = s (1,2); %number of controllers
[controllerLoad, packets, sp, connections, totalCost] = capacitedRandomCost (controllerList, mat, n, alpha); %finding out the loads
sp
connections
packets
controllerLoad
flag = 1; %indicator
% overloadedController = 0; %the controller which is overloaded
modifyIndex = 0; %the index of the controller in the controllers list which is overloaded
while (flag == 1) %load balancing will be done till any overloaded controller is found
    flag = 0; %reset flag to 0
    for i = 1 : noc %for each controller
        if (controllerLoad(2,i) == 0 || controllerLoad(1,i) == 0) %if it is overloaded or idle
            flag = 1; %update the indicator
            modifyIndex = i; %index of the overloaded controller in controllers list
%             overloadedController = controllerList (i); %update the overloaded controller position
            break; %break the loop
        end
    end
    if (flag == 1) %if indicator is updated
        [balance, newConnections, newLoads, noc] = loadBalancing (controllerList, controllerLoad, sp, packets, connections, modifyIndex, n, noc, alpha, cap); %run load balancing algorithm
        controllerLoad = newLoads; %update the loads
        connections = newConnections; %update the connections
        newConnections
        newLoads
        noc
    end
end
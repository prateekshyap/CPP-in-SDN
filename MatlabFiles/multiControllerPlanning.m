function [] = multiControllerPlanning (mat, n, maxController)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
in = 1; %index for the array which will be plotted
x = zeros (1, maxController-1); %number of controllers
yPrimary = zeros (1, maxController-1); %average latency for no failure
yBackup = zeros (1, maxController-1); %avergae latency for one failure
yLoadBalance = zeros (1, maxController-1); %average latency for load balancing
for noc = 2 : maxController %noc = number of controllers
    x (in) = noc; %storing the number of controllers in x-axis
    c = combnk (1 : n,noc); %storing all the combinations
    noi = factorial (n) / (factorial (noc) * factorial (n-noc)); %noi = no of iterations = no of combinations
    minPrimaryLatency = 1000; %minimum average latency for no failure
    optimalPrimaryPositions = zeros (1,noc); %to store the optimal positions of the controllers for no failure
    minBackupLatency = 1000; %minimum average latency for one failure
    optimalBackupPositions = zeros (1,noc); %to store the optimal positions of the controllers for one failure
    minLoadBalanceLatency = 1000; %minimum average latency for load balancing
    optimalLoadBalancePositions = zeros (1,noc); %to store the optimal positions of the controllers for load balancing
    for i = 1 : noi %for each combination of controllers
       avgLat = plannedAverageLatency (c(i,1:noc), mat, n, 2); %calculating the global latency for ith combination of controllers
       if (avgLat (1,1) < minPrimaryLatency) %if the calculated latency is less than optimal latency for no failure
           minPrimaryLatency = avgLat (1,1); %updating the optimal latency
           optimalPrimaryPositions = c (i,1:noc); %updating the optimal controller positions
       end
       if (avgLat (1,2) < minBackupLatency) %if the calculated latency is less than optimal latency for one failure
           minBackupLatency = avgLat (1,2); %updating the optimal latency
           optimalBackupPositions = c (i,1:noc); %updating the optimal controller positions
       end
       if (avgLat (1,3) < minLoadBalanceLatency) %if the calculated latency is less than optimal latency for oad balancing
           minLoadBalanceLatency = avgLat (1,3); %updating the optimal latency
           optimalLoadBalancePositions = c (i,1:noc); %updating the optimal controller positions
       end
       
       
    end
    optimalPrimaryPositions = optimalPrimaryPositions - 1; %not needed if graph doesn't contain 0th node
    optimalBackupPositions = optimalBackupPositions - 1; %not needed if graph doesn't contain 0th node
    optimalLoadBalancePositions = optimalLoadBalancePositions - 1; %not needed if graph doesn't contain 0th node
    yPrimary (in) = minPrimaryLatency; %storing the optimal average latency in y-axis for no failure
    yBackup (in) = minBackupLatency; %storing the optimal average latency in y-axis for one failure
    yLoadBalance (in) = minLoadBalanceLatency; %storing the optimal average latency ini y-axis for load balancing
    in = in + 1; %incrementing the index by 1
    fprintf ('For %d controllers- ',noc);
    optimalPrimaryPositions
    minPrimaryLatency
    optimalBackupPositions
    minBackupLatency
    optimalLoadBalancePositions
    minLoadBalanceLatency
    fprintf ('\n');
end

%line graph
% plot (x,yPrimary);
% hold on;
% plot (x,yBackup);
% hold on;
% plot (x,yLoadBalance);
% title ('Controller Placement With Planning');
% xlabel ('Number of Controllers');
% ylabel ('Average latency');
% legend ('No failure','One Failure','Load Balancing');

%bar graph
y = [yPrimary; yBackup; yLoadBalance];
y = y';
h = bar(y,1);
set(gca,'xticklabel',x);
title ('Controller Placement With Planning');
xlabel ('Number of Controllers');
ylabel ('Average latency');
legend ('r = 0','r = 1','r = 2');

fH = gcf;
colormap(jet(4));


% Apply Brandon's function
tH = title('Controller Placement With Planning');
applyhatch_pluscolor(fH, '\-x.', 0, [1 0 1 0], jet(4));

set(tH, 'String', 'Controller Placement With Planning');
end
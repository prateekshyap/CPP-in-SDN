%{
    saTime = an array to store the execution times for simulated
    annealing
    randTime = an array to store the execution times for random algorithm
    maxNoc = the maximum value to which the loop will run
    ySa = costs for simulated annealing
    yRand = Costs for random algorithm
    maxIterations = maximum number of iterations in genetic algorithm
%}
clear all;
close all;
fileName = 'Janetbackbone.graphml'; %network
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
xx = zeros (1,2); %x values
index = 1; %to keep track of the arrays
maxNoc = 2; %maximum number of controllers
maxIterations = 500; %maximum number of iterations
temps = zeros (2,2); %to store the temperatures
saCosts = zeros (2,2); %to store the respective costs
saCostsF = zeros (2,2); %to store the respective costs
saCostsF2 = zeros (2,2); %to store the respective costs
saIter = zeros (2,2); %to store the total number of temperature changes
% Simulated Annealing by changing the positions of the controllers
ySa = zeros (1,2); %to store the costs
ySaF = zeros (1,2);
ySaF2 = zeros (1,2);
latSa = zeros (1,2); %to store the latencies
saTime = zeros (1,2); 
yRand = zeros (1,2); %to store the costs
latRand = zeros (1,2); %to store the latencies
randTime = zeros (1,2); 
for cont = 1 : maxNoc %for each number of controllers
    tic;
    fprintf ('SA');
    [controllers, cost, costF, costF2, lat, loads, xTemps, yCosts, yCostsF, yCostsF2, xxIts, counter, randCont, optConnSa] = simulatedAnnealingFailure(mat, n, 10, 0.001, maxIterations, 0.95, cont);
    cont
    cost
    costF
    costF2
    xx (1, index) = cont; %update the x values
    ySa (1, index) = cost; %update the costs
    ySaF (1, index) = costF;
    ySaF2 (1, index) = costF2;
    latSa (1, index) = lat; %update the latencies
    saTime (1, index) = toc; %update the execution time
    temps (index, 1:counter) = xTemps;
    saCosts (index, 1:counter) = yCosts;
    saCostsF (index, 1:counter) = yCostsF;
    saCostsF2 (index, 1:counter) = yCostsF2;
    saIter (index, 1:counter) = xxIts;
    tic;
        fprintf('Random placement');
%         randCont = randi(n,1,cont);
        [l, c, ttt, conn] = capacitedCostLatency (randCont, mat, n); %finding out the cost
        yRand (1, index) = c; %storing the costs
        latRand (1, index) = avgLatency(conn, n, n, cont, randCont);
        randTime (1, index) = toc; %update the execution time
        cont
        yRand (1, index)
        randCont     
    index = index + 1; %increment the index
end
%{
index = 1; %reset the index
%random
yRand = zeros (1,2); %to store the costs
randTime = zeros (1,2); 
for cont = 1 : maxNoc %for each number of controllers
        tic;
%         randCont = randi ([1 n],1,cont); %generating random controllers
        [l, c] = capacitedCost1 (randCont, mat, n); %finding out the cost
        yRand (1, index) = c; %storing the costs
        randTime (1, index) = toc; %update the execution time
        cont
        yRand (1, index)
        randCont     
        index = index + 1; %incrementing the index
end
index = 1; %reset the index
%}

y = [yRand; ySa; ySaF; ySaF2]; %merge the costs to a single matrix for bar plot
yLat = [latRand; latSa]; %merge the latencies to a single matrix for bar plot

figure; %bar plot for no of controllers vs costs
% bar (y',1);
% ylabel ('Fitness Function');
% xlabel ('Number of Controllers');
% legend ('Random','SA','GA');

h = bar(y',1);
% set(gca,'xticklabel',x);
% title ('Scenario- 1');
ylabel ('Cost');
xlabel ('Number of Controllers');
legend ('Random','SA');

fH = gcf;
colormap(jet(4));


% Apply Brandon's function
% tH = title('Scenario- 1');
applyhatch_pluscolor(fH, '\-x.', 0, [1 0 1 0], jet(4));

% set(tH, 'String', 'Scenario- 1');

t = [randTime; saTime]; %merge the times to a single matrix for bar plot

% figure; %bar plot for no of controllers vs latencies
% bar (yLat',1);
% ylabel ('Latency');
% xlabel ('Number of Controllers');
% legend ('Random','SA');
% 
% figure; %bar plot for no of controllers vs execution times
% % bar (t',1);
% % ylabel ('Execution Time');
% % xlabel ('Number of Controllers');
% % legend ('Random','SA','GA');
% 
% h2 = bar(t',1);
% % set(gca,'xticklabel',x);
% % title ('Scenario- 1');
% ylabel ('Execution Time');
% xlabel ('Number of Controllers');
% legend ('Random','SA');
% 
% fH2 = gcf;
% colormap(jet(4));


% % Apply Brandon's function
% % tH = title('Scenario- 1');
% applyhatch_pluscolor(fH2, '\-x.', 0, [1 0 1 0], jet(4));

figure; %line plot for no of controllers vs costs
plot (xx, yRand, 'm-x');
hold on;
plot (xx, ySa, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Cost');
legend ('Random','SA');

% figure; %line plot for no of controllers vs latencies
% plot (xx, latRand, 'm-x');
% hold on;
% plot (xx, latSa, 'b-s');
% set (gca, 'XTick',1:1:maxNoc);
% xlabel ('Number of Controllers');
% ylabel ('Latency');
% legend ('Random','SA');

figure; %line plot for no of controllers vs execution times
plot (xx, randTime, 'm-x');
hold on;
plot (xx, saTime, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA');

noOfControllers=2;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF2 (noOfControllers, 1:counter));
xlabel ('Temperature');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
title ('Number of Controllers = 2');

figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF2 (noOfControllers, 1:counter));
xlabel ('Temperature');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
set (gca,'xDir','reverse');
title ('Number of Controllers = 2');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF2 (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
title ('Number of Controllers = 2');

figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF2 (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
set (gca,'xDir','reverse');
title ('Number of Controllers = 2');

noOfControllers=3;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF2 (noOfControllers, 1:counter));
xlabel ('Temperature');
ylabel ('Cost');
title ('Number of Controllers = 3');
legend ('No failure','One failure','Two failures');

figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF2 (noOfControllers, 1:counter));
xlabel ('Temperature');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
set (gca,'xDir','reverse');
title ('Number of Controllers = 3');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF2 (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
title ('Number of Controllers = 3');

figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF2 (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
set (gca,'xDir','reverse');
title ('Number of Controllers = 3');

noOfControllers=4;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF2 (noOfControllers, 1:counter));
xlabel ('Temperature');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
title ('Number of Controllers = 4');

figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF (noOfControllers, 1:counter));
hold on;
plot (temps (noOfControllers, 1:counter),saCostsF2 (noOfControllers, 1:counter));
xlabel ('Temperature');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
set (gca,'xDir','reverse');
title ('Number of Controllers = 4');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF2 (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
title ('Number of Controllers = 4');

figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF (noOfControllers, 1:counter));
hold on;
plot (saIter (noOfControllers, 1:counter) ,saCostsF2 (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('No failure','One failure','Two failures');
set (gca,'xDir','reverse');
title ('Number of Controllers = 4');

randTime
saTime
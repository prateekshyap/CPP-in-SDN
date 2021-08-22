clc;
clear all;
close all;
fileName = 'Janetbackbone.graphml'; %network
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P] = importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size(mat);
n = s(1,2); %number of nodes in the network

%% commonly required variables
xx = zeros(1,2); %x values
maxNoc = 4; %maximum number of controllers
index = 1; %to keep track of the arrays
maxIterations = 500; %maximum number of iterations

%% Simulated Annealing
temps = zeros(2,2); %to store the temperatures
saCosts = zeros(2,2); %to store the respective costs
saIter = zeros(2,2); %to store the total number of temperature changes
randomControllers = zeros(maxNoc,maxNoc); %to store the first random combination of controllers taken by sa and ga 
ySa = zeros(1,2); %to store the costs
yFSa = zeros(1,2); %to store the costs of the failure level
yFSa2 = zeros(1,2); %to store the costs of 2nd failure level
latSa = zeros(1,2); %to store the latencies
saTime = zeros(1,2); %to store the execution time
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
%     [controllers, cost, costF, lat, loads, xTemps, yCosts, yFCosts, xxIts, counter, randCont, optConnSa] = simulatedAnnealingFailure(mat, n, 10, 0.001, maxIterations, 0.95, cont);
    [controllers, cost, costF, costF2, lat, loads, xTemps, yCosts, yFCosts, xxIts, counter, randCont, optConnSa] = simulatedAnnealingFailure(mat, n, 10, 0.001, maxIterations, 0.95, cont);
    cont
    cost
    costF
    costF2
    randomControllers (cont, 1:cont) = randCont; %this is needed for random algorithm
    xx (1,index) = cont; %update the x values
    ySa (1,index) = cost; %update the costs
    yFSa(1,index) = costF; %update the failure costs
    yFSa2(1,index) = costF2; %update the failure cost for second case
    latSa (1,index) = lat; %update the latency
    temps (index,1:counter) = xTemps;
    saCosts (index,1:counter) = yCosts;
    saIter (index,1:counter) = xxIts;
    saTime (1,index) = toc; %storing the execution time
    index = index + 1; %increment the index
    fprintf('\n\n');
    saTime(1,index) = toc; %storing the execution time
end
index = 1; %reset the index

%% Genetic Algorithm
yGa = zeros(1,2); %to store the costs
yFGa = zeros(1,2); %to store the costs after failure
yFGa2 = zeros(1,2); %to store the costs after second failure
gaTime = zeros(1,2); %to store the execution times
populationSize = 20; %size of the population
global mutProb; %counts till 100
global randomIterations; %generates the iterations in which mutation is to be done
mutProb = 0;
if (mutProb == 0) %if the count is 0
    randomIterations = randi ([1 100],1,5); %then generate 5 iterations
%     randomIterations
end
for cont = 1 : maxNoc %for each no of controllers
        tic; %timer starts
        [optVal, optValF, optValF2, optLoc, optoptLoad, returnPop, optConnGa, latVal] = modifiedGeneticAlgorithmFailure (mat, n, populationSize, maxIterations , cont);
        cont
        optVal
        optValF
        optValF2
        xx(1,index) = cont;
        yGa(1,index) = optVal; %storing the best fitness value
        yFGa(1,index) = optValF; %storing the best fitness value for one failure
        yFGa2(1,index) = optValF2; %storing the best fitness value for second failure
        gaTime(1,index) = toc; %update the execution times
        index = index + 1; %increment the index
end
index = 1; %reset the index

%% Particle Swarm Optimization
psoTime = zeros (1,2); %to store the execution time
yPso = zeros(1,2); %to store the costs
yFPso = zeros(1,2); %to store the costs after one failure
yF2Pso = zeros(1,2); %to store the costs after second failure
latPso = zeros (1,2); %to store the latencies
c1 = 2;
c2 = 2;
r1 = 0.5;
r2 = 0.5;
w = 1;
wDamp = 0.98; 
populationSize = 20;
for cont = 1 : maxNoc %for each number of controllers
    tic;
    [ optCost, optCostF, optCostF2, optLoc, optLoad, optLat ] = psoFuncFailure(maxIterations, c1, c2, r1, r2, w, wDamp, populationSize, mat, n, latlong, cont, returnPop);
    yPso(1,index) = optCost;
    yFPso(1,index) = optCostF;
    yF2Pso(1,index) = optCostF2;
    latPso(1,index) = optLat;
    cont
    optCost
    optCostF
    optCostF2
    psoTime(1,index) = toc;
    index = index+1;
    fprintf('\n\n');
end
index = 1;

%% Random
randTime = zeros(1,2); %to store the execution times
yRand = zeros(1,2); %to store the costs
yFRand = zeros(1,2); %to store the costs for one failure
yF2Rand = zeros(1,2); %to store the costs for second failure
latRand = zeros(1,2); %to store the latencies;
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
        rc = randomControllers (cont, 1:cont); %generating random controllers
%         [l, c, y] = capacitedCostLatency (rc, mat, n); %finding out the cost
        [l, f, lat, conn] = capacitedCostLatency(rc, mat, n); %finding out the total cost of the network for fs
        [lF, fF, latF, connF] = costWithFailure(rc, mat, n, 1); %finding out the total cost for 1 failure
        [lF2, fF2, latF2, connF2] = costWithFailure(rc, mat, n, 2); %finding out the total cost for second failure
        yRand(1,index) = f; %storing the costs
        yFRand(1,index) = fF; %storing the costs for one failure
        yF2Rand(1,index) = fF2; %storing the costs for second failure
        latRand (1,index) = lat; %storing the latencies
        cont
        yRand(1,index)
        yFRand(1,index)
        yF2Rand(1,index)
%         latRand (1, index)
%         rc
%         l
    randTime (1, index) = toc; %updating the execution times
    index = index + 1; %incrementing the index
    fprintf('\n\n');
end
index = 1; %reset the index

%% plotting the graphs

ySaMain = [ySa; yFSa; yFSa2];
figure;
h = bar(ySaMain',1);
title('SA');
ylabel('Cost');
xlabel('Number of controllers');
legend('r=0','r=1','r=2');
fH = gcf;
colormap(jet(4));

yGaMain = [yGa; yFGa; yFGa2];
figure;
h = bar(yGaMain',1);
title('GA');
ylabel('Cost');
xlabel('Number of controllers');
legend('r=0','r=1','r=2');
fH = gcf;
colormap(jet(4));

yPsoMain = [yPso; yFPso; yF2Pso];
figure;
h = bar(yPsoMain',1);
title('PSO');
ylabel('Cost');
xlabel('Number of controllers');
legend('r=0','r=1','r=2');
fH = gcf;
colormap(jet(4));

yRandMain = [yRand; yFRand; yF2Rand];
figure;
h = bar(yRandMain',1);
title('Random');
ylabel('Cost');
xlabel('Number of controllers');
legend('r=0','r=1','r=2');
fH = gcf;
colormap(jet(4));

y0 = [yRand; ySa; yGa; yPso];
figure;
h = bar(y0',1);
title('No failure');
xlabel('Number of Controllers');
ylabel('Cost');
legend('Random','SA','GA','PSO');
fH = gcf;
colormap(jet(4));

y1 = [yFRand; yFSa; yFGa; yFPso];
figure;
h = bar(y1',1);
title('One failure');
xlabel('Number of Controllers');
ylabel('Cost');
legend('Random','SA','GA','PSO');
fH = gcf;
colormap(jet(4));

y2 = [yF2Rand; yFSa2; yFGa2; yF2Pso];
figure;
h = bar(y2',1);
title('Two failures');
xlabel('Number of Controllers');
ylabel('Cost');
legend('Random','SA','GA','PSO');
fH = gcf;
colormap(jet(4));
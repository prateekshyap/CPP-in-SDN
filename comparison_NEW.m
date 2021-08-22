
%{
    saTime = an array to store the execution times for simulated
    annealing
    gaTime = an array to store the execution times for genetic algorithm
    randTime = an array to store the execution times for random algorithm
    maxNoc = the maximum value to which the loop will run
    ySa = costs for simulated annealing
    YGa = costs for genetic algorithm
    yRand = costs for random algorithm
    populationSize = size of population
    maxIterations = maximum number of iterations in genetic algorithm
%}

clc;
clear all;
close all;
fileName = 'Janetbackbone.graphml'; %network
% fileName = 'GERMANY50.graphml'; %network
% fileName = 'Iris.graphml'; %network
% fileName = 'TATANET.graphml'; %network
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P] = importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
xx = zeros (1,2); %x values

saTime = zeros (1,2); 
index = 1; %to keep track of the arrays
maxNoc = 4; %maximum number of controllers
maxIterations = 500; %maximum number of iterations
index = 1; %to keep track of the arrays
temps = zeros (2,2); %to store the temperatures
saCosts = zeros (2,2); %to store the respective costs
saIter = zeros (2,2); %to store the total number of temperature changes
randomControllers = zeros (maxNoc,maxNoc); %to store the first random combination of controllers taken by sa and ga 
% yGerm = [80 69 63 54];

% Simulated Annealing by changing the positions of the controllers
ySa = zeros (1,2); %to store the costs
latSa = zeros (1,2); %to store the latencies
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
%     [controllers, cost] = simulatedAnnealing2 (mat, n, 10, 0.001, maxIterations, 0.95, cont); %perform simuated annealing
    [controllers, cost, lat, loads, xTemps, yCosts, xxIts, counter, randCont, optConnSa] = simulatedAnnealing (mat, n, 10, 0.001, maxIterations, 0.95, cont); %perform simuated annealing
    cont
    cost
    lat
    controllers
    loads
    for j = 1 : cont %for each controller
        optConnSa (1:cont,controllers(1,j)) = zeros(cont,1);
    end
    optConnSa
    networkPlotFunction(optConnSa, fileName, controllers);
    randomControllers (cont, 1:cont) = randCont; %this is needed for random algorithm
    xx (1, index) = cont; %update the x values
    ySa (1, index) = cost; %update the costs
    latSa (1,index) = lat; %update the latency
    temps (index, 1:counter) = xTemps;
    saCosts (index, 1:counter) = yCosts;
    saIter (index, 1:counter) = xxIts;
    saTime (1, index) = toc; %update the execution time
    index = index + 1; %increment the index
    fprintf('\n\n');
end
index = 1; %reset the index

% genetic algorithm
yGa = zeros (1,2); %to store the costs
yCustom = zeros (1,2);
gaTime = zeros (1,2); %to store the execution times
populationSize = 20;
global mutProb; %counts till 100
global randomIterations; %generates the iterations in which mutation is to be done
mutProb = 0;
if (mutProb == 0) %if the count is 0
    randomIterations = randi ([1 100],1,5); %then generate 5 iterations
    randomIterations
end
for cont = 1 : maxNoc %for each no of controllers
        tic; %timer starts
        [optVal, optLoc, optLoad, returnPop, optConnGa, latVal] = modifiedGeneticAlgorithmImpl052 (mat, n, populationSize, maxIterations , cont);
        cont
        optVal
        optLoc
        xx(1,index) = cont;
        yCustom (1,index) = latVal;
        for j = 1 : cont %for each controller
            optConnGa (1:cont,optLoc(1,j)) = zeros(cont,1);
        end
        optConnGa
        networkPlotFunction(optConnGa, fileName, optLoc);
        yGa (1, index) = optVal; %storing the best fitness value
        gaTime (1, index) = toc; %update the execution times
        index = index + 1; %increment the index
end
index = 1; %reset the index

%pso
psoTime = zeros (1,2); %to store the execution time
yPso = zeros (1,2); %to store the costs
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
    [ optCost, optLoc, optLoad, optLat ] = psoFunc(maxIterations, c1, c2, r1, r2, w, wDamp, populationSize, mat, n, latlong, cont, returnPop);
    yPso(1,index) = optCost;
    latPso(1,index) = optLat;
    cont
    optLoc
    optLoad
    psoTime(1,index) = toc;
    index = index+1;
    fprintf('\n\n');
end
index = 1;

%random
randTime = zeros (1,2); %to store the execution times
yRand = zeros (1,2); %to store the costs
latRand = zeros (1,2); %to store the latencies;
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
        rc = randomControllers (cont, 1:cont); %generating random controllers
        [l, c, y] = capacitedCostLatency (rc, mat, n); %finding out the cost
        yRand (1, index) = c; %storing the costs
        latRand (1, index) = y; %storing the latencies
        cont
        yRand (1, index)
        latRand (1, index)
        rc
        l
    randTime (1, index) = toc; %updating the execution times
    index = index + 1; %incrementing the index
    fprintf('\n\n');
end
index = 1; %reset the index

y = [yRand; ySa; yGa; yPso]; %merge the costs to a single matrix for bar plot
% y = [yRand; ySa; yGa]; %merge the costs to a single matrix for bar plot

figure; %bar plot for no of controllers vs costs
% bar (y',1);
% ylabel ('Fitness Function');
% xlabel ('Number of Controllers');
% legend ('Random','SA','GA');

h = bar(y',1);
% set(gca,'xticklabel',x);
% title ('Scenario- 1');
ylabel ('Cost');
xlabel ('No. Of Controllers');
legend ('Random','SA','GA','PSO');
% legend ('Random','SA','GA');

fH = gcf;
colormap(jet(4));

% Apply Brandon's function
% tH = title('Scenario- 1');
% applyhatch_pluscolor(fH, '\-x.', 0, [1 0 1 0], jet(4));

% set(tH, 'String', 'Scenario- 1');

t = [randTime; saTime; gaTime; psoTime]; %merge the times to a single matrix for bar plot
% t = [randTime; saTime; gaTime]; %merge the times to a single matrix for bar plot

figure; %bar plot for no of controllers vs execution times
% bar (t',1);
% ylabel ('Execution Time');
% xlabel ('Number of Controllers');
% legend ('Random','SA','GA');

bar(t',1);
% set(gca,'xticklabel',x);
% title ('Scenario- 1');
ylabel ('Execution Time');
xlabel ('No. of Controller');
legend ('Random','SA','GA','PSO');
% legend ('Random','SA','GA');


% Apply Brandon's function
% tH = title('Scenario- 1');
% applyhatch_pluscolor(fH2, '\-x.', 0, [1 0 1 0], jet(4));

figure; %line plot for no of controllers vs costs
plot (xx, yRand, 'm-x');
hold on;
plot (xx, ySa, 'b-s');
hold on;
plot (xx, yGa, 'g-o');
hold on;
plot (xx, yPso, 'c-*');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Cost');
legend ('Random','SA','GA','PSO');
% legend ('Random','SA','GA');

figure; %lne plot for no of controllers vs execution times
plot (xx, randTime, 'm-x');
hold on;
plot (xx, saTime, 'b-s');
hold on;
plot (xx, gaTime, 'g-o');
hold on;
plot (xx, psoTime, 'c-*');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA','GA','PSO');
% legend ('Random','SA','GA');

%{
y2 = [yRand; ySa]; %merge the costs to a single matrix for bar plot

figure (1); %bar plot for no of controllers vs costs
h = bar (y2',1);
ylabel ('Cost');
xlabel ('Number of Controllers');
legend ('Random','SA');
fH = gcf;
colormap(jet(4));

y3 = [latRand; latSa]; %merge the latencies to a single matrix for bar plot

figure (2); %bar plot for no of controllers vs costs
bar (y3',1);
ylabel ('Latency');
xlabel ('Number of Controllers');
legend ('Random','SA');

t2 = [randTime; saTime]; %merge the times to a single matrix for bar plot

figure (3); %bar plot for no of controllers vs execution times
bar (t2',1);
ylabel ('Execution Time');
xlabel ('Number of Controllers');
legend ('Random','SA');

figure (4); %line plot for no of controllers vs costs
plot (xx, yRand, 'm-x');
hold on;
plot (xx, ySa, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Cost');
legend ('Random','SA');

figure (5); %line plot for no of controllers vs latencies
plot (xx, latRand, 'g-x');
hold on;
plot (xx, latSa, 'r-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Latency');
legend ('Random','SA');


figure (6); %line plot for no of controllers vs execution times
plot (xx, randTime, 'm-x');
hold on;
plot (xx, saTime, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA');
%}

%{
yCustom
figure; %line plot for no of controllers vs costs
plot (xx, yGerm, 'g-o');
hold on;
plot (xx, yCustom, 'c-*');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Average Propagation Delay in micro seconds');
% legend ('Random','SA','GA','PSO');
legend ('GAPA','Proposed GA');
%}


noOfControllers = 2;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Cost');
legend ('SA');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 3;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Cost');
legend ('SA');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');
%{
noOfControllers = 4;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Cost');
legend ('SA');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 5;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Cost');
legend ('SA');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 6;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Cost');
legend ('SA');
   
figure; %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 7;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
 xlabel ('Temperature');
ylabel ('Cost');
 legend ('SA');
   
 figure; %cost plot for SA
 plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 8;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
 xlabel ('Temperature');
ylabel ('Cost');
 legend ('SA');
   
 figure; %cost plot for SA
 plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 9;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
 xlabel ('Temperature');
ylabel ('Cost');
 legend ('SA');
   
 figure; %cost plot for SA
 plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');

noOfControllers = 10;
figure;
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
 xlabel ('Temperature');
ylabel ('Cost');
 legend ('SA');
   
 figure; %cost plot for SA
 plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Cost');
legend ('SA');
%}
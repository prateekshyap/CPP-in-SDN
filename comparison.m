
%{
    saTime = an array to store the execution times for simulated
    annealing
    gaTime = an array to store the execution times for genetic algorithm
    randTime = an array to store the execution times for random algorithm
    maxNoc = the maximum value to which the loop will run
    ySa = costs for simulated annealing
    YGa = costs for geenetic algorithm
    yRand = costs for random algorithm
    populationSize = size of population
    maxIterations = maximum number of iterations in genetic algorithm
%}
clear all;
close all;
fileName = 'Agis.graphml'; %network
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);

xx = zeros (1,2); %x values
saTime = zeros (1,2); 
index = 1; %to keep track of the arrays
maxNoc = 5; %maximum number of controllers
maxIterations = 500; %maximum number of iterations

% Simulated Annealing by changing the positions of the controllers
ySa = zeros (1,2); %to store the costs
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
    [controllers, cost] = simulatedAnnealing (mat, n, 10, 0.001, maxIterations, 0.95, cont); %perform simuated annealing
    cont
    cost
    controllers
    xx (1, index) = cont; %update the x values
    ySa (1, index) = cost; %update the costs
    saTime (1, index) = toc; %update the execution time
    index = index + 1; %increment the index
end
index = 1; %reset the index

% genetic algorithm
yGa = zeros (1,2); %to store the costs
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
        [optVal, optLoc] = modifiedGeneticAlgorithmImpl05 (mat, n, populationSize, maxIterations , cont);
        cont
        optVal
        optLoc
        yGa (1, index) = optVal; %storing the best fitness value
        gaTime (1, index) = toc; %update the execution times
        index = index + 1; %increment the index
end
index = 1; %reset the index

%random
randTime = zeros (1,2); %to store the execution times
yRand = zeros (1,2); %to store the costs
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
        randCont = randi ([1 n],1,cont); %generating random controllers
        [l, c] = capacitedCost (randCont, mat, n); %finding out the cost
        yRand (1, index) = c; %storing the costs
        cont
        yRand (1, index)
        randCont
    randTime (1, index) = toc; %updating the execution times
    index = index + 1; %incrementing the index
end
index = 1; %reset the index

y = [yRand; ySa; yGa]; %merge the costs to a single matrix for bar plot


figure (1); %bar plot for no of controllers vs costs
bar (y',1);
ylabel ('Fitness Function');
xlabel ('Number of Controllers');
legend ('Random','SA','GA');

t = [randTime; saTime; gaTime]; %merge the times to a single matrix for bar plot

figure (2); %bar plot for no of controllers vs execution times
bar (t',1);
ylabel ('Execution Time');
xlabel ('Number of Controllers');
legend ('Random','SA','GA');

figure (3); %line plot for no of controllers vs costs
plot (xx, yRand);
hold on;
plot (xx, ySa);
hold on;
plot (xx, yGa);
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Fitness Function');
legend ('Random','SA','GA');

figure (4); %lne plot for no of controllers vs execution times
plot (xx, randTime);
hold on;
plot (xx, saTime);
hold on;
plot (xx, gaTime);
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA','GA');

randTime
saTime
gaTime
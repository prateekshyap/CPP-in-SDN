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
fileName = 'Janetbackbone.graphml'; %network
% fileName = 'Iris.graphml';
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
xx = zeros (1,2); %x values

saTime = zeros (1,2); 
index = 1; %to keep track of the arrays
maxNoc = 7; %maximum number of controllers
maxIterations = 500; %maximum number of iterations
index = 1; %to keep track of the arrays
temps = zeros (2,2); %to store the temperatures
saCosts = zeros (2,2); %to store the respective costs
saIter = zeros (2,2); %to store the total number of temperature changes
randomControllers = zeros (maxNoc,maxNoc); %to store the first random combination of controllers taken by sa and ga 

% Simulated Annealing by changing the positions of the controllers
ySa = zeros (1,2); %to store the costs
for cont = 1 : maxNoc %for each number of controllers
    tic; %timer starts
%     [controllers, cost] = simulatedAnnealing2 (mat, n, 10, 0.001, maxIterations, 0.95, cont); %perform simuated annealing
    [controllers, cost, xTemps, yCosts, xxIts, counter, randCont] = simulatedAnnealingLatency (mat, n, 10, 0.001, maxIterations, 0.95, cont); %perform simuated annealing
    cont
    cost
    controllers
    randomControllers (cont, 1:cont) = randCont; %this is needed for random algorithm
    xx (1, index) = cont; %update the x values
    ySa (1, index) = cost; %update the costs
    temps (index, 1:counter) = xTemps;
    saCosts (index, 1:counter) = yCosts;
    saIter (index, 1:counter) = xxIts;
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
        [optVal, optLoc] = geneticAlgoLat (mat, n, populationSize, maxIterations , cont);
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
        rc = randomControllers (cont, 1:cont); %generating random controllers
        [l, c] = capacitedCostLatency(rc, mat, n); %finding out the cost
        yRand (1, index) = c; %storing the costs
        cont
        yRand (1, index)
        rc
    randTime (1, index) = toc; %updating the execution times
    index = index + 1; %incrementing the index
end
index = 1; %reset the index

y = [yRand; ySa; yGa]; %merge the costs to a single matrix for bar plot

figure (1); %bar plot for no of controllers vs costs
bar (y',1);
ylabel ('Latency');
xlabel ('Number of Controllers');
legend ('Random','SA','GA');

t = [randTime; saTime; gaTime]; %merge the times to a single matrix for bar plot

figure (2); %bar plot for no of controllers vs execution times
bar (t',1);
ylabel ('Execution Time');
xlabel ('Number of Controllers');
legend ('Random','SA','GA');

figure (3); %line plot for no of controllers vs costs
plot (xx, yRand, 'm-x');
hold on;
plot (xx, ySa, 'b-s');
hold on;
plot (xx, yGa, 'g-o');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Latency');
legend ('Random','SA','GA');

figure (4); %lne plot for no of controllers vs execution times
plot (xx, randTime, 'm-x');
hold on;
plot (xx, saTime, 'b-s');
hold on;
plot (xx, gaTime, 'g-o');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA','GA');

y2 = [yRand; ySa]; %merge the costs to a single matrix for bar plot

figure (1); %bar plot for no of controllers vs costs
bar (y2',1);
ylabel ('Latency');
xlabel ('Number of Controllers');
legend ('Random','SA');

t2 = [randTime; saTime]; %merge the times to a single matrix for bar plot

figure (2); %bar plot for no of controllers vs execution times
bar (t',1);
ylabel ('Execution Time');
xlabel ('Number of Controllers');
legend ('Random','SA');


figure (11); %line plot for no of controllers vs costs
plot (xx, yRand, 'm-x');
hold on;
plot (xx, ySa, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Latency');
legend ('Random','SA');

figure (12); %lne plot for no of controllers vs execution times
plot (xx, randTime, 'm-x');
hold on;
plot (xx, saTime, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA');

noOfControllers = 2;
figure (13);
plot (temps (noOfControllers, counter:-1:1),saCosts (noOfControllers, counter:-1:1));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Latency');
legend ('SA');
   
figure (14); %cost plot for SA
plot (saIter (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Latency');
legend ('SA');

noOfControllers = 3;
figure (15);
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Latency');
legend ('SA');
   
figure (16); %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Latency');
legend ('SA');

noOfControllers = 4;
figure (17);
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Latency');
legend ('SA');
   
figure (18); %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Latency');
legend ('SA');

noOfControllers = 5;
figure (19);
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Latency');
legend ('SA');
   
figure (20); %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Latency');
legend ('SA');

noOfControllers = 6;
figure (21);
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca,'xDir','reverse');
xlabel ('Temperature');
ylabel ('Latency');
legend ('SA');
   
figure (22); %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
xlabel ('No. of Iterations');
ylabel ('Latency');
legend ('SA');

randTime
saTime
gaTime
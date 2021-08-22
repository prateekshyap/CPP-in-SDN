%{
    saTime = an array to store the execution times for simulated
    annealing
    randTime = an array to store the execution times for random algorithm
    maxNoc = the maximum value to which the loop will run
    ySa = costs for simulated annealing
    yRand = zosts for random algorithm
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
saIter = zeros (2,2); %to store the total number of temperature changes

% Simulated Annealing by changing the positions of the controllers
ySa = zeros (1,2); %to store the costs
saTime = zeros (1,2); 
for cont = 1 : maxNoc %for each number of controllers
    tic;
    [controllers, cost, xTemps, yCosts, xxIts, counter, lSa] = simulatedAnnealing (mat, n, 10, 0.001, maxIterations, 0.95, cont); %perform simuated annealing
    cont
    cost
    lSa
    controllers
    xx (1, index) = cont; %update the x values
    ySa (1, index) = cost; %update the costs
    saTime (1, index) = toc; %update the execution time
    temps (index, 1:counter) = xTemps;
    saCosts (index, 1:counter) = yCosts;
    saIter (index, 1:counter) = xxIts;
    index = index + 1; %increment the index
end
index = 1; %reset the index

%random
yRand = zeros (1,2); %to store the costs
randTime = zeros (1,2); 
for cont = 1 : maxNoc %for each number of controllers
        tic;
        randCont = randi ([1 n],1,cont); %generating random controllers
        [lRand, c] = capacitedCost (randCont, mat, n); %finding out the cost
        yRand (1, index) = c; %storing the costs
        randTime (1, index) = toc; %update the execution time
        cont
        yRand (1, index)
        lRand
        randCont
    index = index + 1; %incrementing the index
end
index = 1; %reset the index

y = [yRand; ySa]; %merge the costs to a single matrix for bar plot

figure (1); %bar plot for no of controllers vs costs
% bar (y',1);
% ylabel ('Fitness Function');
% xlabel ('Number of Controllers');
% legend ('Random','SA','GA');

h = bar(y',1);
% set(gca,'xticklabel',x);
% title ('Scenario- 1');
ylabel ('Cost');
xlabel ('Networks');
legend ('Random','SA');

fH = gcf;
colormap(jet(4));


% Apply Brandon's function
% tH = title('Scenario- 1');
applyhatch_pluscolor(fH, '\-x.', 0, [1 0 1 0], jet(4));

% set(tH, 'String', 'Scenario- 1');

t = [randTime; saTime]; %merge the times to a single matrix for bar plot

figure (3); %bar plot for no of controllers vs execution times
% bar (t',1);
% ylabel ('Execution Time');
% xlabel ('Number of Controllers');
% legend ('Random','SA','GA');

h2 = bar(t',1);
% set(gca,'xticklabel',x);
% title ('Scenario- 1');
ylabel ('Execution Time');
xlabel ('Networks');
legend ('Random','SA');

fH2 = gcf;
colormap(jet(4));


% Apply Brandon's function
% tH = title('Scenario- 1');
applyhatch_pluscolor(fH2, '\-x.', 0, [1 0 1 0], jet(4));

figure (5); %line plot for no of controllers vs costs
plot (xx, yRand, 'm-x');
hold on;
plot (xx, ySa, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Fitness Function');
legend ('Random','SA');

figure (6); %line plot for no of controllers vs execution times
plot (xx, randTime, 'm-x');
hold on;
plot (xx, saTime, 'b-s');
set (gca, 'XTick',1:1:maxNoc);
xlabel ('Number of Controllers');
ylabel ('Execution Time');
legend ('Random','SA');

noOfControllers = 2;
figure (7);
plot (temps (noOfControllers, 1:counter),saCosts (noOfControllers, 1:counter));
set (gca, 'xDir', 'reverse');
xlabel ('Temperature');
ylabel ('Fitness Function');
legend ('SA');
   
figure (8); %cost plot for SA
plot (saIter (noOfControllers, 1:counter) ,saCosts (noOfControllers, 1:counter));
ylabel ('Fitness Function');
legend ('SA');

randTime
saTime
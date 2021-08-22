close all;
clear all;
tic;
global mutProb;
mutProb = 0;
fileName = 'Janetbackbone.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
td = 5;
[deg, pos] = thresholdDegree (mat, n, td);
cost = capacitedCost (pos, mat, n);
cost
pos
noc = 4; %number of controllers
populationSize = 20; %population size
maxIterations = 50; %maximum number of iterations
x = [10 20 30 40 50 60 70 80 90 100];
y = zeros (6,3); %for genetic, random, brute force
loc = zeros (18, 6); %storing the optimal location
index = 1; %to keep track of loc
for cont = 1 : noc %for variable no of controllers
    %GA
    fprintf ('GA-\n');
        [optVal, optLoc] = modifiedGeneticAlgorithmImpl05 (mat, n, populationSize, maxIterations , cont);
        cont
        optVal
        optLoc
        y (cont,3) = optVal; %storing the best fitness value
        loc (index, 1 : cont) = optLoc (1 : cont); %storing the locations
        index = index + 1; %increment the index
    %random
    fprintf ('Random-\n');
        randCont = randi ([1 n],1,cont); %generating random controllers
        y (cont,1) = capacitedCost1 (randCont, mat, n); %finding out the cost
        loc (index, 1 : cont) = randCont (1 : cont); %storing the locations in loc
        index = index + 1; %increment the index
        cont
        y (cont,1)
        randCont
    %CCPP
    fprintf ('CCPP-\n');
        c = combnk (1:n,cont); %storing all the combinations
        s = size (c);
        noi = s (1,1); %no of iterations
        optimalLocations = zeros (1,cont); %optimal combination
        minFitness = 1000000; %a variable to store the minimum fitness value
        for i = 1 : noi %for each combination of controllers
            cost = capacitedCost (c(i,1:cont), mat, n);
            if (cost < minFitness) %if the new fitness value is less than the optimal value
                minFitness = cost; %update the minimum fitness value
                optimalLocations = c (i,1:cont); %update the candidate combination
            end
        end
        y (cont,2) = minFitness; %storing the optimal fitness value
        loc (index, 1 : cont) = optimalLocations (1, 1:cont); %storing the locations
        index = index + 1; %increment the index
        cont
        minFitness
        optimalLocations
end
x
y
loc
figure (1);
x = {'1','2','3','4','5','6'};
bar (y (1:noc,1:3),1);
set (gca, 'xticklabel',x);
% set (gca, 'YTick',1:1:10);
ylabel ('Objective Function');
xlabel ('Number of Controllers');
legend ('Random','CCPP','GA');
toc;
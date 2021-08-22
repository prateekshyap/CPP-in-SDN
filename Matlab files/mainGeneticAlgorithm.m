%genetic algorithm
tic;
fileName = 'Agis.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
td = 5;
[deg, pos] = thresholdDegree (mat, n, td);
cost = capacitedCost (pos, mat, n);
cost
pos
noc = 6; %number of controllers
populationSize = 20; %population size
maxIterations = 100; %maximum number of iterations
x = [10 20 30 40 50 60 70 80 90 100];
y = zeros (6,10); %for noc = 2, 3, 4, 5;
loc = zeros (60, 6); %storing the optimal location
index = 1; %to keep track of loc
% simpleGeneticAlgorithmImpl (mat, n, td, populationSize, maxIterations);
for cont = 1 : noc %for variable no of controllers
    for it = 10 : 10 : maxIterations %for each iterations
        [optVal, optLoc] = geneticAlgorithmImpl (mat, n, populationSize, it , cont);
        it
        cont
        optVal
        optLoc
        y (cont,it/10) = optVal; %storing the best fitness value
        loc (index, 1 : cont) = optLoc (1 : cont); %storing the locations
        index = index + 1; %increment the index
    end
end
figure (1);
plot (x, y (2, 1:10));
title ('Number of controllers = 2');
xlabel ('Number of Iterations');
ylabel ('Fitness Function');
figure (2);
plot (x, y (3, 1:10));
title ('Number of controllers = 3');
xlabel ('Number of Iterations');
ylabel ('Fitness Function');
figure (3);
plot (x, y (4, 1:10));
title ('Number of controllers = 4');
xlabel ('Number of Iterations');
ylabel ('Fitness Function');
figure (4);
plot (x, y (5, 1:10));
title ('Number of controllers = 5');
xlabel ('Number of Iterations');
ylabel ('Fitness Function');

% figure (1);
% x = {'1','2','3','4','5','6'};
% bar (y (1:noc,5));
% set (gca, 'xticklabel',x);
% % set (gca, 'YTick',1:1:10);
% ylabel ('Fitness Function');
% xlabel ('Number of Controllers');
% % legend ();
% figure (2);
% title = {'Number of iterations = 50'};
% x = {'1','2','3','4','5','6'};
% bar (y (1:noc,3:7),1);
% set (gca, 'xticklabel',x);
% % set (gca, 'YTick',1:1:10);
% ylabel ('Fitness Function');
% xlabel ('Number of Controllers');
% legend ('Number of iterations = 30','Number of iterations = 40','Number of iterations = 50','Number of iterations = 60','Number of iterations = 70');
toc;
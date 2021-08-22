%genetic algorithm
clear all;
close all;
tic;
global mutProb; %counts till 100
global randomIterations; %generates the iterations in which mutation is to be done
mutProb = 0;
if (mutProb == 0) %if the count is 0
    randomIterations = randi ([1 100],1,5); %then generate 5 iterations
    randomIterations
end
fileName = 'Janetbackbone.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
td = 4;
[deg, pos] = thresholdDegree (mat, n, td);
cost = capacitedCost (pos, mat, n);
cost
pos
noc = 6; %number of controllers
populationSize = 20; %population size
maxIterations = 1000; %maximum number of iterations
% x = [110 120 130 140 150 160 170 180 190 200];
x = [100 200 300 400 500 600 700 800 900 1000];
% x = [10 20 30 40 50];
% y = zeros (6,10); %
y = zeros (1,1);
% loc = zeros (60, 6); %storing the optimal location
loc = zeros (1, 1); %storing the optimal locations
load = zeros (1, 1); %storing the optimal loads
index = 1; %to keep track of loc
yin = 1; %to keep track of y
xin = 1; %to keep track of y
% simpleGeneticAlgorithmImpl (mat, n, td, populationSize, maxIterations);
for cont = 5 : 5 %for variable no of controllers
    for it = 100 : 100 %for each iterations
        [optVal, optLoc, optLoad] = modifiedGeneticAlgorithmImpl05 (mat, n, populationSize, it , cont);
        it
        cont
        optVal
        optLoc
        optLoad
        y (xin, yin) = optVal; %storing the best fitness value
        yin = yin + 1;
        loc (index, 1 : cont) = optLoc (1 : cont); %storing the locations
        load (index, 1 : cont) = optLoad (1 : cont); %storing the loads
        index = index + 1; %increment the index
    end
    yin = 1;
    xin = xin + 1;
end
%{
x
y
loc
load
%no of iterations vs fitness function
zzz = size (y);
%}

% figure (1);
% plot (x, y (1,1:zzz(1,2)));
% % set (gca, 'YTick',1:1:10);
% xlabel ('Number of iterations');
% ylabel ('Fitness Function');
% legend ('Number of controllers = 2');

%{
figure (1);
plot (x, y (3,1:zzz(1,2)));
% set (gca, 'YTick',1:1:10);
xlabel ('Number of iterations');
ylabel ('Fitness Function');
legend ('Number of controllers = 3');
%}

% figure (3);
% plot (x, y (3,1:zzz(1,2)));
% % set (gca, 'YTick',1:1:10);
% xlabel ('Number of iterations');
% ylabel ('Fitness Function');
% legend ('Number of controllers = 4');
% figure (4);
% plot (x, y (4,1:zzz(1,2)));
% % set (gca, 'YTick',1:1:10);
% xlabel ('Number of iterations');
% ylabel ('Fitness Function');
% legend ('Number of controllers = 5');


% %no of controllers vs fitness function
% figure (1);
% x = {'1','2','3','4','5','6'};
% bar (y (1:noc,1));
% set (gca, 'xticklabel',x);
% % set (gca, 'YTick',1:1:10);
% ylabel ('Fitness Function');
% xlabel ('Number of Controllers');
% % legend ();

%{
figure (2);
x = {'1','2','3','4','5','6'};
bar (y (1:noc, 1: 5),1);
set (gca, 'xticklabel',x);
% set (gca, 'YTick',1:1:10);
ylabel ('Fitness Function');
xlabel ('Number of Controllers');
legend ('Number of iterations = 100','Number of iterations = 200','Number of iterations = 300','Number of iterations = 400','Number of iterations = 500');
% legend ('Number of iterations = 20','Number of iterations = 30','Number of iterations = 40','Number of iterations = 50');
toc;
%}
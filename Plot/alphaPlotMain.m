clear all;
close all;
% fileName = 'Sprint.graphml';
% fileName = 'Nsfnet.graphml';
% fileName = 'Agis.graphml';
fileName = 'Janetbackbone.graphml';
% fileName = 'sanet.graphml';
% fileName = 'Iris.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,Mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (Mat);
N = s (1,2);
m = 1;
minAlpha = 0.2; %minimum value of alpha
maxAlpha = 0.8; %maximum value of alpha
intervalAlpha = 0.2; %incremental value for alpha
minNoc = 2; %starting no of controllers
maxNoc = 8; %maximum no of controllers
intervalNoc = 1; %incremental value for the controllers
plotAlpha (Mat, N, m, minAlpha, maxAlpha, intervalAlpha, minNoc, maxNoc, intervalNoc);
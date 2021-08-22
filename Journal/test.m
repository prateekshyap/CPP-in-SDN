clc;
clear all;
close all;
fileName = 'Janetbackbone.graphml'; %network
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P] = importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size(mat);
n = s(1,2); %number of nodes in the network

%% find out the shortest paths 
shortestPathMatrix = allPairShortestPath(n,mat);

m = 2;
noc = 4;
fs = randi(n,1,noc)

[sp, connections, connectionsF, controllersList, switchController] = createNetwork(shortestPathMatrix, m, n, noc, fs);
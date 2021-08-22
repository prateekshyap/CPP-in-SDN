%agis
fileName = 'Agis.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
noc = 4;
tMax = 10;
tMin = 0.001;
iterations = 500;
cf = 0.95;

%% Simulated Annealing by changing the positions of the controllers
subOptimalControllerPositions = simulatedAnnealing (mat, n, tMax, tMin, iterations, cf, noc);
%% Simulated Annealing with one failure
% simulatedAnnealingWithFailure (mat, n, tMax, tMin, iterations, cf);
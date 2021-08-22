%agis
fileName = 'Agis.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,agisMat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (agisMat);
agisN = s (1,2);
% Simulated Annealing by changing the positions of the controllers
subOptimalControllerPositions = simulatedAnnealing (agisMat, agisN, 10, 0.001, 500, 0.95);
subOptimalControllerPositions
% % Simulated Annealing with one failure
% simulatedAnnealingWithFailure (agisMat, agisN, 10, 0.001, 500, 0.95);
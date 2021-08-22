% agis
% fileName = 'Agis.graphml';
%fileName = 'Surfnet.graphml';
%fileName = 'TATANET.graphml';
fileName = 'switch.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,agisMat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (agisMat);
agisN = s (1,2);
agisMax = 6;
multiControllerPlanning (agisMat, agisN, agisMax);
close all;
clear all;
% tatanet
fileName = 'TATANET.graphml';

%fileName = 'switch.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,tataMat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (tataMat);
tataN = s (1,2);
tataMax = 8;
multiControllerPlanning (tataMat, tataN, tataMax);
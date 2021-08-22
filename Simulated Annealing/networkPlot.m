close all;
clear all;
fileName = 'TATANET.graphml'; %file
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
controllerPositions = [33 47 71 76 108]; %list of controllers
s = size (controllerPositions);
noc = s (1,2);
in = 1; %index to keep track of the controllers list
figure (1);
for i = 1 : n %for each node
   if (in <= noc && controllerPositions (1, in) == i) %if the node is a controller
       plot(latlong(i,1),latlong(i,2),'ko','MarkerSize',10,'MarkerFaceColor','b'); %plot bigger and darker dots
       in = in + 1; %increment the index
   else
       plot(latlong(i,1),latlong(i,2),'ko','MarkerFaceColor','y'); %plot smaller and lighter dots
   end
   hold on;
end
for i = 1 : n %this loop plots the connections of the network for each switch
	for j = 1 : n %for each switch
		if (mat (i,j) ~= 0) %if ith and jth switch are connected
			x1 = latlong (i,1);
			x2 = latlong (j,1);
			y1 = latlong (i,2);
			y2 = latlong (j,2);
			plot ([x1 x2] , [y1 y2], '-k', 'MarkerEdgeColor', 'k',  'MarkerFaceColor','k'); %draw a line between them
		end
	end
end
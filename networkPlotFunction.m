function [] = networkPlotFunction(connections, fileName, controllerPositions)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% fileName = 'Iris.graphml'; %file
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
% controllerPositions = [12 14 17]; %list of controllers
s = size (controllerPositions);
noc = s (1,2);
in = 1; %index to keep track of the controllers list
for j = 1 : noc %for each controller
    connections (1:noc,controllerPositions(1,j)) = zeros(noc,1);
end
figure;
for i = 1 : n %for each node
%        plot(latlong(i,1),latlong(i,2),'ko','MarkerFaceColor','w'); %plot smaller and lighter dots
%        hold on;
       plot(latlong(i,1),latlong(i,2),'ko','MarkerFaceColor','y'); %plot smaller and lighter dots
       hold on;
end
for j = 1 : noc %for each controller
    plot(latlong(controllerPositions(1,j),1),latlong(controllerPositions(1,j),2),'ko','MarkerSize',10,'MarkerFaceColor','b'); %plot smaller and lighter dots
    hold on;
end
% for i = 1 : n %this loop plots the connections of the network for each switch
% 	for j = 1 : noc %for each controller
%         if (connections(j,i) ~= 0) %if the jth controller and ith switch are connected
%             x1 = latlong (i,1);
%             x2 = latlong (controllerPositions(1,j),1);
%             y1 = latlong (i,2);
%             y2 = latlong (controllerPositions(1,j),2);
%             plot ([x1 x2] , [y1 y2], '-k', 'MarkerEdgeColor', 'k',  'MarkerFaceColor','k'); %draw a line between them
%         end
% 	end
% end
xlabel ('Longitude');
ylabel ('Latitude');
h = zeros (2,1);
h (1) = plot (NaN,NaN,'ko','MarkerFaceColor','y');
h (2) = plot (NaN,NaN,'ko','MarkerFaceColor','b');
legend (h,'Nodes','Controllers');
end
clear all;
close all;
fileName = 'Iris.graphml';
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
maxNoc = 7; %maximum number of controllers
for noc = 1 : maxNoc
controllerPositions = randi(n,1,noc); %list of controllers
in = 1; %index to keep track of the controllers list
    sp = zeros (noc, n); %to store the shortest paths from all the controllers individually taken as sources
    connections = zeros (noc, n); %to store the connections
    %find out the shortest paths
    for i = 1 : noc %for each controller
        sp (i, 1:n) = bellmanFord (n, mat, controllerPositions (i)); %calculate the shortest paths
        connections = sp; %copying the values to connections
    end
    %divide the switches among the controllers
    for k = 1 : n %for each node
        %finding out the minimum distance
        min = connections (1,k); %the shortest path from 1st controller is assumed to be the minimum
        for j = 2 : noc %for each controller except the 1st one
            if (connections (j,k) == 0) %if minimum distance is 0 or shortest path is 0
                break; %stop the inner loop
            elseif (min == 0) %if minimum is zero
                min = connections (j,k); %update it to the next value
            elseif (connections (j,k) >= min) %if the node has shortest path from 1st controller less than that of the current controller
                connections (j,k) = 0; %connect the node to the 1st controller
            else %if the node is closer to any controller other than the 1st one
                min = connections (j,k); %minimum distance is updated
            end
        end
        %disconnecting from other nodes
        for m = 1 : noc %for each controller
            if (connections (m,k) ~= min) %if the distance is not minimum
                connections (m,k) = 0; %disconnect them
            end
        end
    end
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
xlabel ('Longitude');
ylabel ('Latitude');
h = zeros (2,1);
h (1) = plot (NaN,NaN,'ko','MarkerFaceColor','y');
h (2) = plot (NaN,NaN,'ko','MarkerFaceColor','b');
legend (h,'Nodes','Controllers');

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
for i = 1 : n %this loop plots the connections of the network for each switch
	for j = 1 : noc %for each controller
        if (connections(j,i) ~= 0) %if the jth controller and ith switch are connected
            x1 = latlong (i,1);
            x2 = latlong (controllerPositions(1,j),1);
            y1 = latlong (i,2);
            y2 = latlong (controllerPositions(1,j),2);
            plot ([x1 x2] , [y1 y2], '-k', 'MarkerEdgeColor', 'k',  'MarkerFaceColor','k'); %draw a line between them
        end
	end
end
xlabel ('Longitude');
ylabel ('Latitude');
h = zeros (2,1);
h (1) = plot (NaN,NaN,'ko','MarkerFaceColor','y');
h (2) = plot (NaN,NaN,'ko','MarkerFaceColor','b');
legend (h,'Nodes','Controllers');
end
%{
close all;
clear all;
fileName = 'Iris.graphml'; %file
inputfile = fopen(fileName); 
[topology,latlong,nodenames,mat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2);
controllerPositions = [12 14 17]; %list of controllers
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
xlabel ('Longitude');
ylabel ('Latitude');
h = zeros (2,1);
h (1) = plot (NaN,NaN,'ko','MarkerFaceColor','y');
h (2) = plot (NaN,NaN,'ko','MarkerFaceColor','b');
legend (h,'Nodes','Controllers');
%}
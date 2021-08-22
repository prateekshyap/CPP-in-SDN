clear all;
close all;
fileName = 'Iris.graphml'; %network
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2); %number of controllers
maxNoc = 8; %maximum number of controllers
latArr = zeros (2,maxNoc); %to store the latencies
costArr = zeros (2,maxNoc); %to store the costs
%{
    first rows will contain the costs according to the latencies and second
    rows will contain the latencies according to the costs
%}
for noc = 1 : maxNoc %for each number of controllers
    minLat = 100000; %initialize the value to infinity
    costAccLat = 0;
    minCost = 10000000; %initialize the value to inifinity
    latAccCost = 0;
    c = combnk (1 : n,noc); %storing the combinations
    s2 = size (c);
    combs = s2 (1,1);
    for conts = 1 : combs %for each combination
        controllers = zeros (1,noc);
        controllers (1,1:noc) = c (conts, 1:noc); %store the list of controllers into controllers
        sp = zeros (noc, n); %to store the shortest paths from all the controllers individually taken as sources
        connections = zeros (noc, n); %to store the connections
        %find out the shortest paths
        for i = 1 : noc %for each controller
            sp (i, 1:n) = bellmanFord (n, mat, controllers (i)); %calculate the shortest paths
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
        lat = avgLatency (connections, n, n, noc, controllers); %calculating the average latency
        cost = calculateCost (sp, connections, n, noc, controllers); %calculating the cost
        if (lat < minLat) %if we get optimal latency
            minLat = lat; %store it to minimum latency
            costAccLat = cost; %also store the cost for the same combination
            %{
            This will plot the first curve i.e. cost according to latency
            %}
        end
        if (cost < minCost) %if we get optimal cost
            minCost = cost; %store it to minimum cost
            latAccCost = lat; %also store the latency for the same combination
            %{
            This will plot the second curve i.e. latency according to cost
            %}
        end
    end
    %store to the arrays
    latArr (1,noc) = minLat;
    costArr (1,noc) = costAccLat;
    costArr (2,noc) = minCost;
    latArr (2,noc) = latAccCost;
    latArr
    costArr
end
latArr
costArr

figure (1);
plot (latArr (1,1:maxNoc), costArr (1,1:maxNoc), 'b-s');
xlabel ('Latency');
ylabel ('cost');

figure (2);
plot (costArr (2,1:maxNoc), latArr (2,1:maxNoc), 'm-o');
xlabel ('Cost');
ylabel ('Latency');
function [ lat ] = avgLatency ( conns, n, non, noc, controllers )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sum = 0;
arr = zeros (1,n); %to store the switch-controller latencies
index = 1; %to keep track of the controllers
for i = 1 : n %for each node
    if (index <= noc && i == controllers (1,index)) %if the node is a controller
        index = index + 1; %increment the index
        continue; %don't execute the loop further
    else
	%{
		finding out the latencies of the nodes
	%}
        for j = 1 : noc
            arr (1,i) = arr (1,i) + conns (j,i);
        end
    end
end
for i = 1 : n %for each node
    sum = sum + arr (i); %adding the shortest distances add the latencies
end
lat = sum / non; %dividing by the total number of nodes
end
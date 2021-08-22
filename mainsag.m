close all;clear;
clc;
% fileName = 'DeutscheTelekom.graphml';
%fileName = 'TATANET.graphml';
% fileName = 'Chinanet.graphml'
%  fileName = 'Ibm.graphml';
fileName = 'Agis.graphml';
inputfile = fopen(fileName);
k=5;

nm=cell(1,k);
[topology,latlong,nodenames,A,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
for j=1:k
[IDX,C,d,m,distt] = kmeans(A,j); 
figure;
plot_scheme={'-bo','bo','bo','bo','bo','b^','m^','b^','g^','r^'};
nm=cell(1,k);
for i=1:size(IDX,1)
   for j1=1:k
   if IDX(i,1) == j1
        plot(latlong(i,1),latlong(i,2),char(plot_scheme{j1}));
        
   end
   end
   hold on;
end
for i=1:size(IDX,1)
    d(i,1)=0;
end
xlabel('Longitude');
ylabel('Latitude');
for i=1:size(IDX,1)
    for j=1:size(IDX,1)
        if A(i,j)>0
        d(i,1)=d(i,1)+1;
        end
    end
end
y=0;
for i=1:size(IDX,1)
    if d(i,1) > 4
        plot(latlong(i,1),latlong(i,2),'rx')
        text(latlong(i,1),latlong(i,2),strcat(nodenames(i),num2str(i)))
        y=y+1;
    end
    
end
% plot(latlong(2,1), latlong(2,2),'rx');
% plot(latlong(10,1), latlong(10,2),'rx');
% plot(latlong(13,1), latlong(13,2),'rx');
% plot(latlong(16,1), latlong(16,2),'rx');
% plot(latlong(21,1), latlong(21,2),'rx');

end
y

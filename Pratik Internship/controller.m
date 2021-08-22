clear all;
%latlong=[0.10 10.21;
%         -0.30 15.42;
%         0.67 0.43;
%         -0.12 0.65;
%         0.35 0.48;
%         0.32 0.58;];
fileName = 'Janetbackbone.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName);
noc=3;%number of controllers
non=size(latlong,1);%number of nodes in the given network
flag=1;
%tempdistcont=zeros(non,noc);%tempdistcont is an array that store deviation from the current controllers
min=zeros(non,1);
%--------------------------------------------------------------
%plotting of the network
%--------------------------------------------------------------
% figure;
% plot(latlong(:,1),latlong(:,2),'.');
% title 'Matrix';
%--------------------------------------------------------------
%K-means algorithm implementation
%--------------------------------------------------------------
%opts = statset('Display','final');
%[idx,C] = kmeans(latlong,2,'Distance','cityblock','Replicates',5,'Options',opts);
tempidx=zeros(non+1,noc);%tempidx is an array contains the controllers' index and eucledian distance from indices to controller 
matx=zeros(non+1,noc);
idx=zeros(non,1);%idx is an array contains the node belonging to which controller
while(flag~=0)
    [controllers flag]=distinct(randi([1,non],1,noc));%controllers is an array generate random controller position
end
tempidx(1,1:noc)=sort(controllers(1,1:noc));
for i=2:non+1
    for j=1:noc
        tempidx(i,j)=999;
    end
end
%C is an array which store the lattitude and longitude from the latlong matrix of the controlles
C=zeros(noc,2);
iteration=0;
% temp=zeros(noc,noc);
while(~(isequal(matx(1,1:noc),tempidx(1,1:noc))))
for i=1:noc
    for j=1:2
        for k=1:non
            if(tempidx(1,i)==k)
                C(i,j)=latlong(k,j);
            end
        end
    end
end
  %  temp=C;
  iteration=iteration+1;
%Eucledian distance calculation
for i=1:noc
    for j=2:non+1
        if((j-1)==tempidx(1,i))
            tempidx(j,i)=0;
        else
            tempidx(j,i)=sqrt( ( (latlong(j-1,1)-C(i,1))*(latlong(j-1,1)-C(i,1)) ) + ( (latlong(j-1,2)-C(i,2))*(latlong(j-1,2)-C(i,2)) ) );
        end
    end
end
min=tempidx(2:non+1,1);
for i=2:non+1
    for j=1:noc
        if(min(i-1,1)>=tempidx(i,j))
            min(i-1,1)=tempidx(i,j);
        end
    end
end
matx=tempidx;
matx
idx(1:non,1)=tempidx(1,1);
%this loop is to place the controller index in corresponding node
for i=2:non+1
    for j=1:noc
        if(min(i-1,1)==tempidx(i,j))
            idx(i-1,1)=tempidx(1,j);
        else
            tempidx(i,j)=999;
        end
    end
end
idx
for i=1:noc
   c=0;
   sumx=0;
   sumy=0;
   avg=1; 
   for j=1:non
       if(tempidx(1,i)==idx(j,1))
           sumx=sumx+latlong(j,1);
           sumy=sumy+latlong(j,2);
           c=c+1;
       end
   end
   C(i,1)=sumx/c;
   C(i,2)=sumy/c;
end
dist=zeros(non,noc);
for i=1:non
    dist(i,1:noc)=999;
end
for i=1:non
    for j=1:noc
        dist(i,j)=sqrt( ((latlong(i,1)-C(j,1))*(latlong(i,1)-C(j,1))) + ((latlong(i,2)-C(j,2))*(latlong(i,2)-C(j,2))) );
    end
end
dist
for i=1:noc
    for j=2:non
        %if(tempidx(1,i)~=selected(1,i))
            if(dist(tempidx(1,i),i)>dist(j-1,i))
                tempidx(1,i)=j-1;
                dist(tempidx(1,i),1:noc)=999;
            end
        %end
    end
end
end
%--------------------------------------------------------------
%plotting of the cluster divison
%--------------------------------------------------------------
figure;
plot(latlong(idx==tempidx(1,1),1),latlong(idx==tempidx(1,1),2),'r.','MarkerSize',12)
hold on
plot(latlong(idx==tempidx(1,2),1),latlong(idx==tempidx(1,2),2),'b.','MarkerSize',12)
hold on
plot(latlong(idx==tempidx(1,3),1),latlong(idx==tempidx(1,3),2),'g.','MarkerSize',12)
hold on
%plot(latlong(idx==tempidx(1,4),1),latlong(idx==tempidx(1,4),2),'y.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
    'MarkerSize',15,'LineWidth',3) 
% legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids',...
%         'Location','NE')
 title 'Cluster Assignments and Centroids'
h = zeros (4,1);
h(1) = plot (NaN,NaN,'r.','MarkerSize',12);
h(2) = plot (NaN,NaN,'b.','MarkerSize',12);
h(3) = plot (NaN,NaN,'g.','MarkerSize',12);
%h(4) = plot (NaN,NaN,'y.','MarkerSize',12);
h(4) = plot (NaN,NaN,'kx','MarkerSize',12,'LineWidth',2);
legend(h,'Cluster 1','Cluster 2','Cluster 3','Centroids','location','SW');
% figure;
% for i=1:non
%    if(idx(i,1)==tempidx(1,1))
%        plot(latlong(i,1),latlong(i,2),'r.','MarkerSize',12);
%    elseif(idx(i,1)==tempidx(1,2))
%        plot(latlong(i,1),latlong(i,2),'g.','MarkerSize',12);
%    else
%        fprintf('!Error');
%    end
%    hold on
% end
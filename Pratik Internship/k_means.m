clear all;
% latlong=[185 72;
%          170 56;
%          168 60;
%          179 68;
%          182 72;
%          188 77;
%          ];
fileName = 'Janetbackbone.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName);
noc=2;%number of controllers
non=size(latlong,1);
C=zeros(noc,2);
idx=zeros(non,1);
cent=zeros(noc,2);
dist=zeros(non+1,noc);
min=zeros(non,1);
for i=1:noc
    C(i,1)=latlong(i,1);
    C(i,2)=latlong(i,2);
end
for i=1:noc
    cent(i,1)=i;
end
centroid=zeros(noc,noc);
dist(1,1:noc)=cent(1:noc,1);
for i=1:noc
    for j=1:noc
        centroid(i,j)=sqrt( (C(i,1)-C(j,1))*(C(i,1)-C(j,1)) + (C(i,2)-C(j,2))*(C(i,2)-C(j,2)) );
    end
end
c=1;
for i=1:noc
    for j=1:noc
        if(centroid(i,j)==0)
            cent(j,2)=c;
            c=c+1;
        end
    end
end
min(1:non,1)=999;
for i=1:non
    for j=1:noc
        dist(i+1,j)=sqrt(( (C(j,1)-latlong(i,1)) * (C(j,1)-latlong(i,1)) ) + ( (C(j,2)-latlong(i,2)) * (C(j,2)-latlong(i,2)) ));
        if(dist(i+1,j)<=min(i,1))
            min(i,1)=dist(i+1,j);
            idx(i,1)=dist(1,j);
            C(j,1)=(C(j,1)+latlong(i,1))/2;
            C(j,2)=(C(j,2)+latlong(i,2))/2;
        end
    end
end
figure;
plot(latlong(idx==dist(1,1),1),latlong(idx==dist(1,1),2),'r.','MarkerSize',12)
hold on
plot(latlong(idx==dist(1,2),1),latlong(idx==dist(1,2),2),'b.','MarkerSize',12)
hold on
plot(latlong(idx==dist(1,3),1),latlong(idx==dist(1,3),2),'g.','MarkerSize',12)
hold on
plot(latlong(idx==dist(1,4),1),latlong(idx==dist(1,4),2),'y.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
    'MarkerSize',15,'LineWidth',3) 
 title 'Cluster Assignments and Centroids'
h = zeros (5,1);
h(1) = plot (NaN,NaN,'r.','MarkerSize',12);
h(2) = plot (NaN,NaN,'b.','MarkerSize',12);
h(3) = plot (NaN,NaN,'g.','MarkerSize',12);
h(4) = plot (NaN,NaN,'y.','MarkerSize',12);
h(5) = plot (NaN,NaN,'kx','MarkerSize',12,'LineWidth',2);
legend(h,'Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids','location','SW');

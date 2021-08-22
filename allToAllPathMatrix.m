function [distanceMatrix1 P] = allToAllPathMatrix(node,latlong,edges)
sze=size(latlong);
sigma=1;
distanceMatrix=1./zeros(size(node,2),size(node,2));
k=1;
node=node-1;
for i=1:size(edges,2)
    if ~isempty(find(node==edges(i).source)) && ~isempty(find(node==edges(i).target)+1)
        P(k,1)=edges(i).source;
        P(k,2)=edges(i).target;
        k=k+1;
    end
end
for i=1:size(P,1)

% for k=1:size(P,1)
%    if i==P(k,1) && j==P(k,2)
 distanceMatrix(find(node==P(i,1)),find(node==P(i,2)))=sqrt(( power((latlong(P(i,1)+1,1)-latlong(P(i,2)+1,1)),2) )+( power(( latlong(P(i,1)+1,2)-latlong(P(i,2)+1,2)),2) ));
%     distanceMatrix(find(node==P(i,1)),find(node==P(i,2)))=distFrom(latlong(P(i,1)+1),latlong(P(i,2)+1));    
% distanceMatrix(find(node==P(i,1)),find(node==P(i,2)))=distFrom(P(i,1),P(i,2));
distanceMatrix(find(node==P(i,2)),find(node==P(i,1)))=distanceMatrix(find(node==P(i,1)),find(node==P(i,2)));
%      end
% end
end

distanceMatrix1=exp(-distanceMatrix/(2*sigma^2));


end
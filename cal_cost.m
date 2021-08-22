function [ cost,dist_mat,cluster ] = cal_cost( data,medoid,A,B )

[m,n]=size(data);
[p,q]=size(medoid);
for j=1:q
    for i=1:m
       [dist_mat(i,j),d]=dijkstra1(B,A,i,medoid(j));
    end
end
for i=1:m
    min=dist_mat(i,1);
    cluster(i,1)=1;
    for j=1:q
        if(min>dist_mat(i,j))
            cluster(i,1)=j;
            min=dist_mat(i,j);
        end
    end
    cost(i,1)=min;
end
end


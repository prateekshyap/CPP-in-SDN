function [mat flag]=distinct(mat)
flag=0;
for i=1:length(mat)
    for j=2:length(mat)
        if(i==j)
            continue;
        end
        if(mat(1,i)==mat(1,j))
            flag=flag+1;
        end
    end
end
end
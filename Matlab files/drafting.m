function [ draft ] = drafting( noc, pop, member1, member2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    for k = 1 : noc %for each controller present in 1st member i.e. c1
        draft (1, k) = pop (member1, k); %insert all the nodes to draft
    end
    din = noc+1; %index to update the draft
    for j = 1 : noc %for each controller present in 2nd member i.e. c2
        flag3 = 0; %an indicator variable
        for in = 1 : noc %for each controller present in draft
            if (draft (1,in) == pop (member2, j)) %if jth node is equal to the in'th node in the draft
                flag3 = 1; %update flag
                break; %break the loop to reject the node
            end
        end 
        if (flag3 == 0) %if the jth node is a new node
            draft (1, din) = pop (member2,j); %add it to the draft
            din = din + 1; %increment the index by 1
        end
    end
end
function [ member1, member2 ] = randomSelection( ps )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    member1 = randi ([1 ps],1,1); %1st member
    member2 = randi ([1 ps],1,1); %2nd member
    while (member1 == member2) %while both are equal
        member2 = randi ([1 ps],1,1); %change one of them
    end
end


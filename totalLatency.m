function [ lat ] = totalLatency ( sp, n )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sum = 0;
for i = 1 : n
    sum = sum + sp (i);
end
lat = sum;
end
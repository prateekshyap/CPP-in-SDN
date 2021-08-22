function [ c1, c2 ] = partiallyMappedCrossover( s1, s2, size, cStart, cEnd )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% size = 8; %size of the parent string
% s1 = [1 2 3 4 5 6 7 8]; %1st parent string
% s2 = [3 7 5 1 6 8 2 4]; %2nd parent string
c1 = zeros (1, size); %1st offspring
c2 = zeros (1, size); %2nd offspring
% cStart = randi ([1 size-1],1,1); %starting cut point
% cEnd = randi ([cStart+1 size],1,1); %ending cut point
% cStart
% cEnd
crossovers = zeros(cEnd-cStart+1, 2); %a matrix to store the mappings
chain = [s1(cStart:cEnd), s2(cStart:cEnd)]; %an array to store the positions which are to be changed
chain = sort (chain); %sort the chain
for i = cStart : cEnd %for each position within the crossover window
    crossovers(i-cStart+1, 1) = s1(i); %store the substring of 1st parent into 1st column
    crossovers(i-cStart+1, 2) = s2(i); %store the substring of 2nd parent into 2nd column
    c1(i) = s2(i); %store 2nd parent to 1st offspring
    c2(i) = s1(i); %store 1st parent to 2nd offspring
end
for i = 1 : size %for each element in the 1st parent
    if (i < cStart || i > cEnd) %if i doesn't fall within the crossover window
        flagPresence = 0; %initialize the flag variable to 0
        for checker = 1 : 2*(cEnd-cStart+1) %for each element within the crossover window
            if (chain(checker) == s1(i)) %if the element of 1st parent falls within the crossover window
                flagPresence = 1; %update the flag to 1
                break; %break the for loop
            end
        end
        if (flagPresence == 0) %if flag indicates 0 i.e. mapping not needed
            c1(i) = s1(i); %copy the element from 1st parent to 1st offspring
        elseif (flagPresence == 1) %if flag is 1 i.e. mapping is to be done
            chainElem = s1(i); %a variable to store the target element
            check = 1; %loop counter
            while (check <= cEnd-cStart+1) %loop counter must not be greater than the crossover window size
                while (crossovers(check,2) == chainElem) %while the target element is equal to mapping element
                    c1(i) = crossovers(check,1); %copy the mapping element to 1st offspring
                    chainElem = c1(i); %copy the same value to the target variable
                    check = 1; %reset check to 1 for further mapping
                end
                check = check + 1; %increment the loop counter
            end
        end
    end
end
for i = 1 : size %for each element in 2nd parent
    if (i < cStart || i > cEnd) %if i doesn't fall within the crossover window
        flagPresence = 0; %initialize the flag variable to 0
        for checker = 1 : 2*(cEnd-cStart+1) %for each element within the crossover window
            if (chain(checker) == s2(i)) %if the element of the 2nd parent falls within the crossover window
                flagPresence = 1; %update the flag to 1
                break; %break the for loop
            end
        end
        if (flagPresence == 0) %if flag is 0 i.e. mapping not needed
            c2(i) = s2(i); %copy the element from 2nd parent to 2nd offspring
        elseif (flagPresence == 1) %if flag is 1 i.e. mapping is to be done
            chainElem = s2(i); %a variable to store the target element
            check = 1; %loop counter
            while (check <= cEnd-cStart+1) %%loop counter must not be greater than the crossover window size
                while (crossovers(check,1) == chainElem) %while the target element is equal to the mapping element
                    c2(i) = crossovers(check,2); %copy the mapping element to 2nd offspring
                    chainElem = c2(i); %copy the same value to the target variable
                    check = 1; %reset check to 1 for further mapping
                end
                check = check + 1; %increment the loop counter
            end
        end
    end
end
% s1
% s2
% crossovers
% c1
% c2
end
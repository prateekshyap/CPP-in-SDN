function [ c1, c2 ] = membersForDrafting ( l, po, noc, c, pop, ps )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    occCounter = 0; %a variable to keep track of the number of members having occurrence more than one
    c1 = 0; %1st member
    c2 = 0; %2nd member
    m1 = 0; %temporary 1st member
    flag1 = 0; %an indicator
    for u = 1 : l %for each combination
        if ((po (1,u) > 1) && (occCounter == 0)) %if the occurrence of uth combination is more than one and it is first such combination
            occCounter = occCounter + 1; %increment the counter
            m1 = u; %saving the combination for future reference
        elseif ((po (1,u) > 1) && (occCounter == 1)) %if the occurrence of uth combination is more than one and it is second such combination
            occCounter = occCounter + 1; %increment the counter
            flag1 = 1; %update the indicator
            break; %break from the loop
        end
    end
    if (flag1 == 1) %if there are at least two such members whose probability of occurrence is more than 1
        %go for roulette wheel selection
        [c1, c2] = rouletteWheelForGeneticAlgorithm (l, po, noc, c, pop, ps); %call roulette wheel function
    elseif (occCounter == 1) %if only one such member is present
        %select the 2nd member randomly
        flag2 = 0; %an indicator variable
        %finding out the index of m1 in populations matrix
        for v = 1 : ps %for each population
            if (c(m1,1:noc) == pop (v,1:noc)) %if m1'th member of c is equal to vth member of populations
                c1 = v; %store v to c1;
                flag2 = 1; %update the indicator
                break; %break the loop
            end
        end
        c2 = randi ([1 ps],1,1); %2nd member
        while (c1 == c2) %while both are equal
            c2 = randi ([1 ps],1,1); %change one of them
        end
    else %if all the members are unique
        %go for random selection
        c1 = randi ([1 ps],1,1); %1st member
        c2 = randi ([1 ps],1,1); %2nd member
        while (c1 == c2) %while both are equal
            c2 = randi ([1 ps],1,1); %change one of them
        end
    end
end
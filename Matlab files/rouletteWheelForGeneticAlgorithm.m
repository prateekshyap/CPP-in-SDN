    function [ member1, member2 ] = rouletteWheelForGeneticAlgorithm ( noc, c, pop, ps, fv )
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
        [po, maxProb] = rouletteWheelSelection (ps, fv); %roulette wheel selection method
        thProb = maxProb; %a variable to store the threshold probability
        flag = 0; %an indicator variable
        member1 = 0; %1st member
        member2 = 0; %2nd member
        while (member2 == 0) %the loop will run till the 2nd member is found
            for w = 1 : ps %for each probability
                if (po (1,w) >= thProb) %if the probability of occurrence is greater than or equal to the threshold probability
                    if (member1 == 0) %if first member is not found
                        member1 = w; %store w to c1
                    elseif ((member2 == 0) && (member1 ~= w)) %if second member is not found and the xth member is not equal to 1st member
                        member2 = w; %store w to c2
                    elseif ((member2 == 0) && (member1 == w)) %if 
                        continue;
                    else %if all the members are found
                        flag = 1; %update the indicator
                        break; %break the loop
                    end
                elseif (w == ps) %if this is the last iteration
                    thProb = thProb - 0.25; %decrement the threshold probability by 0.25
                end
            end
        end
    end
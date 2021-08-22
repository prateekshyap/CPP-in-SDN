function [ rouletteWheelData, maxPerc ] = rouletteWheelSelection( ps, fv )
%UNTITLED2 Summary of this function goes here
%{
    ps = population size
    fv = array containing all the fitness values
    totalFitness = a variable to store the total fitness value
    totalProb = a variable to store the total probability which will always
    be equal to 1
    totalPerc = a variable to store the total percentage which will always
    be equal to 100
    avgFitness = a variable to store the average fitness value
    avgProb = a variable to store the average probability
    avgPerc = a variable to store the averate percentage which will always
    be equal to avgProb*100
    maxFitness = stores the maximum fitness value
    maxProb = stores the maximum probability
    maxPerc = stores the maximum percentage which will always be equal to
    maxProb*100
    expCount = stores the expected count values for each population
    rouletteWheelData = an array which stores the percentages for roulette wheel
%}
%   Detailed explanation goes here
totalFitness = 0;
for i = 1 : ps %for each population
    totalFitness = totalFitness + fv (1,i); %add the values from fitness values array
end
avgFitness = totalFitness / ps; %divide total fitness by the number of populations
maxFitness = fv (1,1);
for i = 2 : ps %for each population
    if (fv (1,i) > maxFitness) %if the new value is greater than the maximum value
        maxFitness = fv (1,i); %update the maximum value
    end
end
prob = zeros (1,ps);
%calculating the probabilities
for i = 1 : ps %for each population
    prob (1,i) = fv (1,i) / totalFitness; %divide the fitness values by the total fitness value
end
totalProb = 0;
for i = 1 : ps %for each population
    totalProb = totalProb + prob (1,i); %add the values from probabilities array
end
avgProb = totalProb / ps; %divide total probability by the number of populations
maxProb = prob (1,1);
for i = 2 : ps %for each population
    if (prob (1,i) > maxProb) %if the new value is greater than the maximum value
        maxProb = prob (1,i); %update the maximum value
    end
end
%calculate the expected count
expCount = zeros (1,ps);
for i = 1 : ps %for each population
    expCount (1,i) = fv (1,i) / avgFitness; %divide the fitness values by the avergae fitness value
end
%calculating the percentages for the roulette wheel
rouletteWheelData = zeros (1,ps);
for i = 1 : ps % %for each population
    rouletteWheelData (1,i) = prob (1,i) * 100; %multiply the probabilities with 100 to get the percentages
end
totalPerc = 0;
for i = 1 : ps  %for each population
    totalPerc = totalPerc + rouletteWheelData (1,i);  %add the values from percentages array
end
avgPerc = totalPerc / ps;  %divide total percentage by the number of populations
maxPerc = rouletteWheelData (1,1);
for i = 2 : ps  %for each population
    if (rouletteWheelData (1,i) > maxPerc)  %if the new value is greater than the maximum value
        maxPerc = rouletteWheelData (1,i);  %update the maximum value
    end
end
end
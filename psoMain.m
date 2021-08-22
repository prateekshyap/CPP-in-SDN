clear all;
close all;
clc;

%% declaring the variables
iterations = 100; %maximum number of iterations
c1 = 2; %cognitive learning factor
c2 = 2; %social learning factor
r1 = 0.5; 
r2 = 0.5; 
w = 1; %inertia weight
wDamp = 0.98; %0.99 %damping factor
populationSize = 20; %size of the population
maxVelocity = 1; %maximum velocity which should not be exceeded

%% preparing the network
fileName = 'Janetbackbone.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,mat,P]= importGraphML(fileName); %--Read GML file to find nodes and adjacency matrix-
s = size (mat);
n = s (1,2); %number of nodes

%% running the pso algorithm
x = zeros(1,iterations);
for k = 1 : iterations
    x(k)=k;
end
maxNoc = 10;
x2 = zeros(1,maxNoc);
y = zeros(1,maxNoc);
for noc = 1 : 10 %for these number of controllers
    x2(noc) = noc;
    %% generating the initial population
    coOrd = 2*noc; %total number of coordinates for a single position
    populations = zeros(populationSize,noc);
    for i = 1 : populationSize %for each population
        tempArr = randi (n, 1, noc); %a temporary array to store the randomly selected controllers
        tempArr = sort (tempArr); %sort the array in ascending order
        %replace duplicate elements with new ones i.e. no controller should be repeated
        for j = 1 : noc %for each controller
            index = j+1; %a variable to keep track of the duplicate controllers
            while ( index <= noc && tempArr (j) == tempArr (index) ) %while index is less than the total number of controllers and jth controller is equal to it
                tempArr (index) = 0; %remove the controller and make it 0
                index = index + 1; %increment the index
            end
        end
        for j = 1 : noc %for each controller
            if ( tempArr (j) == 0 ) %if the controller has been removed
                flag = 1; %set flag to 1 initially
                while (flag == 1) %run the loop till flag remains 1
                    num = randi ([1 n],1,1); %generate a new random controller
                    flag = 0; %update flag to 0
                    for k = 1 : noc %for each controller
                        if ( tempArr (k) == num ) %if the controller is already present in the population
                            flag = 1; %update flag to 1
                            break; %break the for loop
                        end
                    end
                    if ( flag == 0 ) %if flag is 0 i.e. the randomly generated controller is new
                        tempArr (j) = num; %store it to the vacant place
                    elseif ( flag == 1 ) %if flag is 1 i.e. the randomly generated controller is already present in the population
                        continue; %continue the while loop to generate a new controller
                    end
                end
            end
        end
        tempArr = sort (tempArr); %sort the populations array
        populations (i,1:noc) = tempArr; %store it to the populations matrix
    end
    populations
    
    %% storing the latitude and longitude values of the initial population
    % node is a structure containing x and y coordinates of any node
    node.xCoord = [];
    node.yCoord = [];
    
    initialPositions = repmat(node,populationSize,noc);
    for i = 1 : populationSize
        for j = 1 : noc
            initialPositions(i,j).xCoord = latlong(populations(i,j),1);
            initialPositions(i,j).yCoord = latlong(populations(i,j),2);
        end
    end
    
    %% printing the coordinates of the population
    for kk = 1 : populationSize
        for j = 1 : noc
            xVal = initialPositions(kk,j).xCoord;
            yVal = initialPositions(kk,j).yCoord;
            fprintf('%4.4f\t%4.4f\t',xVal,yVal);
        end
        fprintf('\n');
    end
    
    %% running the pso algorithm
    [bestCosts, optLoc, optCost] = particleSwarmOptimization(iterations, c1, c2, r1, r2, w, wDamp, initialPositions, populations, populationSize, coOrd, mat, n, latlong);
    y(noc) = optCost
    optLoc
end

%% plotting the graphs
% figure;
% plot (x,bestCosts);
% figure;
% semilogy(bestCosts);
figure
plot(x2,y);
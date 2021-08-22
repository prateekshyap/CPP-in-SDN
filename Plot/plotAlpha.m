function [ ] = plotAlpha (mat, n, m, minAlpha, maxAlpha, intervalAlpha, minNoc, maxNoc, intervalNoc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = [minNoc : maxNoc]; % X-axis
alphaCounter = 0;
for g = minAlpha : intervalAlpha : maxAlpha
    alphaCounter = alphaCounter + 1;
end
controllerList = randi ([1,n],1,maxNoc); %probable list of controllers
% testMatWf = zeros (6,7);
% testMatTf = zeros (6,7);
plotMatrix = zeros (alphaCounter * (m+1) , maxNoc-minNoc+1); %a matrix to store all the Y-axis values\
minRowIn = 1; 
maxRowIn = m+1; %to keep track of the next row of plotMatrix
colIn = 1; %to keep track of the next column of plotMatrix
% rowIn2 = 1;
% colIn2 = 1;
for i = minAlpha : intervalAlpha : maxAlpha %for each value of alpha
    for j = minNoc : intervalNoc : maxNoc %for each no of controllers
%         controllers = randi ([1,n],1,j); %list of controllers
        costs = zeros (1, m+1); %costs for each level
        w1 = capacitedCost (controllerList (1, 1 : j), mat, n); %cost for no failure
        w2 = 0;
        costs (1,1) = (i * w1) + ((1 - i) * w2);
%         testMatTf (rowIn2, 
        for k = 1 : m %for each failure level
            w2 = randomizedPlannedControllerPlacement (controllerList (1, 1 : j), mat, n, 1); %for failure
            costs (1, k+1) = (i * w1) + ((1 - i) * w2);
        end
        costs = costs';
        plotMatrix (minRowIn : maxRowIn, colIn) = costs; %storing the cost values to plotMatrix
        colIn = colIn + 1; %incrementing the column counter to store the cost for next combination of controllers
    end
    colIn = 1;
    minRowIn = maxRowIn + 1;
    maxRowIn = minRowIn + m;
end
% for i = 1 : alphaCounter * (m+1)
%     p = plot (x, plotMatrix (i, 1 : maxNoc-minNoc+1),'k-o');
%     hold on;
% end
plot (x, plotMatrix (1, 1 : maxNoc-minNoc+1), 'b-o');
hold on;
plot (x, plotMatrix (2, 1 : maxNoc-minNoc+1), 'b-x');
hold on;
plot (x, plotMatrix (3, 1 : maxNoc-minNoc+1), 'g-+');
hold on;
plot (x, plotMatrix (4, 1 : maxNoc-minNoc+1), 'g-s');
hold on;
plot (x, plotMatrix (5, 1 : maxNoc-minNoc+1), 'r-d');
hold on;
plot (x, plotMatrix (6, 1 : maxNoc-minNoc+1), 'r-^');
hold on;
plot (x, plotMatrix (7, 1 : maxNoc-minNoc+1), 'm-*');
hold on;
plot (x, plotMatrix (8, 1 : maxNoc-minNoc+1), 'm-p');
xlabel ('Number of controllers');
ylabel ('Cost');
legend ('without failure &   = 0.2','with failure &   = 0.2','without failure &   = 0.4','with failure &   = 0.4','without failure &   = 0.6','with failure &   = 0.6','without failure &   = 0.8','with failure &   = 0.8');
% legend ('without failure & alpha = 0.3','with failure & alpha = 0.3','without failure & alpha = 0.6','with failure & alpha = 0.6','without failure & alpha = 0.9','with failure & alpha = 0.9');
% legend ('without failure & alpha = 0.4','with failure & alpha = 0.4','without failure & alpha = 0.6','with failure & alpha = 0.6','without failure & alpha = 0.8','with failure & alpha = 0.8');
end
% n = number of vertices, mat = adjacency matrix, l = latency
close all
clear all
% xin = 1; %index counter for x axis
% yin = 1; %index counter for y axis
%  mat = [ 0 1 2 2;
%          1 0 4 0;
%          2 4 0 1;
%          2 0 1 0 ];
% mat = [ 0  1  0  0  2;
%         1  0  2  5  4;
%         0  2  0  3  0;
%         0  5  3  0  1;
%         2  4  0  1  0 ];

% %       1  2  3  4  5  6
% mat = [ 0  1  2  0  3  4; %1
%         1  0  4  3  1  2; %2
%         2  4  0  1  3  0; %3
%         0  3  1  0  4  2; %4
%         3  1  3  4  0  1; %5
%         4  2  0  2  1  0 ]; %6

% %nsf network
% %           0     1     2     3     4     5     6     7     8     9    10    11    12    13    14    15
% mat = [     0  1.13  7.84     0     0     0     0     0     0     0     0     0     0     0     0     0; %0
%          1.13     0     0   6.7    10     0     0     0     0  17.3     0     0     0     0     0     0; %1  
%          7.84     0     0   6.1     0   4.2     0     0     0     0     0     0 12.97     0     0     0; %2  
%             0   6.7   6.1     0   3.8     0     0     0     0     0     0     0     0     0     0     0; %3    
%             0    10     0   3.8     0     0 11.76     0     0     0     0     0     0     0     0     0; %4  
%             0     0   4.2     0     0     0   9.1   4.0     0     0     0     0     0     0     0     0; %5  
%             0     0     0     0 11.76  9.10     0     0  5.84     0 11.38     0     0     0     0     0; %6  
%             0     0     0     0     0   4.0     0     0     0  4.32     0     0     0     0     0     0; %7  
%             0     0     0     0     0     0  5.84     0     0     0     0   5.5     0     0     0     0; %8  
%             0  17.3     0     0     0     0     0  4.32     0     0     0  3.88     0     0     0     0; %9  
%             0     0     0     0     0     0 11.38     0     0     0     0     0     0  2.86  1.39     0; %10  
%             0     0     0     0     0     0     0     0   5.5  3.88     0     0     0  2.45  2.68     0; %11 
%             0     0 12.97     0     0     0     0     0     0     0     0     0     0  3.77   4.9     0; %12 
%             0     0     0     0     0     0     0     0     0     0  2.86  2.45  3.77     0     0  2.46; %13 
%             0     0     0     0     0     0     0     0     0     0  1.39  2.68   4.9     0     0  3.25; %14 
%             0     0     0     0     0     0     0     0     0     0     0     0     0  2.46  3.25     0; %15 
% ];

%national network
%        0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
mat2 = [ 0  0  0  0  0  0  0  0  1  2  0  0  0  0  0  0  0  0  0  0  0  0  0  3; %0
		 0  0  4  0  0  5  0  0  0  6  0  0  0  0  0  0  0  0  0  0  0  0  0  0; %1
  		 0  4  0  7  8  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0; %2
         0  0  7  0  9  0  0 10 11 12  0  0  0  0  0  0  0  0  0  0  0  0  0  0; %3
         0  0  8  9  0 13 14 15  0  0  0  0 16  0  0  0  0  0  0  0  0  0  0  0; %4
		 0  5  0  0 13  0  0  0  0  0 10  0  0  0  0  0  0  0  0  0  0  0  0  0; %5
  		 0  0  0  0 14  0  0 19  0  0  0  0 20 21 22 23  0  0  0  0  0  0  0  0; %6
         0  0  0 10 15  0 19  0 24  0  0  0  0  0  0 25 26 27  0  0  0  0  0  0; %7
         1  0  0 11  0  0  0 24  0 28  0  0  0  0  0  0  0 29  0  0  0  0 31  0; %8
		 2  6  0 12  0  0  0  0 28  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0; %9
  		 0  0  0  0  0 10  0  0  0  0  0 33 34  0  0  0  0  0  0  0  0  0  0  0; %10
         0  0  0  0  0  0  0  0  0  0 33  0 35  0  0  0  0  0  0  0  0  0  0  0; %11
         0  0  0  0 16  0 20  0  0  0 34 35  0 36  0  0  0  0  0  0  0  0  0  0; %12
		 0  0  0  0  0  0 21  0  0  0  0  0 36  0 37  0  0  0  0  0  0  0  0  0; %13
  		 0  0  0  0  0  0 22  0  0  0  0  0  0 37  0 38  0  0  0  0  0  0  0  0; %14
         0  0  0  0  0  0 23 25  0  0  0  0  0  0 38  0 39  0  0  0  0  0  0  0; %15
         0  0  0  0  0  0  0 26  0  0  0  0  0  0  0 39  0 40  0  0  0  0  0  0; %16
		 0  0  0  0  0  0  0 27 29  0  0  0  0  0  0  0 40  0 41  0  0  0 43  0; %17
  		 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 41  0 44  0  0  0  0; %18
         0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 44  0 46  0  0  0; %19
         0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 46  0 48  0  0; %20
		 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 48  0 49  0; %21
  		 0  0  0  0  0  0  0  0 31  0  0  0  0  0  0  0  0 43  0  0  0 49  0 50; %22
         3  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 50  0; %23
];

%arpanet
%       0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
arpaMat = [ 0  0  0  0  0  0  0  0  0  0  0  0  0  0 32  0  0  2  0  3; %0
        0  0  4  5  0  0  6  0  0  0  0  0  0  0  0  0  0  0  0  0; %1
        0  4  0  0  7  8  0  0  0  0  0  0  0  0  0  0  0  0  0  0; %2
        0  5  0  0  0  0  0  9 10  0  0  0  0  0  0  0  0  0  0  0; %3
        0  0  7  0  0 11  0  0  0  0  0 12  0  0  0  0  0  0  0  0; %4
        0  0  8  0 11  0 13  0  0  0  0  0  0  0  0  0  0  0  0  0; %5
        0  6  0  0  0 13  0 14  0  0  0  0  0  0  0  0  0  0  0  0; %6
        0  0  0  9  0  0 14  0  0  0 15  0  0  0  0  0  0  0  0  0; %7
        0  0  0 10  0  0  0  0  0 18 17  0 18  0  0  0  0  0  0  0; %8
        0  0  0  0  0  0  0  0 18  0 19 20  0  0  0  0  0  0  0  0; %9
        0  0  0  0  0  0  0 15 17 19  0  0  0  0  0  0  0  0  0 21; %10
        0  0  0  0 12  0  0  0  0 20  0  0  0 22  0  0  0  0  0  0; %11
        0  0  0  0  0  0  0  0 18  0  0  0  0  0 23  0  0  0 24  0; %12
        0  0  0  0  0  0  0  0  0  0  0 22  0  0  0 25  0 26  0  0; %13
       32  0  0  0  0  0  0  0  0  0  0  0 23  0  0 27  0  0 28  0; %14
        0  0  0  0  0  0  0  0  0  0  0  0  0 25 27  0 29  0  0  0; %15
        0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 29  0  0 30 31; %16
        2  0  0  0  0  0  0  0  0  0  0  0  0 26  0  0  0  0  0 32; %17
        0  0  0  0  0  0  0  0  0  0  0  0 24  0 28  0 30  0  0  0; %18
        3  0  0  0  0  0  0  0  0  0 21  0  0  0  0  0 31 32  0  0 ]; %19

% %k-critical
% %           1  2  3  4  5  6  7  8  9 10 11 12 13
% mat =     [ 0  4  4  6  0  0  0  0  0  0  0  0  0; %1
% 			4  0  5  0  0  0  0  7  8  0  0  0  0; %2
% 			4  5  0  0  1  0  0  0  0  0  0  0  0; %3
% 			6  0  0  0  0  3  0  0  0  0  0  0  0; %4
% 			0  0  1  0  0  0  3  0  0  0  0  0  0; %5
% 			0  0  0  3  0  0  4  0  0  6  0  0  0; %6
% 			0  0  0  0  3  4  0  0  2  0  0  0  0; %7
% 			0  7  0  0  0  0  0  0  0  0  0  5  0; %8
% 			0  8  0  0  0  0  2  0  0  0  4  0  0; %9
% 			0  0  0  0  0  6  0  0  0  0  7  0  8; %10
% 			0  0  0  0  0  0  0  0  4  7  0  5  0; %11
% 			0  0  0  0  0  0  0  5  0  0  5  0  7; %12
% 			0  0  0  0  0  0  0  0  0  8  0  7  0; %13
%  			];
% %      1 2 3 4 5 6
% mat = [0 3 5 0 2 0; %1
%        3 0 1 2 0 3; %2
%        5 1 0 4 3 5; %3
%        0 2 4 0 8 1; %4
%        2 0 3 8 0 0; %5
%        0 3 5 1 0 0]; %6
% n = 20; %total number of nodes

% to find out the position of the controller when a single controller is
% allowed
% 0 for average case latency and 1 for worst case latency
% controllerPosition = singleControllerSelection (n,mat,0);
% controllerPosition

% to find out the number of controllers which will give optimal performance
% at a lower cost
% multiController (mat, n);

% to find out the candidate list of controllers using k-nearest neighbour
% k = 3;
% candidates = locationSelector (mat,n,k);
% candidates

% to find out the positions of controllers using k-critical algorithm
% kCritical ([8 10 11 12], mat, n);


% % to find out the controller positions according to the node degrees
% %td = threshold degree
% n = 20;
% td = 4;
% controllerPositions = thresholdDegree (mat, n, td); 
% controllerPositions

% to find out the global average latency
% gl = globalAverageLatency (controllerPositions+1, mat, n);
% gl

% to find out the uncapacited cost
% cost = uncapacitedCost (controllerPositions+1, mat, n);
% cost
% cost = uncapacitedRandomCost (controllerPositions+1, mat, n);
% cost

% % to find out the capacited cost
% cost = capacitedCost (controllerPositions+1, mat, n);
% cost
% cost = capacitedRandomCost (controllerPositions+1, mat, n);
% cost

% to plot the capacited and uncapacited systems
% costPlot (mat, n);

% % to find out the capacited and failure planned cost
% cost = plannedControllerPlacement (controllerPositions+1, mat, n, 1);
% cost

%to plot the bar graph of arpanet for different levels of failures
% n=20;
% x = [0,1,2];
% costs = plotFailureLevelCosts (controllerPositions+1, mat, n, 2);
% bar (x,costs,0.5);
% title ('Controller Placement With Planning');
% ylabel ('Cost');
% legend ('ARPANET');

% %to compare the bar graphs for controller placement with planning for
% %arpanet and national network
% n1 = 20;
% n2 = 24;
% td = 4; 
% arpaPositions = thresholdDegree (mat1, n1, td);
% nationalPositions = thresholdDegree (mat2, n2, td);
% % x = categorical({'m=0','m=1','m=2'});
% x = {'r = 0','r = 1','r = 2'};
% arpa = plotFailureLevelCosts (arpaPositions+1, mat1, n1, 2);
% nat = plotFailureLevelCosts (nationalPositions+1, mat2, n2, 2);
% y = [arpa; nat];
% y = y';
% % bar (x,y);
% h = bar(y,1);
% set(gca,'xticklabel',x);
% title ('Controller Placement With Planning');
% ylabel ('Cost');
% xlabel ('Number of failures');
% legend ('ARPA Network', 'National Network');
% 
% fH = gcf;
% colormap(jet(4));
% 
% 
% % Apply Brandon's function
% tH = title('Controller Placement With Planning');
% applyhatch_pluscolor(fH, '\-x.', 0, [1 0 1 0], jet(4));
% 
% set(tH, 'String', 'Controller Placement With Planning');

% %to plot the networks from topologyzoo
% fileName = 'Agis.graphml';
% fileName = 'TATANET.graphml';
% fileName = 'Surfnet.graphml';
% inputfile = fopen(fileName);
% [topology,latlong,nodenames,mat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
% s = size (mat);
% n = s (1,2);
% td = 5;
% [degrees, controllerPositions] = thresholdDegree (mat, n, td);
% controllerPositions = controllerPositions + 1;
% controllerPositions
% for i = 1 : n
%    if (degrees (1,i) >= td)
%        plot(latlong(i,1),latlong(i,2),'ko','MarkerSize',10,'MarkerFaceColor','b');
%        plot(latlong(i,1),latlong(i,2),'k*','MarkerSize',10);
%    else
%        plot(latlong(i,1),latlong(i,2),'ko','MarkerFaceColor','c');
% %        plot(latlong(i,1),latlong(i,2),'ko');
%    end
%    hold on;
% end
% for i = 1 : n
% 	for j = 1 : n
% 		if (mat (i,j) ~= 0)
% 			x1 = latlong (i,1);
% 			x2 = latlong (j,1);
% 			y1 = latlong (i,2);
% 			y2 = latlong (j,2);
% 			plot ([x1 x2] , [y1 y2], '-k', 'MarkerEdgeColor', 'k',  'MarkerFaceColor','k');
% 		end
% 	end
% end
% G = graph(mat);
% p = plot(G,'layout','force')
% gplot (mat, latlong);

%to plot the latencies of various number of controllers for different
%failure levels
% % arpanet
% arpaN = 20;
% arpaMax = 5;
% multiControllerPlanning (arpaMat, arpaN, arpaMax);
% agis
% fileName = 'Agis.graphml';
% inputfile = fopen(fileName);
% [topology,latlong,nodenames,agisMat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
% s = size (agisMat);
% agisN = s (1,2);
% agisMax = 5;
% multiControllerPlanning (agisMat, agisN, agisMax);
% % multiControllerPlanningSubOptimal (agisMat, agisN, agisMax);
% % tatanet
% fileName = 'TATANET.graphml';
% inputfile = fopen(fileName);
% [topology,latlong,nodenames,tataMat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
% s = size (tataMat);
% tataN = s (1,2);
% tataMax = 8;
% multiControllerPlanning (tataMat, tataN, tataMax);
% surfnet
fileName = 'Surfnet.graphml';
inputfile = fopen(fileName);
[topology,latlong,nodenames,surfMat,P]= importGraphML(fileName);%--Read GML file to find nodes and adjacency matrix-
s = size (surfMat);
surfN = s (1,2);
surfMax = 6;
multiControllerPlanning (surfMat, surfN, surfMax);
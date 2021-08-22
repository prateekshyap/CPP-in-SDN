function [ balance, newConnections, newLoads, noc ] = loadBalancing (controllerList, controllerLoad, sp, packets, connections, modifyIndex, n, noc, alpha, cap)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    %updating the controller latencies
    index = 1; %to keep track of the controllers
    for i = 1 : n %for each node
        if (index <= noc && controllerList(index) == i) %if all the controllers are not checked and ith node is a controller
            connections (1:noc,i) = zeros (noc,1); %disconnect it from all the controllers virtually
            index = index + 1; %increment the index
        end
    end
    balance = 0; %an indicator to indicate that load balancing has been done
    newLoads = controllerLoad; %copy the loads
    newConnections = connections; %copy the connections
    
%     if (controllerLoad (1,modifyIndex) ~= 0) %the controller is overloaded    
        %case-1 - The switch which is putting highest load on the overloaded controller will be relocated to the nearest controller
        highestLoadingSwitch = 1; %a variable to store the number of the switch which is to be migrated
        maxPackets = 0; %a variable to store the maximum loading switch
        for i = 1 : n %for each node
            if (connections(modifyIndex,i) ~= 0 && packets(i) > maxPackets) %if the node is a switch and its load is greater than the maximum load
                maxPackets = packets(i); %update the maximum load
                highestLoadingSwitch = i; %update the switch to be migrated
            end
        end
    %     maxPackets
    %     highestLoadingSwitch
        nextMinDist = 1000; %a variable to store the latency of the switch to the new controller to which it will be connected
        nextMinIndex = 0; %a variable to store the index of the new controller to which the switch will be connected
        for j = 1 : noc %for each controller
            if (j ~= modifyIndex && sp(j,highestLoadingSwitch) < nextMinDist) %if the controller is not overloaded and the distance from the switch to jth controller is less than the minimum distance
                nextMinIndex = j; %update the index of the new controller
                nextMinDist = sp(j,highestLoadingSwitch); %update the new latency
            end
        end
    %     nextMinIndex
    %     nextMinDist
        newLoad = controllerLoad(1,nextMinIndex)+(nextMinDist*packets(highestLoadingSwitch)); %stores the load of the new controller after migration
        if (newLoad < (alpha*cap)) %if the new load is not exceeding the capacity
            %update the connections
            fprintf ('Case-1');
            newConnections (1:noc,highestLoadingSwitch) = zeros (noc,1);
            newConnections (nextMinIndex,highestLoadingSwitch) = sp (nextMinIndex,highestLoadingSwitch);
            %update the loads
            newLoads (1,modifyIndex) = newLoads (1,modifyIndex) - (sp(modifyIndex,highestLoadingSwitch)*packets(highestLoadingSwitch));
            newLoads (1,nextMinIndex) = newLoads(1,nextMinIndex) + (nextMinDist*packets(highestLoadingSwitch));
            if (newLoads(1,modifyIndex) < (alpha*cap)) %if the overloaded controller is released
                newLoads(2,modifyIndex) = 1; %update its status to balanced
            end
            balance = 1; %do the migration
    %         newConnections
    %         newLoads
        else %if the new load is exceeding the capacity
            %case-2 - The switch which can be relocated easily i.e. having least latency to nearest controller is to be relocated
            nextMinDist = 1000; %a variable to store the latency of the switch to the new controller which is minimum
            nextMinIndex = 0; %a variable to store the index of the new controller
            migrateSwitch = 0; %a variable to store the index of the switch to be migrated
            for i = 1 : noc %for each controller
                for j = 1 : n %for each node
                    if(i ~= modifyIndex && connections(modifyIndex,j) ~= 0) %if ith controller is not the overloaded controller and jth switch is connected to the overloaded controller
                        if (sp(i,j) < nextMinDist) %if latency of jth switch to ith controller is less than the minimum latency
                            nextMinDist = sp(i,j); %update the minimum latency
                            nextMinIndex = i; %update the index of the new controller
                            migrateSwitch = j; %update the switch to be migrated
                        end
                    end
                end
            end
    %         nextMinDist
    %         nextMinIndex
    %         migrateSwitch
            newLoad = controllerLoad(1,nextMinIndex)+(nextMinDist*packets(migrateSwitch)); %stores the load of the new controller after migration
            if (newLoad < (alpha*cap)) %if the new load is not exceeding the capacity
                %update the connections
                fprintf ('Case-2');
                newConnections (1:noc,migrateSwitch) = zeros (noc,1);
                newConnections (nextMinIndex,migrateSwitch) = sp (nextMinIndex,migrateSwitch);
                %update the loads
                newLoads (1,modifyIndex) = newLoads (1,modifyIndex) - (sp(modifyIndex,migrateSwitch)*packets(migrateSwitch));
                newLoads (1,nextMinIndex) = newLoads(1,nextMinIndex) + (nextMinDist*packets(migrateSwitch));
                if (newLoads(1,modifyIndex) < (alpha*cap)) %if the overloaded controller is released
                    newLoads(2,modifyIndex) = 1; %update its status to balanced
                end
                balance = 1; %do the migration
    %             newConnections
    %             newLoads
            else %if the new load is exceeding the capacity
                %case-3 - Find out the controller with least load and migrate the switch
                fprintf ('Case-3');
                nextMinIndex = 1; %a variable to store the index of the new controller
                migrateSwitch = 0; %a variable to store the switch to be migrated
                for i = 2 : noc %for each controller
                    if (controllerLoad(1,i) < controllerLoad(1,nextMinIndex)) %if the load of ith controller is less than that of the minimum one
                        nextMinIndex = i; %update the minimum load controller
                    end
                end
                nextMinDist = 1000; %a variable to store the latency of the migrating switch to the new controller
                for i = 1 : n %for each node
                    if (connections(modifyIndex,i) ~= 0) %if the ith switch is connected to the overloaded controller
                        if (sp(nextMinIndex,i) < nextMinDist) %if the latency of ith switch to the new controller is less than the minimum latency
                            nextMinDist = sp(nextMinIndex,i); %update the minimum latency
                            migrateSwitch = i; %update the switch to be migrated
                        end
                    end
                end
    %             nextMinIndex
    %             nextMinDist
    %             migrateSwitch
                %update the connections
                newConnections (1:noc,migrateSwitch) = zeros (noc,1);
                newConnections (nextMinIndex,migrateSwitch) = sp (nextMinIndex,migrateSwitch);
                %update the loads
                newLoads (1,modifyIndex) = newLoads (1,modifyIndex) - (sp(modifyIndex,migrateSwitch)*packets(migrateSwitch));
                newLoads (1,nextMinIndex) = newLoads(1,nextMinIndex) + (nextMinDist*packets(migrateSwitch));
                if (newLoads(1,modifyIndex) < (alpha*cap)) %if the overloaded controller is released
                    newLoads(2,modifyIndex) = 1; %update its status to balanced
                end
                balance = 1; %do the migration
    %             newConnections
    %             newLoads
            end
        end
% 
%         %closing the controller which is not connected to any of the switches
%         check = 0; %an indicator to keep track of the idle controllers
%         newNoc = 0; %a variable to store the actual number of controllers
%         for i = 1 : noc %for each controller
%             if (newLoads(1,i) == 0) %if the load is zero
%                 check = 1; %update check variable to 1
%                 break; %break the for loop
%             end
%         end
%         newControllers = zeros (2,1); %to store the actual controllers
%         if (check ~= 0) %if the indicator is updated i.e. at least one controller is idle
%             index = 1; %initialize index to 1
%             for i = 1 : noc %for each controller
%                 if (newLoads(1,i) == 0) %if it is idle
%                     minLat = sp (1,controllerList(i)); %a variable to store the nearest working controller
%                     minIn = 1; %to store the index of the nearest controller
%                     for j = 2 : noc %for each controller
%                         if ((sp(j,controllerList(i)) < minLat) && (newLoads(1,j) ~= 0)) %if the latency to the jth controller is less than the minimum one and jth controller is not idle
%                             minLat = sp(j,controllerList(i)); %update the minimum latency
%                             minIn = j; %update the index of the new controller
%                         end
%                     end
%                     newConnections(minIn,controllerList(i)) = minLat; %connect the idle controller to a working controller and close its controlling software
%                 else %if the controller is not idle
%                     newControllers(1:2,index) = newLoads(1:2,i); %keep it unchanged
%                     index = index + 1; %increment the index
%                     newNoc = newNoc + 1; %increment the actual number of controllers
%                 end
%             end
%             newLoads = newControllers;
%             noc = newNoc;
%         end
%         elseif (controllerLoad(1,modifyIndex) == 0) %the controller is idle
%             %closing the controller which is not connected to any of the switches
%         check = 0; %an indicator to keep track of the idle controllers
%         newNoc = 0; %a variable to store the actual number of controllers
%         for i = 1 : noc %for each controller
%             if (newLoads(1,i) == 0) %if the load is zero
%                 check = 1; %update check variable to 1
%                 break; %break the for loop
%             end
%         end
%         newControllers = zeros (2,1); %to store the actual controllers
%         if (check ~= 0) %if the indicator is updated i.e. at least one controller is idle
%             index = 1; %initialize index to 1
%             for i = 1 : noc %for each controller
%                 if (newLoads(1,i) == 0) %if it is idle
%                     minLat = sp (1,controllerList(i)); %a variable to store the nearest working controller
%                     minIn = 1; %to store the index of the nearest controller
%                     for j = 2 : noc %for each controller
%                         if ((sp(j,controllerList(i)) < minLat) && (newLoads(1,j) ~= 0)) %if the latency to the jth controller is less than the minimum one and jth controller is not idle
%                             minLat = sp(j,controllerList(i)); %update the minimum latency
%                             minIn = j; %update the index of the new controller
%                         end
%                     end
%                     newConnections(minIn,controllerList(i)) = minLat; %connect the idle controller to a working controller and close its controlling software
%                 else %if the controller is not idle
%                     newControllers(1:2,index) = newLoads(1:2,i); %keep it unchanged
%                     index = index + 1; %increment the index
%                     newNoc = newNoc + 1; %increment the actual number of controllers
%                 end
%             end
%             newLoads = newControllers;
%             noc = newNoc;
%         end
%     end
end
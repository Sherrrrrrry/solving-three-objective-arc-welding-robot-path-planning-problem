clc;
close all
clear all
global para
num_of_runs = 1;
dim = 3;
para = 1.2;
random_world = 0;
segmentLength = 20;
radius = 10;%%% 可修改，小的话路径崎岖，大的话会穿过障碍物
samples = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = [];
avg_path = [];
min_path = inf;
min_time = inf;
max_time = 0;
max_path = 0;
n_its = 0;
map = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% create random world
Size = 100;
switch map
    case 1
        [world,start_node,end_node] = map1(ones(1,dim)*Size,[0,0,0]);
    case 2
        [world,start_node,end_node] = map2(ones(1,dim)*Size,[0,0,0]);
    case 3
        [world,start_node,end_node] = map3(ones(1,dim)*Size,[0,0,0]);
    case 4
        [world,start_node,end_node] = map4(ones(1,dim)*Size,[0,0,0]);
end
%      plotWorld(world,[1,1,1],dim,1,1);
 for i = 1:num_of_runs
     tree = start_node;
     a = clock;
     % check to see if start_node connects directly to end_node
     if ( (norm(start_node(1:dim)-end_node(1:dim))<segmentLength )...
             &&(collision(start_node,end_node,world, 1, dim)==0) )
         tree = [start_node; end_node];
         else
         if samples >0
             its = 0;
             numPaths = 0;
             flag = 0;
             for j = 1:samples
                 [tree,flag] = extendTree(tree,end_node,segmentLength,radius,world,flag,dim);
                 numPaths = numPaths + flag;
                 its = its+1;
             end
             
         else
             its = 0;
             numPaths = 0;
             flag = 0;
             while numPaths < 1
                 [tree,flag] = extendTree(tree,end_node,segmentLength,radius,world,flag,dim);
                 numPaths = numPaths + flag;
                 its = its+1;
%                  plotExpandedTree(world,tree,dim);
%                  plotWorld(world,tree,dim,1,1);
%                  pause(0.05)
             end
         end
     end
     % find path with minimum cost to end_node
     path = findMinimumPath(tree,end_node,dim);
     path = second_opt(path,dim,world,segmentLength);
     b = clock;
     run_time = 3600*(b(4)-a(4)) + 60 * (b(5)-a(5)) + (b(6) - a(6));
     
     
     sizePath = size(path,1);
     pathlength = 0;
     pp = path(:,1:3);
     for m = 2: sizePath
         pathlength = pathlength + pdist2(pp(m,:),pp(m-1,:));
     end
     
     time = [time; run_time];
     avg_path = [avg_path; pathlength];
     n_its = [n_its; its];
     if run_time <= min_time
         min_time = run_time;
     end
     if pathlength <= min_path
         min_path = pathlength;
         PATH = path;
     end
     if run_time >= max_time
         max_time = run_time;
     end
     if pathlength >= max_path
         max_path = pathlength;
     end
     % 画图
     figure;
     plotExpandedTree(world,tree,dim);
     plotWorld(world,path,dim,pathlength,run_time); 
     path_planning.name(i) = map;
     path_planning.pathlength(i) = pathlength;
     path_planning.path{i} = path;
     path_planning.time(i) = run_time;
     path_planning.iteration(i) = its;
 end
% 
%  str1 = ['The time taken by RRT-Star for ', num2str(num_of_runs), ' runs is ', num2str(sum(time))];
%  str2 = ['The averagae time taken by RRT_Star for each run is ', num2str(mean(time)),'(', num2str(var(time)), ')' ];
%  str3 = ['The min time and max taken by RRT_Star for each run are ', num2str(min_time),' and ',num2str(max_time)];
%  str4 = ['The average Path length for RRT-Star is ', num2str(mean(avg_path)),'(', num2str(var((avg_path))), ')'];
%  str5 = ['The min & max Path length for RRT-Star are ', num2str(min_path),' and ',num2str(max_path)];
%  str6 = ['The mean iterations for RRT-Star is ', num2str(sum(n_its)/num_of_runs)];
%  disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%  disp(str1);
%  disp(str2);
%  disp(str3);
%  disp(str4);
%  disp(str5);
%  disp(str6);
%  disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%  save(['Map', num2str(map), '.mat'], 'path_planning');
clc;
close all
clear all
num_of_runs = 30;
dim = 3;
random_world = 0;
segmentLength = 10;
radius = 10;%%% ���޸ģ�С�Ļ�·����᫣���Ļ��ᴩ���ϰ���
samples = 1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = [];
avg_path = [];
min_path = inf;
min_time = inf;
max_time = 0;
max_path = 0;
n_its = 0;
map = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
 for i = 1:num_of_runs
     % establish tree starting with the start node
     tree = start_node;
     tree1 = start_node;
     tree2 = end_node;
     a = clock;
     R = 1;
     % check to see if start_node connects directly to end_node
     if ( (norm(start_node(1:dim)-end_node(1:dim))<segmentLength )...
             &&(collision(start_node,end_node,world, R, dim)==0) )
         tree = [start_node; end_node];
         else
         if samples >0
             its = 0;
             numPaths = 0;
             flag = 0;
             for j = 1:samples
                 % tree1��չ
                 [tree1,tree2,flag] = extendTree(tree1,tree2,end_node,segmentLength,radius,world,flag,dim);
                 numPaths = numPaths + flag; % ֱ�����һ���ڵ����յ�������flag = 1����ʾ�ҵ�ȫ��·��
                 its = its+1; % tree��ÿ����һ���ڵ�,its �Լ�1
                 if j == 250
%                  if(numPaths) % ��numPathsΪ1����ʾ��Ѱ�ҵ�ȫ��·�������������м�ڵ��Ѿ������ϣ���������ѭ��
                     path1 = findMinimumPath(tree1,tree1(end,:),dim); % ���������յ㷴��·��������ṹ
                     path1(end,:) = []; % path1���һ�����ظ��ˣ���Ҫɾ��
                     path2 = findMinimumPath(tree2,tree2(end,:),dim);
                     path2(end,:) = [];
                     for i=size(path2,1):-1:1
                         path1 = [path1;path2(i,:)];
                         path = path1; % dim+1ά������1������tree1��tree2���ӵ�������
                     end
                     break;
                 end
                 % tree2��չ
                 [tree2,tree1,flag] = extendTree(tree2,tree1,start_node,segmentLength,radius,world,flag,dim);
                 numPaths = numPaths + flag; % ֱ�����һ���ڵ����յ�������flag = 1����ʾ�ҵ�ȫ��·��
                 its = its+1; % tree��ÿ����һ���ڵ�,its �Լ�1
                 if j == 250
%                  if(numPaths)
                     path1 = findMinimumPath(tree1,tree1(end,:),dim);
                     path1(end,:) = []; % path1���һ�����ظ��ˣ���Ҫɾ��
                     path2 = findMinimumPath(tree2,tree2(end,:),dim);
                     path2(end,:) = [];
                     for i=size(path2,1):-1:1
                         path1 = [path1;path2(i,:)];
                         path = path1;
                     end
                     break;
                 end
             end
             
         else
             its = 0;
             numPaths = 0;
             flag = 0;
             while numPaths < 1
                  % tree1��չ
                 [tree1,tree2,flag] = extendTree(tree1,tree2,end_node,segmentLength,radius,world,flag,dim);
                 numPaths = numPaths + flag; % ֱ�����һ���ڵ����յ�������flag = 1����ʾ�ҵ�ȫ��·��
                 its = its+1; % tree��ÿ����һ���ڵ�,its �Լ�1
                 if(numPaths) % ��numPathsΪ1����ʾ��Ѱ�ҵ�ȫ��·�������������м�ڵ��Ѿ������ϣ���������ѭ��
                     path1 = findMinimumPath(tree1,tree1(end,:),dim); % ���������յ㷴��·��������ṹ
                     path1(end,:) = []; % path1���һ�����ظ��ˣ���Ҫɾ��
                     path2 = findMinimumPath(tree2,tree2(end,:),dim);
                     path2(end,:) = [];
                     for i=size(path2,1):-1:1
                         path1 = [path1;path2(i,:)];
                         path = path1; % dim+1ά������1������tree1��tree2���ӵ�������
                     end
                     break;
                 end
                 % tree2��չ
                 [tree2,tree1,flag] = extendTree(tree2,tree1,start_node,segmentLength,radius,world,flag,dim);
                 numPaths = numPaths + flag; % ֱ�����һ���ڵ����յ�������flag = 1����ʾ�ҵ�ȫ��·��
                 its = its+1; % tree��ÿ����һ���ڵ�,its �Լ�1
                 if(numPaths)
                     path1 = findMinimumPath(tree1,tree1(end,:),dim);
                     path1(end,:) = []; % path1���һ�����ظ��ˣ���Ҫɾ��
                     path2 = findMinimumPath(tree2,tree2(end,:),dim);
                     path2(end,:) = [];
                     for i=size(path2,1):-1:1
                         path1 = [path1;path2(i,:)];
                         path = path1;
                     end
                     break;
                 end
             end
         end
     end
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
     end
     if run_time >= max_time
         max_time = run_time;
     end
     if pathlength >= max_path
         max_path = pathlength;
     end
     % ��ͼ
     figure;
     plotExpandedTree(world,tree,dim);
     plotWorld(world,path,dim,pathlength,run_time);
     path_planning.name(i) = map;
     path_planning.pathlength(i) = pathlength;
     path_planning.path{i} = path;
     path_planning.time(i) = run_time;
     path_planning.iteration(i) = its;
 end
 str1 = ['The time taken by RRT-Star for ', num2str(num_of_runs), ' runs is ', num2str(sum(time))];
 str2 = ['The averagae time taken by RRT_Star for each run is ', num2str(mean(time)),'(', num2str(var(time)), ')' ];
 str3 = ['The min time and max taken by RRT_Star for each run are ', num2str(min_time),' and ',num2str(max_time)];
 str4 = ['The average Path length for RRT-Star is ', num2str(mean(avg_path)),'(', num2str(var((avg_path))), ')'];
 str5 = ['The min & max Path length for RRT-Star are ', num2str(min_path),' and ',num2str(max_path)];
 str6 = ['The mean iterations for RRT-Star is ', num2str(sum(n_its)/num_of_runs)];
 disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
 disp(str1);
 disp(str2);
 disp(str3);
 disp(str4);
 disp(str5);
 disp(str6);
 disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
 save(['Map', num2str(map), '_1000.mat'], 'path_planning'); 
% ES-RRT*寻找前副车架的避障路径---正在编辑
clear
clc;
close all;
%% 加载数据
load('weldpoint_adjust.mat') % 焊缝端点数据
load('G_ob_simply.mat'); % 全部的栅格（基准点坐标+各边长）
GP = 5; % 栅格大小为5
rob = createRobot(); % 创建机器人
cylinderRadius = 0; % cylinderRadius = [150 80 80 100 80 80]; % 用圆柱体将机械臂包围，cylinderRadius为各圆柱体的半径

%% 画图
% for i=1:size(G_ob_simply,1) % 显示AABB盒子(灰色)
%     patch(obsgen(G_ob_simply(i,:))); % obsgen()为包围盒函数，obs的大小为N*6，前三维为最近点的坐标，后三维为包围盒三边的长度
%     hold on;
% end
% label = {'1','2','3','4','5','6','7','8','9','10',... %焊点标号
%     '11','12','13','14','15','16','17','18','19','20',...
%     '21','22','23','24','25','26','27','28','29','30'};
% for i = 1:size(weldpoint_adjust_adjust,1) % 显示所有焊点（黄色）
%     hold on
%     scatter3(weldpoint_adjust_adjust(i,1),weldpoint_adjust_adjust(i,2),weldpoint_adjust_adjust(i,3),30,[0 1 0],'filled');%其中[1 0 0]和[0 1 0]分别表示三原色中的红色（起始点）和绿色（终止点），三原色由0和1组成的3*1矩阵表示，共8种
% %     text(weldpoint_adjust_adjust(i,1),weldpoint_adjust_adjust(i,2)+5,weldpoint_adjust_adjust(i,3),label{i});
% end
% 画出工件的图（黄色）
Path = './';                   % 设置数据存放的文件夹路径
File = dir(fullfile(Path,'*.stl'));  % 显示文件夹下所有符合后缀名为.txt文件的完整信息
FileNames = {File.name}';            % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列
hold on;
fv = stlread(FileNames{5}); % 读取stl文件，以三角形覆盖表面，得到三角形面faces和三角形顶点vertices数据
mean_dif = [1566.88081496667,1198.42971853333,-20.9673186333333];
fv.vertices = [-fv.vertices(:,1)+mean_dif(1,1).*ones(size(fv.vertices,1),1) -fv.vertices(:,2)+mean_dif(1,2).*ones(size(fv.vertices,1),1) fv.vertices(:,3)+mean_dif(1,3).*ones(size(fv.vertices,1),1)];
patch(fv,'FaceColor','y','EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15);

%% 验证所有焊点末端位置以及关节是否碰撞，如果碰撞可以考虑调整响应工装夹具、栅格化工件的基准点坐标以及微调焊点的坐标
for i = 1:size(weldpoint_adjust,1)
    xGoal = weldpoint_adjust(i,:); %目标位置
    qGoal = rob.ikine(transl(xGoal),zeros(1,6),[1,1,1,0,0,0]);%根据位置信息迭代求逆解（关节角度）
    collision_end = endCollison(G_ob_simply,xGoal); %末端碰撞检测 1：碰撞 0：无碰撞
    if (collision_end)
        j = i
    end
    % 检查焊点是否可达
    collision_arm = armCollison(rob, qGoal, G_ob_simply, cylinderRadius);
    if (collision_arm)
        i
    end
end

Path = {};
for N = 1:30 %计算30次结果并保存，路径长度+运行时间
    N
    for start = 9
        for goal = 13
%             start
%             goal
            if ((start==goal)||(start==1&&goal==2)||(start==3&&goal==4)||(start==5&&goal==6)||(start==7&&goal==8)||(start==9&&goal==10)||(start==11&&goal==12)||(start==13&&goal==14)...
                    ||(start==15&&goal==16)||(start==17&&goal==18)||(start==19&&goal==20)||(start==21&&goal==22)||(start==23&&goal==24)||(start==25&&goal==26)||(start==27&&goal==28)||(start==29&&goal==30)...
                    ||(start==2&&goal==1)||(start==4&&goal==3)||(start==6&&goal==5)||(start==8&&goal==7)||(start==10&&goal==9)||(start==12&&goal==11)||(start==14&&goal==13)||(start==16&&goal==15)...
                    ||(start==18&&goal==17)||(start==20&&goal==19)||(start==22&&goal==21)||(start==24&&goal==23)||(start==26&&goal==25)||(start==28&&goal==27)||(start==30&&goal==29))
                continue;
            end
                        filename = strcat('30run2_',num2str(start),'_',num2str(goal),'.mat');
%             filename = strcat(num2str(start),'_',num2str(goal),'.mat');
            tic; %开始计时
            % 参数设置
            dim = 3; %3D
            radius = 40; %更新节点时选择的圆形范围半径
            segmentLength = 20; %扩展步长（同stepsize）
            origincorner = [0 -1600 -200]; %人为设置Space边界
            endcorner = [2000 2000 1000];
            
            % 验证所有焊点的末端位置以及各关节是否碰撞，如果碰撞可以调整相应工装夹具、栅格化工件的基准点坐标以及微调焊点的坐标
            for i = 1:size(weldpoint_adjust,1)
                xGoal = weldpoint_adjust(i,:); %目标位置
                qGoal = rob.ikine(transl(xGoal),zeros(1,6),[1,1,1,0,0,0]); %根据位置信息迭代求逆解（关节角度）
                collision_end = endCollison(G_ob_simply,xGoal); %末端碰撞检测 1：碰撞 0：无碰撞
                if (collision_end)
                    j = i
                end
                % 检查焊点是否可达
                collision_arm = armCollison(rob, qGoal, G_ob_simply, cylinderRadius);
                if (collision_arm)
                    i
                end
            end
            
            start_cord = weldpoint_adjust(start,:);  %起始点，红色
            goal_cord = weldpoint_adjust(goal,:);  %终止点，绿色
            start_node = [start_cord,0,0,0]; %第dim+1为1表示该点距离终点最近，dim+2存放该店到起始点的最短路径总长度，dim+3存放其父节点的索引号
            end_node = [goal_cord,0,0,0];
            
            counter = 0;
            hold on;
            scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[1 0 0], 'filled');
            scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[0 1 0], 'filled');
            kk=0;
            %% 开始扩展
            % 判断起始点和终止点是否能够直接连接，norm（）计算欧氏距离，pathCollision()输出为0表示无碰撞，1表示有碰撞
            if ~pathCollision(start_node,end_node,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim)
                path = [start_node; end_node];
                tree = path;
                its = 0;
            else
                its = 0;
                numPaths = 0;
                flag = 0;
                tree = start_node;
                while numPaths < 1
                    % tree扩展
                    [tree,flag] = extendTree(tree,end_node,segmentLength,radius,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,flag,dim);
                    numPaths = numPaths + flag; %直到最后一个节点与终点相连， flag=1，表示找到全部路径
                    its = its + 1;
                    if (numPaths)
                        path = findMinimumPath(tree,end_node,dim);
                        %                         path(end,:) = [];
                        break;
                    end
%                     t = toc;
%                     if toc > 1800
%                         kk =1;
%                         break;
%                     end
                end
            end
            if kk <1
                % 二次优化
                path = second_opt(path,dim,segmentLength,rob,G_ob_simply,origincorner,endcorner,cylinderRadius);
                
                pathLength1 = 0;
                for i = 1:size(path,1)-1
                    pathLength1 = pathLength1 + norm(path(i,1:3)-path(i+1,1:3));
                end
                
                %计时结束
                            t = toc;
%                 Path{N} = path;
                Path.Path{N} = path;
                Path.save_pathLength1(N,:) = pathLength1;
                Path.save_time(N,:) = t;
                Path.save_its(N,:) = its;
                save(filename, 'Path');
            else
                continue;
            end
        end
    end
end

mean_pathLength1 = mean(save_pathLength1);
var_pathLength1 = var(save_pathLength1);
[min_pathLength1,min_pathIndex] = min(save_pathLength1);
min_path = Path{min_pathIndex};
max_pathLength1 = max(save_pathLength1);
mean_time = mean(save_time);
mean_its = mean(save_its);
fprintf('mean_pathLength1=%d \nvar_pathLength1=%d  \nmin_pathLength1=%d \nmax_pathLength1=%d \nmean_time=%d  \nmean_tis =%d  \n\n', mean_pathLength1 ,var_pathLength1, min_pathLength1 ,max_pathLength1 ,mean_time,mean_its);
% 
% %  画图：最好的路线图
% hold on
% scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[1 0 0],'filled');%scatter(横坐标，纵坐标，圆的大小，颜色，'filled'表示实心圆)用来画二维的散点图
% scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[0 1 0],'filled');%其中[1 0 0]和[0 1 0]分别表示三原色中的红色（起始点）和绿色（终止点），三原色由0和1组成的3*1矩阵表示，共8种
% hold on
% X = min_path(:,1);
% Y = min_path(:,2);
% Z = min_path(:,3);
% p = plot3(X,Y,Z);
% set(p,'Color',[1 0 1],'LineWidth',2);
            
            
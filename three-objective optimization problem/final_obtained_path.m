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
patch(fv,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15);

weld = [9 5 10 11 4 3 2 1 15 14 8 13 12 7 6];
joint = [ 18 9; 10 19; 20 21; 22 7; 8 5; 6 4; 3 2; 1 30; 29 28; 27 15; 16 25; 26 23; 24 14; 13 12; 11 17];
path_whole =[];
for i = 1:15
    start = joint(i,1);
    goal = joint(i,2);
    filename = strcat(num2str(start),'_',num2str(goal),'.mat');
    load(filename);
    path = cell2mat(Path);
%     path(end,:)=[];
    path_whole = [path_whole;path];
end
path_whole = path_whole(:,1:3);
point = intersect(path_whole,weldpoint_adjust,'rows');
hold on
scatter3(path_whole(:,1),path_whole(:,2),path_whole(:,3),30,[1 1 0], 'filled');
hold on
scatter3(weldpoint_adjust(joint(:,1),1),weldpoint_adjust(joint(:,1),2),weldpoint_adjust(joint(:,1),3),30,[1 0 0], 'filled'); % Ending point红色
scatter3(weldpoint_adjust(joint(:,2),1),weldpoint_adjust(joint(:,2),2),weldpoint_adjust(joint(:,2),3),30,[0 1 0], 'filled'); % Starting point绿色
% scatter3(point(:,1),point(:,2),point(:,3),30,[0 1 0], 'filled');
hold on
X = path_whole(:,1);
Y = path_whole(:,2);
Z = path_whole(:,3);
p = plot3(X,Y,Z,'--');
set(p,'Color',[0.82 0.41 0.12],'LineWidth',2);%黄色过渡点
hold on
spot = [1,2;3,4;5,6;7,8;9,10;11,12;13,14;15,16;17,18;19,20;21,22;23,24;25,26;27,28;29,30];
for i = 1:15
    line = [weldpoint_adjust(spot(i,1),:);weldpoint_adjust(spot(i,2),:)];
    q = plot3(line(:,1),line(:,2),line(:,3));
    set(q,'Color',[0 0 0],'LineWidth',2);
    hold on
end
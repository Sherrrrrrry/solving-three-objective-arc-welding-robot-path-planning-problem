%% 运行30次9-13
% load('30run2_9_13.mat');
% path = Path.Path;
% length = Path.save_pathLength1;
% time = Path.save_time;
% its = Path.save_its;

% load('22_12.mat');%30run_12_22

% for j = 1:30 
%     path = cell2mat(Path(j));
%     pathLength1(j) = 0;
%     for i = 1:size(path,1)-1
%         pathLength1(j) = pathLength1(j) + norm(path(i,1:3)-path(i+1,1:3));
%     end
% end
%    [~,k]=sort(pathLength1);             
% path = cell2mat(Path(1));
% Path.Path = [Path.Path,path];
% Path.save_pathLength1 = [Path.save_pathLength1;length];
% Path.save_time = [Path.save_time;time];
% Path.save_its = [Path.save_its;its];
% save('30run1_9_13.mat','Path');


%% 起始点翻转路径
% load('1_13.mat');
% % path = flipud(cell2mat(Path.Path));
% path = flipud(cell2mat(Path));
% % Path = [];
% Path{1} = path;
% save( '13_1.mat', 'Path');


% mean_pathLength1 = mean(Path.save_pathLength1);
% var_pathLength1 = var(Path.save_pathLength1);
% [min_pathLength1,min_pathIndex] = min(Path.save_pathLength1);
% min_path = Path.Path{min_pathIndex};
% max_pathLength1 = max(Path.save_pathLength1);
% mean_time = mean(Path.save_time);
% mean_its = mean(Path.save_its);
% fprintf('mean_pathLength1=%d \nvar_pathLength1=%d  \nmin_pathLength1=%d \nmax_pathLength1=%d \nmean_time=%d  \nmean_tis =%d  \n\n', mean_pathLength1 ,var_pathLength1, min_pathLength1 ,max_pathLength1 ,mean_time,mean_its);


% 画出工件的图（黄色）
% Path = './';                   % 设置数据存放的文件夹路径
% File = dir(fullfile(Path,'*.stl'));  % 显示文件夹下所有符合后缀名为.txt文件的完整信息
% FileNames = {File.name}';            % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列
% hold on;
% fv = stlread(FileNames{5}); % 读取stl文件，以三角形覆盖表面，得到三角形面faces和三角形顶点vertices数据
% mean_dif = [1566.88081496667,1198.42971853333,-20.9673186333333];
% fv.vertices = [-fv.vertices(:,1)+mean_dif(1,1).*ones(size(fv.vertices,1),1) -fv.vertices(:,2)+mean_dif(1,2).*ones(size(fv.vertices,1),1) fv.vertices(:,3)+mean_dif(1,3).*ones(size(fv.vertices,1),1)];
% patch(fv,'FaceColor','y','EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15);
% hold on;
% % start_cord = weldpoint_adjust(start,:);  %起始点，红色
% % goal_cord = weldpoint_adjust(goal,:);  %终止点，绿色
% start_cord = path(1,1:3);
% goal_cord = path(end,1:3);
% start_node = [start_cord,0,0,0]; %第dim+1为1表示该点距离终点最近，dim+2存放该店到起始点的最短路径总长度，dim+3存放其父节点的索引号
% end_node = [goal_cord,0,0,0];
% scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[0 1 0], 'filled');
% scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[1 0 0], 'filled');
% hold on
% scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[1 0 0],'filled');%scatter(横坐标，纵坐标，圆的大小，颜色，'filled'表示实心圆)用来画二维的散点图
% scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[0 1 0],'filled');%其中[1 0 0]和[0 1 0]分别表示三原色中的红色（起始点）和绿色（终止点），三原色由0和1组成的3*1矩阵表示，共8种
% hold on
% X = path(:,1);
% Y = path(:,2);
% Z = path(:,3);
% p = plot3(X,Y,Z);
% set(p,'Color',[1 0 1],'LineWidth',2);

load('2_26.mat');
Path = Path.Path;
% Path =[];
% Path = path;
save( '2_26.mat', 'Path');


% ? Rahul Kala, IIIT Allahabad, Creative Commons Attribution-ShareAlike 4.0 International License. 
% The use of this code, its parts and all the materials in the text; creation of derivatives and their publication; and sharing the code publically is permitted without permission. 

% Please cite the work in all materials as: R. Kala (2014) Code for Robot Path Planning using Rapidly-exploring Random Trees, Indian Institute of Information Technology Allahabad, Available at: http://rkala.in/codes.html

% 原来是RRT，现在将其修改为 bi-RRT*
% 参考论文：
% 《Intelligent bidirectional rapidly-exploring random trees for optimal
% motion planning in complex cluttered environments》
% Algrithm 5: bi-RRT*
% 作者:钟 杰
% 2019/9/8

clear;
close all;
for N = 1:31 % 计算30次结果（去掉首次）并保存：路径长度+运行时间
tic;
%% set parameters
% map=imbinarize(imread('map1.bmp')); %和下一语句作用一样
map=im2bw(imread('map8.bmp')); % imread(filename.fmt)读取文件名为filename,格式为fmt的图像数据，输出为图像的像素矩阵（如500*500）
                               % im2bw()将图像转变成二进制图像,因此只有黑白两色，0为黑色区域，即障碍物区域，1为白色区域，即自由空间
                               % map为500*500且由0、1组成的逻辑矩阵
source=[10 10]; % 起始坐标点，对应的分别是y轴和x轴，也就是纵轴和横轴
goal=[490 490]; % 终止坐标点
stepsize=20; % 步长，起始点和终止点横、纵坐标之差应为步长的倍数，这样才能正常连接起始点和终止点（这是实验的经验）
disTh=stepsize; % 最终的路径不一定刚好将起始点和终止点连接起来，因此只要终止点与其最近的节点之间的距离小于disTH这个阀值，就认为找到了最短路径，
                % 当然最好的情况是起始点和终止点刚好能连接起来，这与设置的步长大小有关
maxFailedAttempts = 100000;
display=true; % display of RRTree 

if ~feasiblePoint(source,map), error('source lies on an obstacle or outside map'); end
if ~feasiblePoint(goal,map), error('goal lies on an obstacle or outside map'); end
% if display, 
%     imshow(map);
%     rectangle('position',[1 1 size(map)-1],'edgecolor','k'); 
% end
RRTree1=double([source -1]); % First RRT rooted at the source, representation node and parent index
RRTree2=double([goal -1]); % Second RRT rooted at the goal, representation node and parent index
counter=0;
% hold on;
tree1ExpansionFail=false; % sets to true if expansion after set number of attempts fails
tree2ExpansionFail=false; % sets to true if expansion after set number of attempts fails
% scatter(10,10,50,[1 0 0],'filled');%scatter(横坐标，纵坐标，圆的大小，颜色，'filled'表示实心圆)用来画二维的散点图
% scatter(490,490,50,[0 1 0],'filled');%其中[1 0 0]和[0 1 0]分别表示三原色中的红色（起始点）和绿色（终止点），三原色由0和1组成的3*1矩阵表示，共8种

%% 算法开始循环
while ~tree1ExpansionFail || ~tree2ExpansionFail  % loop to grow RRTs
    %% RRTree1和RRTree2先后进行扩展，即RRTree1先通过采样得到一个树节点，然后RRTree2通过另一个采样得到另一个树节点。
    if ~tree1ExpansionFail 
        [RRTree1,pathFound,tree1ExpansionFail]=rrt_starExtend(RRTree1,RRTree2,goal,stepsize,maxFailedAttempts,disTh,map); % RRT 1 expands from source towards goal
        % 显示RRTree1扩展的过程
%         if ~tree1ExpansionFail && isempty(pathFound) && display
%             line([RRTree1(end,2);RRTree1(RRTree1(end,3),2)],[RRTree1(end,1);RRTree1(RRTree1(end,3),1)],'color','b');
%             counter=counter+1;
%             M(counter)=getframe;
%         end
    end
    
    if ~tree2ExpansionFail
        [RRTree2,pathFound,tree2ExpansionFail]=rrt_starExtend(RRTree2,RRTree1,source,stepsize,maxFailedAttempts,disTh,map); % RRT 2 expands from goal towards source
        if ~isempty(pathFound)
            pathFound(3:4)=pathFound(4:-1:3); % 调换pathFound中连接RRTree1和RRTree2的中间节点的索引位置顺序，然后RRTree2的最后一个节点才能顺利连接上RRTree1，之后根据RRTree1找到最短路径。
        end % path found
        % 显示RRTree2扩展的过程
%         if ~tree2ExpansionFail && isempty(pathFound) && display
%             line([RRTree2(end,2);RRTree2(RRTree2(end,3),2)],[RRTree2(end,1);RRTree2(RRTree2(end,3),1)],'color','r');
%             counter=counter+1;
%             M(counter)=getframe;
%         end 
    end
    
    if ~isempty(pathFound) % path found
        path=[pathFound(1,1:2)]; % compute path
        prev=pathFound(1,3); % add nodes from RRT 1 first
        while prev>0
            path=[RRTree1(prev,1:2);path];
            prev=RRTree1(prev,3);
        end
        prev=pathFound(1,4); % then add nodes from RRT 2
        while prev>0
            path=[path;RRTree2(prev,1:2)];
            prev=RRTree2(prev,3);
        end
        break;
    end
end

if size(pathFound,1)<=0
    error('no path found. maximum attempts reached'); 
end

pathLength1=0;
for i=1:length(path)-1 % length()输出行数和列数的较大值，即节点的个数
    pathLength1=pathLength1+distanceCost(path(i,1:2),path(i+1,1:2)); 
end
t = toc;
save_pathLength1(N,:) = pathLength1;
save_time(N,:) = t;
end
save_pathLength1(1,:) = [];
save_time(1,:) = [];

mean_pathLength1 = mean(save_pathLength1);
min_pathLength1 = min(save_pathLength1);
max_pathLength1 = max(save_pathLength1);
mean_time = mean(save_time);
fprintf('mean_pathLength1=%d \nmin_pathLength1=%d \nmax_pathLength1=%d \nmean_time=%d  \n\n', mean_pathLength1 ,min_pathLength1 ,max_pathLength1 ,mean_time);

% fprintf('processing time=%d \nPath Length=%d \n',toc,pathLength); %显示用时和路径长度
% line(path(:,2),path(:,1),'LineWidth',2.5,'Color',[0 1 0]);
% hold on;
% counter=counter+1;
% M(counter)=getframe;
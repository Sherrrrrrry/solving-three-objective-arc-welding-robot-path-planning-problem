
function [RRTree1,pathFound,extendFail] = rrt_starExtend(RRTree1,RRTree2,goal,stepsize,maxFailedAttempts,disTh,map)
pathFound=[]; %if path found, returns new node connecting the two trees, index of the nodes in the two trees connected
failedAttempts=0;
while failedAttempts<=maxFailedAttempts % 开始循环
    %% 随机产生采样点
    if rand < 0.5 %rand表示产生0到1的一个随机数，rand(1,2)表示产生1*2的随机数矩阵
        sample=rand(1,2) .* size(map); % size(map)输出map的行数和列数，.*表示点乘，相同大小的矩阵元素对应相乘
    else 
        sample=goal;
    end
    %% 找到RRTree1上距离采样点最近的节点，并根据角度和步长求出新节点的位置坐标
    [~, I]=min(distanceCost(RRTree1(:,1:2),sample) ,[],1);
    %[A,I]=min(B,[],1])表示寻找矩阵B每一列的最小值及其对应的行数，返回行向量A和I，A向量记录矩阵B每列的最小值，I向量记录每列最小值行号
    x_nearest= RRTree1(I,1:2);
    theta=atan2(sample(1)-x_nearest(1),sample(2)-x_nearest(2));
    x_new = double(int32(x_nearest(1:2) + stepsize * [sin(theta)  cos(theta)]));
    %% 判断最近节点与新节点的连线是否无碰撞，是则继续，否则回到循环起点重新采样
    if ~checkPath(x_nearest(1:2), x_new, map) % if extension of closest node in tree to the new point is feasible
        failedAttempts=failedAttempts+1;
        continue;%遇到continue，终止本次循环，回到循环的起点（前面的while语句）重新产生随机点，开始进行第二次（下一次）循环
    end
    %% 将圆内与x_new距离小于r的树节点坐标信息储存到X_near中，从X_near中选出x_min作为x_new的父节点，并更新x_new的索引号，添加至RRTree中（即x_min在RRT中的行数号）
    X_near = NearestVertices(x_new,RRTree1); % X_near（里面包含与新节点x_new距离小于r的n个树节点的信息以及这些树节点在RRTree中的行数，大小为n*4），若没有，则 X_near = []
    if  size(X_near)==[0,0] % 若圆内不存在X_near，则找距离x_new最近的节点，并将该节点的数据以及在RRTree中的行数返回给X_near
        [~, I1]=min(distanceCost(RRTree1(:,1:2),x_new) ,[],1); 
        X_near = [RRTree1(I1,1:3),I1];
    end
    Ls = GetSortedList(x_new,X_near,RRTree1); % 按照RRTree--X_near--x_new的路径长度从小到大排序
                                              % 假设X_near中有n个树节点，则Ls的大小为（1,3,n），表示n行3列的数组，第1、2、3列分别储存坐标信息、路径长度、轨迹
    x_min = ChooseBestParent(Ls,map); % 找到X_near中与x_new之间的路径长度最短且连接轨迹与map无碰撞的树节点，并返回其坐标信息
                                      % x_min的坐标信息包括坐标、父节点索引行号以及自身在RRTree中的行号
    if ~size(x_min)==[0 0]
        RRTree1=[RRTree1;[x_new(1:2),x_min(4)]]; %在RRTree1中插入新的节点，x_min(4)是与x_new距离最短且无碰撞的父节点X_near在RRTree中的索引号
        %% 圆内其他树节点以x_new为父节点，并更新这些树节点的路径，得到新的RRTree
        RRTree1=RewireVertices(x_min,x_new,Ls,RRTree1,map);
    end
    %% 在RRTree2上寻找与RRTree1新节点距离最近的节点，若两个节点的距离小于阀值，则退出循环，表示已找到最短路径，否则将RRTree1的新节点加入RRTree1中
    [~, I2]=min(distanceCost(RRTree2(:,1:2),x_new) ,[],1);
    if distanceCost(RRTree2(I2(1),1:2),x_new)<disTh % if both trees are connected
        pathFound=[x_new I(1) I2(1)];
        extendFail=false;
        break; 
    end
    RRTree1=[RRTree1;x_new I(1)];% 将RRTree1的新节点加入RRTree1中
%     scatter(x_new(2),x_new(1),20,[1 0 1],'filled');%将新节点用带颜色的实心圆画出来，更加具体
                                                   %同时注意scatter与newpoint的横纵坐标位置刚好相反
    extendFail=false;break; % add node
end
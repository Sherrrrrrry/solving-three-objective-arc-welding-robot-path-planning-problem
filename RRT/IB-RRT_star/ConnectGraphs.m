
%% 输出RRT以及找到新节点x_new的父节点x_min并更新圆内其他树节点的路径后返回flag=1
function [flag,RRTree]=ConnectGraphs(RRTree,x1,x2,stepsize,map)
theta=atan2(x1(1)-x2(1),x1(2)-x2(2)); % 计算两个点的角度
x_new = double(int32(x2(1:2) + stepsize * [sin(theta)  cos(theta)])); % 得到新节点的坐标
X_near=NearestVertices(x_new,RRTree);  % X_near（里面包含与新节点x_new距离小于r的n个树节点的信息以及这些树节点在RRTree中的行数，大小为n*4），若没有，则 X_near = []
Ls = GetSortedList(x1,X_near,RRTree);  % 按照RRTree--X_near--x_new的路径长度从小到大排序
                                       % 假设X_near中有n个树节点，则Ls的大小为（1,3,n），表示n行3列的数组，第1、2、3列分别储存坐标信息、路径长度、轨迹
x_min = ChooseBestParent(Ls,map); % 找到X_near中与x_new之间的路径长度最短且连接轨迹与map无碰撞的树节点，并返回其坐标信息
                                  % x_min的坐标信息包括坐标、父节点索引行号以及自身在RRTree中的行号
traj=[];
flag=0;
if ~size(x_min)==[0 0]
    RRTree=[RRTree;[x1(1:2),x_min(4)]];
    RRTree=RewireVertices(x_min,x_new,Ls,RRTree,map); % 圆内其他树节点以x_new为父节点，并更新这些树节点的路径，得到新的RRTree
    flag=1;
end
end


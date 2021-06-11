% 输入：x_new,X_near,RRTree
% 输出：按照路径长度从小到大排序，假设X_near中有n个树节点，则Ls的大小为（1,3,n），表示n行3列的数组，第1、2、3列分别储存坐标信息、路径长度、轨迹
function Ls = GetSortedList(x_new,X_near,RRTree)
[n,~]=size(X_near);
Ls=cell(1,3,n); % 产生的数组大小为n*3*1，即n行3列，且每个数组里只有一个元素
step=2;
for i=1:n
    traj = Steer(X_near(i,1:2),x_new,step); % traj = [X_near(i,1:2);x_new]
    cost = Cost(RRTree,X_near(i,:))+distanceCost(x_new,X_near(i,1:2)); % RRTree-X_near-x_new的路径长度
    Ls{1,1,i} = X_near(i,:); % Ls中的第i行第1列储存：X_near(i,:)的坐标、父节点索引行号以及自身在RRTree中的行号所有信息，下同
    Ls{1,2,i} = cost; % 第i行第2列储存：RRTree-X_near-x_new的路径长度
    Ls{1,3,i} = traj; % 第i行第3列储存：traj = [X_near(i,1:2);x_new]，为2*2的矩阵
end
Ls=sortList(Ls);
end



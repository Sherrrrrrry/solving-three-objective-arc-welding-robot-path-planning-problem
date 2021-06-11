
% 输入：新节点x_new和RRTree的信息
% 输出：X_near（里面包含与新节点x_new距离小于r的n个树节点的信息以及这些树节点在RRTree中的行数，大小为n*4），若没有，则 X_near = []
function X_near = NearestVertices(x_new,RRTree)
% NearestVertices 
% 返回树RRTree中距离采样点距离r以内的点
% 记录其坐标，父节点，在树中的坐标行数。
[num,~]=size(RRTree); % 返回RRTree的行数，即num为RRTree中树节点的个数
gama =500;
r = gama*sqrt(log(num)/num); % 这里的log指的ln，r为圆的半径
dis = distanceCost(RRTree(:,1:2),x_new);
index = find(dis<=r); % 返回RRTree中与x_new之间的距离小于r的所有树节点在RRTree中的行数
[n,~] = size(index); % 计算距离小于r的树节点的个数
if n==0
    X_near=[];
else
    X_near=zeros(n,4);
    for i=1:n
        X_near(i,:)=[RRTree(index(i),1:3),index(i)]; % 返回距离小于r的树节点的坐标，父节点索引号以及在RRTree中的行数（共4列）
    end
end
end


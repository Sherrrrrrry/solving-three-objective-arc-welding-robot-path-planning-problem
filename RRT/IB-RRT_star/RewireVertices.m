
% 若圆内其他树节点以x_new为父节点所得到的路径长度小于原先的路径长度，则更新路径（RRTree_new为更新后的路径），否则不更新
function RRTree_new=RewireVertices(x_min,x_new,Ls,RRTree,map)
[~,~,n]=size(Ls); % n为圆内距离小于r的树节点的个数，Ls已经根据路径长度从小到大排好顺序，每行数组依次存储坐标信息、路径长度、轨迹
for i=1:n
    x_near=Ls{1,1,i}; % 坐标信息
    traj=Ls{1,3,i}; % 轨迹
    dis=Cost(RRTree,x_min); % Cost计算从RRTree的根节点（起始点）到x_min的路径长度
    if dis+distanceCost(x_min(1:2),x_new)+distanceCost(x_new,x_near(1:2))<Cost(RRTree,x_near)
    % 若RRTree-x_min-x_new-x_near的路线长度 < RRTree-x_near的路线长度，则更新，否则维持不变
        if checkPath(x_near(1:2),x_new,map) % 若除x_min之外的x_near与x_new无碰撞，则连接
            RRTree(x_near(4),3)=length(RRTree); % x_near(4)储存x_near自身在RRTree中的行数号，先利用这个数据找到x_near，然后添加x_near父节点的索引号
                                                % 新节点x_new为x_near的父节点，故将x_new在RRTree中的行数号赋给x_near的第3列元素
        end
    end
end
RRTree_new=RRTree;
end


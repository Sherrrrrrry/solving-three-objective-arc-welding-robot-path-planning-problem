
% 计算从RRTree的根节点（起始点）到x_near的路径长度
function pathLength = Cost(RRTree,x_near,dim)
    if dim == 2
        path=[x_near(1:2)];
        prev=x_near(3);
        pathLength=0;
        if prev<2 % 若在x_near前只有一个树节点（即起始点），则pathLength即为起始点到x_near的距离
            pathLength=pathLength+distanceCost(x_near,RRTree(1,1:2));
        else
            while prev>0
                path=[RRTree(prev,1:2);path];
                prev=RRTree(prev,3);
            end
            for i=1:length(path)-1
                pathLength=pathLength+distanceCost(path(i,1:2),path(i+1,1:2));
            end
        end
    else
        if dim == 3
            path=[x_near(1:dim)];
        prev=x_near(dim+3);
        pathLength=0;
        if prev<2 % 若在x_near前只有一个树节点（即起始点），则pathLength即为起始点到x_near的距离
            pathLength=pathLength+norm(x_near(1,1:dim)-RRTree(1,1:dim));
        else
            while prev>0
                path=[RRTree(prev,1:dim);path];
                prev=RRTree(prev,dim+3);
            end
            for i=1:length(path)-1
                pathLength=pathLength+norm(path(i,1:dim)-path(i+1,1:dim));
            end
        end
    end
end


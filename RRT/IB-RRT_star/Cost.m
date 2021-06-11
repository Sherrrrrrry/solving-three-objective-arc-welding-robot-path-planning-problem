
% �����RRTree�ĸ��ڵ㣨��ʼ�㣩��x_near��·������
function pathLength = Cost(RRTree,x_near,dim)
    if dim == 2
        path=[x_near(1:2)];
        prev=x_near(3);
        pathLength=0;
        if prev<2 % ����x_nearǰֻ��һ�����ڵ㣨����ʼ�㣩����pathLength��Ϊ��ʼ�㵽x_near�ľ���
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
        if prev<2 % ����x_nearǰֻ��һ�����ڵ㣨����ʼ�㣩����pathLength��Ϊ��ʼ�㵽x_near�ľ���
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


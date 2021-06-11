
% 输入：两个点坐标，以及维度dim
% 输出：新节点to_point到起始点的最短路径总长度cost

function [cost] = cost_np(from_node,to_point,dim)
    diff = from_node(:,1:dim) - to_point;
    eucl_dist = norm(diff); % 新节点to_point到距离其最近的树节点from_node的路径长度eucl_dist
    cost = from_node(:,dim+2) + eucl_dist; % tree中第dim+2列存放该节点到起始点的路径总长度
end

% ���룺���������꣬�Լ�ά��dim
% ������½ڵ�to_point����ʼ������·���ܳ���cost

function [cost] = cost_np(from_node,to_point,dim)
    diff = from_node(:,1:dim) - to_point;
    eucl_dist = norm(diff); % �½ڵ�to_point����������������ڵ�from_node��·������eucl_dist
    cost = from_node(:,dim+2) + eucl_dist; % tree�е�dim+2�д�Ÿýڵ㵽��ʼ���·���ܳ���
end
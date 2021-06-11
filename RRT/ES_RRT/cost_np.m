%calculate the cost from a node to a point
function [cost] = cost_np(from_node,to_point,end_node,dim)
%% Original
% diff = from_node(:,1:dim) - to_point;
% eucl_dist = norm(diff);
% cost = from_node(:,dim+2) + eucl_dist;
%% Improvement
diff = from_node(:,1:dim) - to_point;
eucl_dist = norm(diff);
dir = from_node(:,1:dim) - end_node(:,1:dim);
theta = acos(diff*dir'/(eucl_dist*norm(dir)));
d = abs(eucl_dist*sin(theta));
dist = eucl_dist + 5*d;
cost = from_node(:,dim+2) + d;%dist;


end
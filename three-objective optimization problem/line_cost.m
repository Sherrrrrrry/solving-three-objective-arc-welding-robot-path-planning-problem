function [cost] = line_cost(from_node,to_point,end_node,dim)
%% Original
% diff = from_node(:,1:dim) - to_point;
% cost = norm(diff);
%% Improvement
diff = from_node(:,1:dim) - to_point;
cost = norm(diff);
dir = from_node(:,1:dim) - end_node(:,1:dim);
theta = acos(diff*dir'/(cost*norm(dir)));
d = cost*sin(theta);
cost = cost + 1*d;
end

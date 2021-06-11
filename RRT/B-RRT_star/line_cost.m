function [cost] = line_cost(from_node,to_point,dim)
%% Original
diff = from_node(:,1:dim) - to_point;
cost = norm(diff);
end

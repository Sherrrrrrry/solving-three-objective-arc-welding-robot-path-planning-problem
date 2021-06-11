function [tree,flag] = extendTree(tree,end_node,segmentLength,r,world,flag_chk,dim)
global para
flag1=0;
while flag1 == 0
%% select a random point
    [new_node] = my_ellipsoid(tree,end_node,segmentLength,dim);
    idx = new_node(dim+3); 
%     Del = [];
%     for k = 1:size(new_node,1)
%        idx = new_node(k,dim+3); 
%        if collision(new_node(k,:), tree(idx,:), world, 1, dim)==1
%             Del = [Del;k];
%         end
%     end
%     if size(Del) < size(new_node,1)
%         flag1=1;
%     else
%         para = para + rand()*0.05;
%     end

if ~collision(new_node, tree(idx,:), world, 1, dim)
    para = para - rand()*0.05;
    flag1 =1;
else
    para = para + rand()*0.05;
    flag1 =0;
end
end
%     Ra =  size(Del,1)/size(new_node,1);
    [~,lowc] = min(new_node(:,dim+2));
    new_node = real(new_node(lowc,:)); 
    idx = new_node(dim+3);
    min_cost = new_node(dim+2);
    new_point = new_node(1:dim);
    min_parent_idx = idx;
       
    %%  Extend Tree       
        tmp_dist = tree(:,1:dim)-(ones(size(tree,1),1)*new_point);
        dist = sum(tmp_dist.*tmp_dist,2);
%         R = 2 + Ra *0.01;
%         near_idx = find((dist <= (R*r)^2));
        near_idx = find((dist <= (r)^2));
        if size(near_idx,1)>1
            size_near = size(near_idx,1);
            for i = 1:size_near
                if (~collision(new_node, tree(near_idx(i),:), world, 2, dim))
                    cost_near = tree(near_idx(i),dim+2)+line_cost(tree(near_idx(i),:),new_point,end_node,dim);
                    if  cost_near < min_cost
                        min_cost = cost_near;
                        min_parent_idx = near_idx(i);
                    end
                end
            end
        end
        
        new_node = [new_point, 0 , min_cost, min_parent_idx];
        tree = [tree; new_node];
        new_node_idx = size(tree,1);
        
        % 多余搜索点的外部档案利用策略
        if size(near_idx,1)>1
            reduced_idx = near_idx;
            for j = 1:size(reduced_idx,1)
                near_cost = tree(reduced_idx(j),dim+2);
                lcost = line_cost(tree(reduced_idx(j),:),new_point,end_node,dim);
                if near_cost > min_cost + lcost ...
                        && ~collision(tree(reduced_idx(j),:),new_node,world, r, dim)
                    tree(reduced_idx(j),dim+3) = new_node_idx;
                end
                
            end
        end
    
    if flag_chk == 0
        % check to see if new node connects directly to end_node
        if ( (norm(new_node(1:dim)-end_node(1:dim))<r*segmentLength )...
                && (~collision(new_node,end_node,world, 2, dim)) )
%         if  (collision(new_node,end_node,world, R, dim)==0) 
            flag = 1;
            tree(end,dim+1)=1;  % mark node as connecting to end.
        else
            flag = 0;
        end
        
    else
        flag = 1;
    end
end

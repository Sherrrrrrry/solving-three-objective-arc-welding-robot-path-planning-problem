function [tree1,tree2,flag] = extendTree(tree1,tree2,end_node,segmentLength,r,world,flag_chk,dim)
flag1 = 0;
while flag1==0
    % select a random point
    randomPoint = ones(1,dim);
    for i=1:dim
        randomPoint(1,i) = (world.endcorner(i)-world.origincorner(i))*rand;
    end
    % find leaf on node that is closest to randomPoint
    tmp = tree1(:,1:dim)-ones(size(tree1,1),1)*randomPoint;
    sqrd_dist = sqr_eucl_dist(tmp,dim);
    [min_dist,idx] = min(sqrd_dist);
    min_parent_idx = idx;

    new_point = (randomPoint-tree1(idx,1:dim));
    new_point = tree1(idx,1:dim)+(new_point/norm(new_point))*segmentLength;

    min_cost  = cost_np(tree1(idx,:),new_point,dim);
    new_node  = [new_point, 0, min_cost, idx];
    
    if collision(new_node, tree1(idx,:), world,dim)==0
        tmp_dist = tree1(:,1:dim)-(ones(size(tree1,1),1)*new_point);
      dist = sqr_eucl_dist(tmp_dist,dim);
      near_idx = find(dist <= r^2);

      if size(near_idx,1)>1
      size_near = size(near_idx,1);

        for i = 1:size_near
            if collision(new_node, tree1(near_idx(i),:), world,dim)==0

               cost_near = tree1(near_idx(i),dim+2)+line_cost(tree1(near_idx(i),:),new_point,dim);

                if  cost_near < min_cost
                    min_cost = cost_near;
                    min_parent_idx = near_idx(i);
                end

            end
        end
      end

      new_node = [new_point, 0 , min_cost, min_parent_idx];
      tree1 = [tree1; new_node];
      new_node_idx = size(tree1,1);
      if size(near_idx,1)>1
          reduced_idx = near_idx;
          for j = 1:size(reduced_idx,1)
              near_cost = tree1(reduced_idx(j),dim+2);
              lcost = line_cost(tree1(reduced_idx(j),:),new_point,dim);
              if near_cost > min_cost + lcost ...
                      && (collision(tree1(reduced_idx(j),:),new_node,world,dim)==0)
                  tree1(reduced_idx(j),dim+3) = new_node_idx;
              end
              
          end
      end
      flag1=1;
    end
end
if flag_chk == 0
    if (collision(new_node,end_node,world,dim)==0)
        flag = 1;
        tree1(end,dim+1)=1;
    else
        flag = 0;
    end
    if (collision(new_node,tree2(end,:),world,dim)==0)
        flag = 1;
        tree1(end,dim+1)=1;  % 连接end_node的节点第dim+1列为1，整个路径只有这一个节点为1
        tree2(end,dim+1)=1;
    else
        flag = 0;
    end
else
    flag = 1;
end
end

function e_dist = sqr_eucl_dist(array,dim)

sqr_e_dist = zeros(size(array,1),dim);
for i=1:dim

    sqr_e_dist(:,i) = array(:,i).*array(:,i);

end
e_dist = zeros(size(array,1),1);
for i=1:dim

    e_dist = e_dist+sqr_e_dist(:,i);

end

end
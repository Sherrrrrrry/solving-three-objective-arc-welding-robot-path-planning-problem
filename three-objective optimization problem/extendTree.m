function [tree,flag] = extendTree(tree,end_node,segmentLength,r,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,flag_chk,dim)
    global para
    flag1=0;
    para = 0.6;
    while flag1 == 0
        %% select a random point
        new_node = my_ellipsoid(tree,end_node,segmentLength,dim,endcorner,origincorner,rob,G_ob_simply,cylinderRadius);
        idx = new_node(dim+3);
        if pathCollision(new_node, tree(idx,:),origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim) % 0��ʾ����ײ������ײ���ʧ���򷵻�whileѭ�����²���
            flag1 = 0;
            para = para + rand()*0.05;
            continue; % ����continue����ֹ����ѭ�����ص�ѭ������㣨ǰ���while��䣩���²�������㣬��ʼ���еڶ��Σ���һ�Σ�ѭ��
        else
            min_cost = new_node(dim+2);
            new_point = new_node(1:dim);
            min_parent_idx = idx;
            tmp_dist = tree(:,1:dim)-(ones(size(tree,1),1)*new_point);
            dist = sum(tmp_dist.*tmp_dist,2);
%             R = 1;%R + Ra *0.01;       % R(R>4)=4;
            near_idx = find((dist <= r^2));
            
            if size(near_idx,1)>1
                size_near = size(near_idx,1);
                for i = 1:size_near
                    if  (~pathCollision(new_node, tree(idx,:),origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim))
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
            
            if size(near_idx,1)>1
                reduced_idx = near_idx;
                for j = 1:size(reduced_idx,1)
                    near_cost = tree(reduced_idx(j),dim+2);
                    lcost = line_cost(tree(reduced_idx(j),:),new_point,end_node,dim);
                    if near_cost > min_cost + lcost ...
                            && (~pathCollision(new_node, tree(idx,:),origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim))
                        tree(reduced_idx(j),dim+3) = new_node_idx;
                    end
                end
            end
            
            flag1=1;
            para = para - rand()*0.05;
        end
    end
    if flag_chk == 0
        if(~pathCollision(new_node, end_node(1:dim),origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim))
            flag = 1;
            tree(end,dim+1)=1;  % mark node as connecting to end.
        else
            flag = 0;
        end
    else
        flag = 1;
    end
end


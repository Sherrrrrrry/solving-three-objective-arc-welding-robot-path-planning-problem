
% ���룺���ṹtree���յ�end_node������segmentLength���ϰ�����İ뾶r�����ϻ���world��flag_chk��ʾ·���Ƿ�ɹ���Ӳ����£��ɹ�����1������Ϊ0����Ŀ��ά��dim
% ��������µ����ṹnew_tree���Լ����³ɹ��ı�־flag

function [tree1,tree2,flag] = extendTree(tree1,tree2,end_node,segmentLength,r,world,flag_chk,dim)
    flag1 = 0;
    cost_best = 20000;
    while flag1==0
        % ����
        randomPoint = ones(1,dim);
        for i=1:dim
            randomPoint(1,i) = (world.endcorner(i)-world.origincorner(i))*rand;
        end
       %% ��1
        % �ҳ������������������ڵ�
        tmp = tree1(:,1:dim)-ones(size(tree1,1),1)*randomPoint;
        sqrd_dist = sqr_eucl_dist(tmp,dim); % sqrd_dist(N*1)��ÿһ�е�ֵΪ���нڵ㵽�����ľ���ƽ���ͣ�������Ϊ��ŷ�Ͼ��룩
        [~,idx] = min(sqrd_dist); % �ҳ���������Ľڵ�����λ��idx
        min_parent_idx = idx;

        % ������������ new_point�½ڵ��λ��
        new_point = randomPoint  - tree1(idx,1:dim); % ���������꣨�������
        new_point = tree1(idx,1:dim)+(new_point/norm(new_point))*segmentLength; % ������������½ڵ�new_point��λ��

        % �õ��½ڵ�new_node��ȫ����Ϣ����dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
        min_cost  = cost_np(tree1(idx,:),new_point,dim); % �����½ڵ�new_point����ʼ������·���ܳ���min_cost
%         if min_cost < cost_best
%             cost_best = min_cost;
%         else
%             continue;
%         end
        new_node  = [new_point, 0, min_cost, idx]; % ÿ���ڵ�node����dim+3ά��tree�еĵ�dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
           
        % ��ײ��⣬Ȼ����new_node�Ƿ��и��õĸ��ڵ㣬����new_node��Ϊ���ڵ��������Χ�Ľڵ���Ϣ
        if collision(new_node, tree1(idx,:), world,dim)==1 % 0��ʾ����ײ������ײ���ʧ���򷵻�whileѭ�����²���
            flag1 = 0;
            continue; % ����continue����ֹ����ѭ�����ص�ѭ������㣨ǰ���while��䣩���²�������㣬��ʼ���еڶ��Σ���һ�Σ�ѭ��
        else
            tmp_dist = tree1(:,1:dim)-(ones(size(tree1,1),1)*new_point);
            dist = sqr_eucl_dist(tmp_dist,dim);
            near_idx = find(dist <= r^2); % Ѱ�Ұ뾶Ϊr��Բ�ڵ�
            if size(near_idx,1)>1 % ������ڸ����Ľڵ㲢ʹ�½ڵ㵽���ڵ��·�����̣�������½ڵ�ĸ��ڵ�����
                size_near = size(near_idx,1);
                for i = 1:size_near
                    if collision(new_node, tree1(near_idx(i),:), world,dim)==0
                        cost_near = tree1(near_idx(i),dim+2)+line_cost(tree1(near_idx(i),:),new_point,dim);
                        if  cost_near < min_cost
                            min_cost = cost_near;
                            min_parent_idx = near_idx(i); % �����½ڵ�ĸ��ڵ�
                        end
                    end
                end
            end
            new_node = [new_point, 0 , min_cost, min_parent_idx]; % ��tree�д���new_node���õĸ��ڵ㣬������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
            tree1 = [tree1; new_node];
            new_node_idx = size(tree1,1);
            if size(near_idx,1)>1
                reduced_idx = near_idx;
                for j = 1:size(reduced_idx,1)
                    near_cost = tree1(reduced_idx(j),dim+2);
                    lcost = line_cost(tree1(reduced_idx(j),:),new_point,dim);
                    if near_cost > min_cost + lcost && (collision(tree1(reduced_idx(j),:),new_node,world,dim)==0)
                        before = tree1(reduced_idx(j),dim+3);
                        tree1(reduced_idx(j),dim+3) = new_node_idx;
                        after = tree1(reduced_idx(j),dim+3);
                    end
                end
            end
            flag1=1;
        end
    end
    if flag_chk == 0
        % �ж��½ڵ��Ƿ���end_node�������������ʾȫ��·�����ҵ�������flag����Ϊ0����չ������extendTree����ִ��
%         if ( (norm(new_node(1:dim)-end_node(1:dim))<segmentLength )&& (collision(new_node,end_node,world,dim)==0) )
        if (collision(new_node,end_node,world,dim)==0) % ����ײһ����λ
         flag = 1;
            tree1(end,dim+1)=1;  % ����end_node�Ľڵ��dim+1��Ϊ1������·��ֻ����һ���ڵ�Ϊ1
        else
            flag = 0;
        end
        
        if (collision(new_node,tree2(end,:),world,dim)==0) % tree1��tree2�м�ڵ�������
            flag = 1;
            tree1(end,dim+1)=1;  % ����end_node�Ľڵ��dim+1��Ϊ1������·��ֻ����һ���ڵ�Ϊ1
            tree2(end,dim+1)=1;
        else
            flag = 0;
        end
    else
        flag = 1;
    end
end

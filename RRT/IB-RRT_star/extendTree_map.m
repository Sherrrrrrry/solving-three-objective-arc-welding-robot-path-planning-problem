
% ���룺���ṹtree���յ�end_node������segmentLength���ϰ�����İ뾶r�����ϻ���world��flag_chk��ʾ·���Ƿ�ɹ���Ӳ����£��ɹ�����1������Ϊ0����Ŀ��ά��dim
% ��������µ����ṹnew_tree���Լ����³ɹ��ı�־flag

function [tree1,tree2,flag] = extendTree_map(tree1,tree2,end_node,segmentLength,r,origincorner,endcorner,Space,flag_chk,dim)
    flag1 = 0;
    cost_best = 2000;
    while flag1==0
        % ����
        randomPoint = ones(1,dim);
        for i=1:dim
            randomPoint(1,i) = (endcorner(i)-origincorner(i))*rand;
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
        if min_cost < cost_best
            cost_best = min_cost;
        else 
            continue;
        end
        new_node  = [new_point, 0, min_cost, idx]; % ÿ���ڵ�node����dim+3ά��tree�еĵ�dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
           
        % ��ײ��⣬Ȼ����new_node�Ƿ��и��õĸ��ڵ㣬����new_node��Ϊ���ڵ��������Χ�Ľڵ���Ϣ
        if collision_map(new_node, tree1(idx,:), origincorner,endcorner,Space,dim)==1 % 0��ʾ����ײ������ײ���ʧ���򷵻�whileѭ�����²���
            flag1 = 0;
            continue; % ����continue����ֹ����ѭ�����ص�ѭ������㣨ǰ���while��䣩���²�������㣬��ʼ���еڶ��Σ���һ�Σ�ѭ��
        else
            tmp_dist = tree1(:,1:dim)-(ones(size(tree1,1),1)*new_point);
            dist = sqr_eucl_dist(tmp_dist,dim);
            near_idx = find(dist <= r^2); % Ѱ�Ұ뾶Ϊr��Բ�ڵ�
            if size(near_idx,1)>1 % ������ڸ����Ľڵ㲢ʹ�½ڵ㵽���ڵ��·�����̣�������½ڵ�ĸ��ڵ�����
                size_near = size(near_idx,1);
                for i = 1:size_near
                    if collision_map(new_node, tree1(near_idx(i),:), origincorner,endcorner,Space,dim)==0
                        cost_near = tree1(near_idx(i),dim+2)+line_cost(tree1(near_idx(i),:),new_point,dim);
                        if  cost_near < min_cost
                            min_cost = cost_near;
                            min_parent_idx = near_idx(i); % �����½ڵ�ĸ��ڵ�
                        end
                    end
                end
            end
                new_node = [new_point, 0 , min_cost, min_parent_idx]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
                tree1 = [tree1; new_node];
                new_node_idx = size(tree1,1);
                if size(near_idx,1)>1
                    reduced_idx = near_idx;
                    for j = 1:size(reduced_idx,1)
                        near_cost = tree1(reduced_idx(j),dim+2);
                        lcost = line_cost(tree1(reduced_idx(j),:),new_point,dim);
                        if near_cost > min_cost + lcost && collision_map(tree1(reduced_idx(j),:),new_node,origincorner,endcorner,Space,dim) % ��Բ�ڵ�ԭ����·������ > ���ڵ㵽�½ڵ�+�½ڵ㵽��Բ�ڵ�ĳ��ȣ����½ڵ���ΪԲ�������ڵ�ĸ��ڵ�
                            tree1(reduced_idx(j),dim+3) = new_node_idx; % ���½ڵ���ΪԲ�������ڵ�ĸ��ڵ�
                        end
                    end
                end
             flag1=1;
        end
    end
    if flag_chk == 0
        % �ж��½ڵ��Ƿ���end_node�������������ʾȫ��·�����ҵ�������flag����Ϊ0����չ������extendTree����ִ��
%         if ( (norm(new_node(1:dim)-end_node(1:dim))<segmentLength )&& (collision_map(new_node,end_node,origincorner,endcorner,Space,dim)==0) )
        if (collision_map(new_node,end_node,origincorner,endcorner,Space,dim)==0) % ����ײһ����λ
            flag = 1;
            tree1(end,dim+1)=1;  % ����end_node�Ľڵ��dim+1��Ϊ1������·��ֻ����һ���ڵ�Ϊ1
        else
            flag = 0;
        end
        
        if (collision_map(new_node,tree2(end,:),origincorner,endcorner,Space,dim)==0) % tree1��tree2�м�ڵ�������
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


% % ���룺���ṹtree���յ�end_node������segmentLength���ϰ�����İ뾶r�����ϻ���world��flag_chk��ʾ·���Ƿ�ɹ���Ӳ����£��ɹ�����1������Ϊ0����Ŀ��ά��dim
% % ��������µ����ṹnew_tree���Լ����³ɹ��ı�־flag
% 
% function [tree1,tree2,flag] = extendTree_map(tree1,tree2,end_node,segmentLength,r,origincorner,endcorner,Space,flag_chk,dim)
%     flag1 = 0;
%     cost_best = 2000;
%     while flag1==0
%         % ����
%         randomPoint = ones(1,dim);
%         for i=1:dim
%             randomPoint(1,i) = (endcorner(i)-origincorner(i))*rand;
%         end
%        %% ��1
%         % �ҳ������������������ڵ�
%         tmp = tree1(:,1:dim)-ones(size(tree1,1),1)*randomPoint;
%         sqrd_dist = sqr_eucl_dist(tmp,dim); % sqrd_dist(N*1)��ÿһ�е�ֵΪ���нڵ㵽�����ľ���ƽ���ͣ�������Ϊ��ŷ�Ͼ��룩
%         [~,idx] = min(sqrd_dist); % �ҳ���������Ľڵ�����λ��idx
%         min_parent_idx = idx;
% 
%         % ������������ new_point�½ڵ��λ��
%         new_point = randomPoint  - tree1(idx,1:dim); % ���������꣨�������
%         new_point = tree1(idx,1:dim)+(new_point/norm(new_point))*segmentLength; % ������������½ڵ�new_point��λ��
% 
%         % �õ��½ڵ�new_node��ȫ����Ϣ����dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
%         min_cost  = cost_np(tree1(idx,:),new_point,dim); % �����½ڵ�new_point����ʼ������·���ܳ���min_cost
%         new_node  = [new_point, 0, min_cost, idx]; % ÿ���ڵ�node����dim+3ά��tree�еĵ�dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
%            
%         % ��ײ��⣬Ȼ����new_node�Ƿ��и��õĸ��ڵ㣬����new_node��Ϊ���ڵ��������Χ�Ľڵ���Ϣ
%         if collision_map(new_node, tree1(idx,:), origincorner,endcorner,Space,dim)==1 % 0��ʾ����ײ������ײ���ʧ���򷵻�whileѭ�����²���
%             flag1 = 0;
%             continue; % ����continue����ֹ����ѭ�����ص�ѭ������㣨ǰ���while��䣩���²�������㣬��ʼ���еڶ��Σ���һ�Σ�ѭ��
%         else
%             tmp_dist = tree1(:,1:dim)-(ones(size(tree1,1),1)*new_point);
%             dist = sqr_eucl_dist(tmp_dist,dim);
%             near_idx = find(dist <= r^2); % Ѱ�Ұ뾶Ϊr��Բ�ڵ�
%             if size(near_idx,1)>1 % ������ڸ����Ľڵ㲢ʹ�½ڵ㵽���ڵ��·�����̣�������½ڵ�ĸ��ڵ�����
%                 size_near = size(near_idx,1);
%                 for i = 1:size_near
%                     if collision_map(new_node, tree1(near_idx(i),:), origincorner,endcorner,Space,dim)==0
%                         cost_near = tree1(near_idx(i),dim+2)+line_cost(tree1(near_idx(i),:),new_point,dim);
%                         if  cost_near < min_cost
%                             min_cost = cost_near;
%                             min_parent_idx = near_idx(i); % �����½ڵ�ĸ��ڵ�
%                         end
%                     end
%                 end
%             end
%        %% ��2
%         % �ҳ������������������ڵ�
%         tmp2 = tree2(:,1:dim)-ones(size(tree2,1),1)*randomPoint;
%         sqrd_dist2 = sqr_eucl_dist(tmp2,dim); % sqrd_dist(N*1)��ÿһ�е�ֵΪ���нڵ㵽�����ľ���ƽ���ͣ�������Ϊ��ŷ�Ͼ��룩
%         [~,idx2] = min(sqrd_dist2); % �ҳ���������Ľڵ�����λ��idx
%         min_parent_idx2 = idx2;
% 
%         % ������������ new_point�½ڵ��λ��
%         new_point2 = randomPoint  - tree2(idx2,1:dim); % ���������꣨�������
%         new_point2 = tree2(idx2,1:dim)+(new_point2/norm(new_point2))*segmentLength; % ������������½ڵ�new_point��λ��
% 
%         % �õ��½ڵ�new_node��ȫ����Ϣ����dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
%         min_cost2  = cost_np(tree2(idx2,:),new_point2,dim); % �����½ڵ�new_point����ʼ������·���ܳ���min_cost
%         new_node2  = [new_point2, 0, min_cost2, idx2]; % ÿ���ڵ�node����dim+3ά��tree�еĵ�dim+2�д�Ÿõ㵽��ʼ������·���ܳ��ȣ���dim+3�д���丸�ڵ��������
%            
%         % ��ײ��⣬Ȼ����new_node�Ƿ��и��õĸ��ڵ㣬����new_node��Ϊ���ڵ��������Χ�Ľڵ���Ϣ
%         if collision_map(new_node2, tree2(idx2,:), origincorner,endcorner,Space,dim)==1 % 0��ʾ����ײ������ײ���ʧ���򷵻�whileѭ�����²���
%             flag1 = 0;
%             continue; % ����continue����ֹ����ѭ�����ص�ѭ������㣨ǰ���while��䣩���²�������㣬��ʼ���еڶ��Σ���һ�Σ�ѭ��
%         else
%             tmp_dist2 = tree2(:,1:dim)-(ones(size(tree2,1),1)*new_point2);
%             dist2 = sqr_eucl_dist(tmp_dist2,dim);
%             near_idx2 = find(dist2 <= r^2); % Ѱ�Ұ뾶Ϊr��Բ�ڵ�
%             if size(near_idx2,1)>1 % ������ڸ����Ľڵ㲢ʹ�½ڵ㵽���ڵ��·�����̣�������½ڵ�ĸ��ڵ�����
%                 size_near2 = size(near_idx2,1);
%                 for i = 1:size_near2
%                     if collision_map(new_node2, tree2(near_idx2(i),:), origincorner,endcorner,Space,dim)==0
%                         cost_near2 = tree2(near_idx2(i),dim+2)+line_cost(tree2(near_idx2(i),:),new_point2,dim);
%                         if  cost_near2 < min_cost2
%                             min_cost2 = cost_near2;
%                             min_parent_idx2 = near_idx2(i); % �����½ڵ�ĸ��ڵ�
%                         end
%                     end
%                 end
%             end
%             %% ѡ��ǰcost��С��������������������һ��������cost_best��ֵ���ж��Ƿ���Ҫ����
%             if tree1(min_parent_idx,dim+2) <= min(tree2(:,dim+2))
%                 new_node = [new_point, 0 , min_cost, min_parent_idx]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
%                 tree1 = [tree1; new_node];
%                 new_node_idx = size(tree1,1);
%                 if size(near_idx,1)>1
%                     reduced_idx = near_idx;
%                     for j = 1:size(reduced_idx,1)
%                         near_cost = tree1(reduced_idx(j),dim+2);
%                         lcost = line_cost(tree1(reduced_idx(j),:),new_point,dim);
%                         if near_cost > min_cost + lcost && collision_map(tree1(reduced_idx(j),:),new_node,origincorner,endcorner,Space,dim) % ��Բ�ڵ�ԭ����·������ > ���ڵ㵽�½ڵ�+�½ڵ㵽��Բ�ڵ�ĳ��ȣ����½ڵ���ΪԲ�������ڵ�ĸ��ڵ�
%                             tree1(reduced_idx(j),dim+3) = new_node_idx; % ���½ڵ���ΪԲ�������ڵ�ĸ��ڵ�
%                         end
%                     end
%                 end
%                new_node2 = [new_point2, 0 , min_cost2, min_parent_idx2]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
%                tree2 = [tree2; new_node2];
% %                 % ����cost1<=cost2
% %                 if (size(near_idx2,1)>1) && Cost(tree1,tree1(end,:),dim)+Cost(tree2,tree2(min_parent_idx2,:),dim)+norm( new_node(1,1:dim)- tree2(min_parent_idx2,1:dim))<cost_best
% %                     cost_best=Cost(tree1,tree1(end,:),dim)+Cost(tree2,tree2(min_parent_idx2,:),dim)+norm( new_node(1,1:dim)- tree2(min_parent_idx2,1:dim));
% %                      new_node2 = [new_point2, 0 , min_cost2, min_parent_idx2]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
% %                      tree2 = [tree2; new_node2];
% %                 end
% %             else
% %                 new_node2 = [new_point2, 0 , min_cost2, min_parent_idx2]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
% %                 tree2 = [tree2; new_node2];
% %                 new_node_idx2 = size(tree2,1);
% %                 if size(near_idx2,1)>1
% %                     reduced_idx2 = near_idx2;
% %                     for j = 1:size(reduced_idx2,1)
% %                         near_cost2 = tree2(reduced_idx2(j),dim+2);
% %                         lcost2 = line_cost(tree2(reduced_idx2(j),:),new_point2,dim);
% %                         if near_cost2 > min_cost2 + lcost2 && collision_map(tree1(reduced_idx2(j),:),new_node2,origincorner,endcorner,Space,dim) % ��Բ�ڵ�ԭ����·������ > ���ڵ㵽�½ڵ�+�½ڵ㵽��Բ�ڵ�ĳ��ȣ����½ڵ���ΪԲ�������ڵ�ĸ��ڵ�
% %                             tree2(reduced_idx2(j),dim+3) = new_node_idx2; % ���½ڵ���ΪԲ�������ڵ�ĸ��ڵ�
% %                         end
% %                     end
% %                 end
% %                 new_node = [new_point, 0 , min_cost, min_parent_idx]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
% %                 tree1 = [tree1; new_node];
% %                 if (size(near_idx,1)>1) && Cost(tree2,tree2(end,:),dim)+Cost(tree1,tree1(min_parent_idx,:),dim)+norm( new_node2(1,1:dim)- tree1(min_parent_idx,1:dim))<cost_best
% %                     cost_best=Cost(tree2,tree2(end,:),dim)+Cost(tree1,tree1(min_parent_idx,:),dim)+norm( new_node2(1,1:dim)- tree1(min_parent_idx,1:dim));
% %                      new_node = [new_point, 0 , min_cost, min_parent_idx]; % ��tree�д��ڸ��õĸ��ڵ�new_node��������䵽��ʼ���·���ܳ���min_cost�Լ����ڵ��������min_parent_idx
% %                      tree1 = [tree1; new_node];
% %                 end
% %             end
%             flag1=1;
%         end
%     end
%     if flag_chk == 0
%         % �ж��½ڵ��Ƿ���end_node�������������ʾȫ��·�����ҵ�������flag����Ϊ0����չ������extendTree����ִ��
% %         if ( (norm(new_node(1:dim)-end_node(1:dim))<segmentLength )&& (collision(new_node,end_node,world,dim)==0) )
%         if (collision_map(new_node,end_node,origincorner,endcorner,Space,dim)==0) % ����ײһ����λ
%             flag = 1;
%             tree1(end,dim+1)=1;  % ����end_node�Ľڵ��dim+1��Ϊ1������·��ֻ����һ���ڵ�Ϊ1
%         else
%             flag = 0;
%         end
%         
%         if (collision_map(new_node,tree2(end,:),origincorner,endcorner,Space,dim)==0) % tree1��tree2�м�ڵ�������
%             flag = 1;
%             tree1(end,dim+1)=1;  % ����end_node�Ľڵ��dim+1��Ϊ1������·��ֻ����һ���ڵ�Ϊ1
%             tree2(end,dim+1)=1;
%         else
%             flag = 0;
%         end
%     else
%         flag = 1;
%     end
%     end
% end
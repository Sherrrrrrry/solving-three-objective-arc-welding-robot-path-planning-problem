
% 输入：树结构tree，终点end_node，步长segmentLength，障碍物球的半径r，避障环境world，flag_chk表示路径是否成功添加并更新（成功返回1，否则为0），目标维度dim
% 输出：更新的树结构new_tree，以及更新成功的标志flag

function [tree1,tree2,flag] = extendTree_map(tree1,tree2,end_node,segmentLength,r,origincorner,endcorner,Space,flag_chk,dim)
    flag1 = 0;
    cost_best = 2000;
    while flag1==0
        % 采样
        randomPoint = ones(1,dim);
        for i=1:dim
            randomPoint(1,i) = (endcorner(i)-origincorner(i))*rand;
        end
       %% 树1
        % 找出距离采样点最近的树节点
        tmp = tree1(:,1:dim)-ones(size(tree1,1),1)*randomPoint;
        sqrd_dist = sqr_eucl_dist(tmp,dim); % sqrd_dist(N*1)，每一行的值为树中节点到随机点的距离平方和（开方则为其欧氏距离）
        [~,idx] = min(sqrd_dist); % 找出距离最近的节点索引位置idx
        min_parent_idx = idx;

        % 利用向量方法 new_point新节点的位置
        new_point = randomPoint  - tree1(idx,1:dim); % 合力的坐标（纯随机）
        new_point = tree1(idx,1:dim)+(new_point/norm(new_point))*segmentLength; % 利用向量求出新节点new_point的位置

        % 得到新节点new_node的全部信息，第dim+2列存放该点到起始点的最短路径总长度，第dim+3列存放其父节点的索引号
        min_cost  = cost_np(tree1(idx,:),new_point,dim); % 计算新节点new_point到起始点的最短路径总长度min_cost
        if min_cost < cost_best
            cost_best = min_cost;
        else 
            continue;
        end
        new_node  = [new_point, 0, min_cost, idx]; % 每个节点node共有dim+3维，tree中的第dim+2列存放该点到起始点的最短路径总长度，第dim+3列存放其父节点的索引号
           
        % 碰撞检测，然后检查new_node是否有更好的父节点，并以new_node作为父节点更新其周围的节点信息
        if collision_map(new_node, tree1(idx,:), origincorner,endcorner,Space,dim)==1 % 0表示无碰撞，若碰撞检测失败则返回while循环重新采样
            flag1 = 0;
            continue; % 遇到continue，终止本次循环，回到循环的起点（前面的while语句）重新产生随机点，开始进行第二次（下一次）循环
        else
            tmp_dist = tree1(:,1:dim)-(ones(size(tree1,1),1)*new_point);
            dist = sqr_eucl_dist(tmp_dist,dim);
            near_idx = find(dist <= r^2); % 寻找半径为r的圆内点
            if size(near_idx,1)>1 % 如果存在附近的节点并使新节点到根节点的路径更短，则更新新节点的父节点索引
                size_near = size(near_idx,1);
                for i = 1:size_near
                    if collision_map(new_node, tree1(near_idx(i),:), origincorner,endcorner,Space,dim)==0
                        cost_near = tree1(near_idx(i),dim+2)+line_cost(tree1(near_idx(i),:),new_point,dim);
                        if  cost_near < min_cost
                            min_cost = cost_near;
                            min_parent_idx = near_idx(i); % 更新新节点的父节点
                        end
                    end
                end
            end
                new_node = [new_point, 0 , min_cost, min_parent_idx]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
                tree1 = [tree1; new_node];
                new_node_idx = size(tree1,1);
                if size(near_idx,1)>1
                    reduced_idx = near_idx;
                    for j = 1:size(reduced_idx,1)
                        near_cost = tree1(reduced_idx(j),dim+2);
                        lcost = line_cost(tree1(reduced_idx(j),:),new_point,dim);
                        if near_cost > min_cost + lcost && collision_map(tree1(reduced_idx(j),:),new_node,origincorner,endcorner,Space,dim) % 若圆内点原来的路径长度 > 根节点到新节点+新节点到该圆内点的长度，则将新节点作为圆内其他节点的父节点
                            tree1(reduced_idx(j),dim+3) = new_node_idx; % 将新节点作为圆内其他节点的父节点
                        end
                    end
                end
             flag1=1;
        end
    end
    if flag_chk == 0
        % 判断新节点是否与end_node相连，若是则表示全部路径已找到，否则flag返回为0，扩展主程序extendTree继续执行
%         if ( (norm(new_node(1:dim)-end_node(1:dim))<segmentLength )&& (collision_map(new_node,end_node,origincorner,endcorner,Space,dim)==0) )
        if (collision_map(new_node,end_node,origincorner,endcorner,Space,dim)==0) % 无碰撞一步到位
            flag = 1;
            tree1(end,dim+1)=1;  % 连接end_node的节点第dim+1列为1，整个路径只有这一个节点为1
        else
            flag = 0;
        end
        
        if (collision_map(new_node,tree2(end,:),origincorner,endcorner,Space,dim)==0) % tree1与tree2中间节点连接上
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


% % 输入：树结构tree，终点end_node，步长segmentLength，障碍物球的半径r，避障环境world，flag_chk表示路径是否成功添加并更新（成功返回1，否则为0），目标维度dim
% % 输出：更新的树结构new_tree，以及更新成功的标志flag
% 
% function [tree1,tree2,flag] = extendTree_map(tree1,tree2,end_node,segmentLength,r,origincorner,endcorner,Space,flag_chk,dim)
%     flag1 = 0;
%     cost_best = 2000;
%     while flag1==0
%         % 采样
%         randomPoint = ones(1,dim);
%         for i=1:dim
%             randomPoint(1,i) = (endcorner(i)-origincorner(i))*rand;
%         end
%        %% 树1
%         % 找出距离采样点最近的树节点
%         tmp = tree1(:,1:dim)-ones(size(tree1,1),1)*randomPoint;
%         sqrd_dist = sqr_eucl_dist(tmp,dim); % sqrd_dist(N*1)，每一行的值为树中节点到随机点的距离平方和（开方则为其欧氏距离）
%         [~,idx] = min(sqrd_dist); % 找出距离最近的节点索引位置idx
%         min_parent_idx = idx;
% 
%         % 利用向量方法 new_point新节点的位置
%         new_point = randomPoint  - tree1(idx,1:dim); % 合力的坐标（纯随机）
%         new_point = tree1(idx,1:dim)+(new_point/norm(new_point))*segmentLength; % 利用向量求出新节点new_point的位置
% 
%         % 得到新节点new_node的全部信息，第dim+2列存放该点到起始点的最短路径总长度，第dim+3列存放其父节点的索引号
%         min_cost  = cost_np(tree1(idx,:),new_point,dim); % 计算新节点new_point到起始点的最短路径总长度min_cost
%         new_node  = [new_point, 0, min_cost, idx]; % 每个节点node共有dim+3维，tree中的第dim+2列存放该点到起始点的最短路径总长度，第dim+3列存放其父节点的索引号
%            
%         % 碰撞检测，然后检查new_node是否有更好的父节点，并以new_node作为父节点更新其周围的节点信息
%         if collision_map(new_node, tree1(idx,:), origincorner,endcorner,Space,dim)==1 % 0表示无碰撞，若碰撞检测失败则返回while循环重新采样
%             flag1 = 0;
%             continue; % 遇到continue，终止本次循环，回到循环的起点（前面的while语句）重新产生随机点，开始进行第二次（下一次）循环
%         else
%             tmp_dist = tree1(:,1:dim)-(ones(size(tree1,1),1)*new_point);
%             dist = sqr_eucl_dist(tmp_dist,dim);
%             near_idx = find(dist <= r^2); % 寻找半径为r的圆内点
%             if size(near_idx,1)>1 % 如果存在附近的节点并使新节点到根节点的路径更短，则更新新节点的父节点索引
%                 size_near = size(near_idx,1);
%                 for i = 1:size_near
%                     if collision_map(new_node, tree1(near_idx(i),:), origincorner,endcorner,Space,dim)==0
%                         cost_near = tree1(near_idx(i),dim+2)+line_cost(tree1(near_idx(i),:),new_point,dim);
%                         if  cost_near < min_cost
%                             min_cost = cost_near;
%                             min_parent_idx = near_idx(i); % 更新新节点的父节点
%                         end
%                     end
%                 end
%             end
%        %% 树2
%         % 找出距离采样点最近的树节点
%         tmp2 = tree2(:,1:dim)-ones(size(tree2,1),1)*randomPoint;
%         sqrd_dist2 = sqr_eucl_dist(tmp2,dim); % sqrd_dist(N*1)，每一行的值为树中节点到随机点的距离平方和（开方则为其欧氏距离）
%         [~,idx2] = min(sqrd_dist2); % 找出距离最近的节点索引位置idx
%         min_parent_idx2 = idx2;
% 
%         % 利用向量方法 new_point新节点的位置
%         new_point2 = randomPoint  - tree2(idx2,1:dim); % 合力的坐标（纯随机）
%         new_point2 = tree2(idx2,1:dim)+(new_point2/norm(new_point2))*segmentLength; % 利用向量求出新节点new_point的位置
% 
%         % 得到新节点new_node的全部信息，第dim+2列存放该点到起始点的最短路径总长度，第dim+3列存放其父节点的索引号
%         min_cost2  = cost_np(tree2(idx2,:),new_point2,dim); % 计算新节点new_point到起始点的最短路径总长度min_cost
%         new_node2  = [new_point2, 0, min_cost2, idx2]; % 每个节点node共有dim+3维，tree中的第dim+2列存放该点到起始点的最短路径总长度，第dim+3列存放其父节点的索引号
%            
%         % 碰撞检测，然后检查new_node是否有更好的父节点，并以new_node作为父节点更新其周围的节点信息
%         if collision_map(new_node2, tree2(idx2,:), origincorner,endcorner,Space,dim)==1 % 0表示无碰撞，若碰撞检测失败则返回while循环重新采样
%             flag1 = 0;
%             continue; % 遇到continue，终止本次循环，回到循环的起点（前面的while语句）重新产生随机点，开始进行第二次（下一次）循环
%         else
%             tmp_dist2 = tree2(:,1:dim)-(ones(size(tree2,1),1)*new_point2);
%             dist2 = sqr_eucl_dist(tmp_dist2,dim);
%             near_idx2 = find(dist2 <= r^2); % 寻找半径为r的圆内点
%             if size(near_idx2,1)>1 % 如果存在附近的节点并使新节点到根节点的路径更短，则更新新节点的父节点索引
%                 size_near2 = size(near_idx2,1);
%                 for i = 1:size_near2
%                     if collision_map(new_node2, tree2(near_idx2(i),:), origincorner,endcorner,Space,dim)==0
%                         cost_near2 = tree2(near_idx2(i),dim+2)+line_cost(tree2(near_idx2(i),:),new_point2,dim);
%                         if  cost_near2 < min_cost2
%                             min_cost2 = cost_near2;
%                             min_parent_idx2 = near_idx2(i); % 更新新节点的父节点
%                         end
%                     end
%                 end
%             end
%             %% 选择当前cost最小的树进行重连操作，另一棵树根据cost_best的值来判断是否需要更新
%             if tree1(min_parent_idx,dim+2) <= min(tree2(:,dim+2))
%                 new_node = [new_point, 0 , min_cost, min_parent_idx]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
%                 tree1 = [tree1; new_node];
%                 new_node_idx = size(tree1,1);
%                 if size(near_idx,1)>1
%                     reduced_idx = near_idx;
%                     for j = 1:size(reduced_idx,1)
%                         near_cost = tree1(reduced_idx(j),dim+2);
%                         lcost = line_cost(tree1(reduced_idx(j),:),new_point,dim);
%                         if near_cost > min_cost + lcost && collision_map(tree1(reduced_idx(j),:),new_node,origincorner,endcorner,Space,dim) % 若圆内点原来的路径长度 > 根节点到新节点+新节点到该圆内点的长度，则将新节点作为圆内其他节点的父节点
%                             tree1(reduced_idx(j),dim+3) = new_node_idx; % 将新节点作为圆内其他节点的父节点
%                         end
%                     end
%                 end
%                new_node2 = [new_point2, 0 , min_cost2, min_parent_idx2]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
%                tree2 = [tree2; new_node2];
% %                 % 讨论cost1<=cost2
% %                 if (size(near_idx2,1)>1) && Cost(tree1,tree1(end,:),dim)+Cost(tree2,tree2(min_parent_idx2,:),dim)+norm( new_node(1,1:dim)- tree2(min_parent_idx2,1:dim))<cost_best
% %                     cost_best=Cost(tree1,tree1(end,:),dim)+Cost(tree2,tree2(min_parent_idx2,:),dim)+norm( new_node(1,1:dim)- tree2(min_parent_idx2,1:dim));
% %                      new_node2 = [new_point2, 0 , min_cost2, min_parent_idx2]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
% %                      tree2 = [tree2; new_node2];
% %                 end
% %             else
% %                 new_node2 = [new_point2, 0 , min_cost2, min_parent_idx2]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
% %                 tree2 = [tree2; new_node2];
% %                 new_node_idx2 = size(tree2,1);
% %                 if size(near_idx2,1)>1
% %                     reduced_idx2 = near_idx2;
% %                     for j = 1:size(reduced_idx2,1)
% %                         near_cost2 = tree2(reduced_idx2(j),dim+2);
% %                         lcost2 = line_cost(tree2(reduced_idx2(j),:),new_point2,dim);
% %                         if near_cost2 > min_cost2 + lcost2 && collision_map(tree1(reduced_idx2(j),:),new_node2,origincorner,endcorner,Space,dim) % 若圆内点原来的路径长度 > 根节点到新节点+新节点到该圆内点的长度，则将新节点作为圆内其他节点的父节点
% %                             tree2(reduced_idx2(j),dim+3) = new_node_idx2; % 将新节点作为圆内其他节点的父节点
% %                         end
% %                     end
% %                 end
% %                 new_node = [new_point, 0 , min_cost, min_parent_idx]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
% %                 tree1 = [tree1; new_node];
% %                 if (size(near_idx,1)>1) && Cost(tree2,tree2(end,:),dim)+Cost(tree1,tree1(min_parent_idx,:),dim)+norm( new_node2(1,1:dim)- tree1(min_parent_idx,1:dim))<cost_best
% %                     cost_best=Cost(tree2,tree2(end,:),dim)+Cost(tree1,tree1(min_parent_idx,:),dim)+norm( new_node2(1,1:dim)- tree1(min_parent_idx,1:dim));
% %                      new_node = [new_point, 0 , min_cost, min_parent_idx]; % 若tree中存在更好的父节点new_node，则更新其到起始点的路径总长度min_cost以及父节点的索引号min_parent_idx
% %                      tree1 = [tree1; new_node];
% %                 end
% %             end
%             flag1=1;
%         end
%     end
%     if flag_chk == 0
%         % 判断新节点是否与end_node相连，若是则表示全部路径已找到，否则flag返回为0，扩展主程序extendTree继续执行
% %         if ( (norm(new_node(1:dim)-end_node(1:dim))<segmentLength )&& (collision(new_node,end_node,world,dim)==0) )
%         if (collision_map(new_node,end_node,origincorner,endcorner,Space,dim)==0) % 无碰撞一步到位
%             flag = 1;
%             tree1(end,dim+1)=1;  % 连接end_node的节点第dim+1列为1，整个路径只有这一个节点为1
%         else
%             flag = 0;
%         end
%         
%         if (collision_map(new_node,tree2(end,:),origincorner,endcorner,Space,dim)==0) % tree1与tree2中间节点连接上
%             flag = 1;
%             tree1(end,dim+1)=1;  % 连接end_node的节点第dim+1列为1，整个路径只有这一个节点为1
%             tree2(end,dim+1)=1;
%         else
%             flag = 0;
%         end
%     else
%         flag = 1;
%     end
%     end
% end
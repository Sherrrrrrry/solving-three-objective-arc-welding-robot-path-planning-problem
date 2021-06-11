
% 采样点超出界限，与障碍物碰撞，或者机械臂在采样点之间移动时与障碍物碰撞，collision_flag均输出为1 碰撞   0 无碰撞
function collision_flag = pathCollision(start_node, end_node,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim)
    collision_flag = 0; % collision_flag为0表示无碰撞，为1则表示有碰撞
    % 判断两个扩展点是否超出界限
    for i=1:dim
        if ( start_node(i) > endcorner(i)) || (start_node(i) < origincorner(i) )
            collision_flag = 1; 
            break;
        end
        if ( end_node(i) > endcorner(i)) || (end_node(i) < origincorner(i) )
            collision_flag = 1; 
            break;
        end
    end
    if collision_flag == 0 && dim ==3
        nodeDis = sqrt((start_node(1)-end_node(1))^2+(start_node(2)-end_node(2))^2+(start_node(3)-end_node(3))^2);
        %         sigma = 0:1/nodeDis:1; % 根据两点距离长度来确定采样的间隔
        sigma = 0:0.1:1; % 根据两点距离长度来确定采样的间隔
        p_num = size(sigma,2);
        for i = 1:p_num
            p(i,:) = sigma(i)*start_node(1:dim) + (1-sigma(i))*end_node(1:dim);% 得到这些用于碰撞检测的点的坐标
        end
        % 判断采样点是否与障碍物碰撞（末端碰撞检测）
        for i = 1:size(p,1)
            collison_end = endCollison(G_ob_simply,p(i,:));
            if collison_end== 1
                collision_flag = 1;
                break;
            end
        end
        % 判断机械臂在采样点之间运动时是否与障碍物碰撞（机械臂碰撞检测）
        if collison_end == 0 && collision_flag == 0
            for i = 1:size(p,1)
                qSample(i,:) = rob.ikine(transl(p(i,:)),zeros(1,6),[1,1,1,0,0,0]);
                collision_arm = armCollison(rob,qSample(i,:),G_ob_simply,cylinderRadius);
                if collision_arm== 1
                    collision_flag = 1;
                    break;
                end
            end
        end
    else
        collision_flag = 1;
    end
end
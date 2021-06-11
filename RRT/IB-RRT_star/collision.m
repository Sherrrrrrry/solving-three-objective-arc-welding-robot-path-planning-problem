
% 输入：起始点、终止点的坐标，障碍物环境world结构，以及维度dim
% 输出：collision_flag = 0表示无碰撞，1表示有碰撞

function collision_flag = collision(start_node, end_node, world,dim)
    collision_flag = 0; % collision_flag为0表示无碰撞，为1则表示有碰撞
    % 若起点和终点的每维坐标超出最大坐标范围，则表示碰撞（collision_flag = 1）
    for i=1:dim
        if ( start_node(i) > world.endcorner(i)) || (start_node(i) < world.origincorner(i) )
            collision_flag = 1; 
        end
        if ( end_node(i) > world.endcorner(i)) || (end_node(i) < world.origincorner(i) )
            collision_flag = 1; 
        end
    end
    for sigma = 0:.01:1
        p = sigma*start_node(1:dim) + (1-sigma)*end_node(1:dim);
        % check each obstacle
        for i=1:world.NumObstacles
            
            obs = cell2mat(world.radius(i));
            if (p(1)>=world.cx(i) && p(1)<=world.cx(i)+obs(1))...
                    && (p(2)>=world.cy(i) && p(2)<=world.cy(i)+obs(2))...
                    && (p(3)>=world.cz(i) && p(3)<=world.cz(i)+obs(3))
                collision_flag = 1;
                break;
            end
        end
    end
end

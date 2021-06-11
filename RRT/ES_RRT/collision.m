function collision_flag = collision(node, parent, world, R, dim)
    collision_flag = 0;
    for i=1:dim
        if (node(i)>world.endcorner(i))|(node(i)<world.origincorner(i))
            collision_flag = 1;
        end
    end
        
    if collision_flag == 0 
        for sigma = 0:.01*R:1
            p = sigma*node(1:dim) + (1-sigma)*parent(1:dim);
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
end
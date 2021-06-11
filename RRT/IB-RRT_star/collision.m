
% ���룺��ʼ�㡢��ֹ������꣬�ϰ��ﻷ��world�ṹ���Լ�ά��dim
% �����collision_flag = 0��ʾ����ײ��1��ʾ����ײ

function collision_flag = collision(start_node, end_node, world,dim)
    collision_flag = 0; % collision_flagΪ0��ʾ����ײ��Ϊ1���ʾ����ײ
    % �������յ��ÿά���곬��������귶Χ�����ʾ��ײ��collision_flag = 1��
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

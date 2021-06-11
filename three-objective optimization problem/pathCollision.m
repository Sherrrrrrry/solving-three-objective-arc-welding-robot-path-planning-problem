
% �����㳬�����ޣ����ϰ�����ײ�����߻�е���ڲ�����֮���ƶ�ʱ���ϰ�����ײ��collision_flag�����Ϊ1 ��ײ   0 ����ײ
function collision_flag = pathCollision(start_node, end_node,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim)
    collision_flag = 0; % collision_flagΪ0��ʾ����ײ��Ϊ1���ʾ����ײ
    % �ж�������չ���Ƿ񳬳�����
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
        %         sigma = 0:1/nodeDis:1; % ����������볤����ȷ�������ļ��
        sigma = 0:0.1:1; % ����������볤����ȷ�������ļ��
        p_num = size(sigma,2);
        for i = 1:p_num
            p(i,:) = sigma(i)*start_node(1:dim) + (1-sigma(i))*end_node(1:dim);% �õ���Щ������ײ���ĵ������
        end
        % �жϲ������Ƿ����ϰ�����ײ��ĩ����ײ��⣩
        for i = 1:size(p,1)
            collison_end = endCollison(G_ob_simply,p(i,:));
            if collison_end== 1
                collision_flag = 1;
                break;
            end
        end
        % �жϻ�е���ڲ�����֮���˶�ʱ�Ƿ����ϰ�����ײ����е����ײ��⣩
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
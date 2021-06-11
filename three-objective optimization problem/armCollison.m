
function collision_arm = armCollison(rob,q,G_ob_simply,cylinderRadius)
    % ����6���ؽ�
    collision_arm = 0;
    x0 = [0;0;0];
    
    T1 = rob.A(1,q); % AΪת������TΪλ�˾���
    x1 = T1(1:3,4); % link0-1��е��ĩ��λ������
    
    T2 = rob.A(1,q) * rob.A(2,q);
    x2 = T2(1:3,4);
    
    T3 = rob.A(1,q) * rob.A(2,q) * rob.A(3,q); 
    x3 = T3(1:3,4); 
    
    T4 = rob.A(1,q) * rob.A(2,q) * rob.A(3,q) * rob.A(4,q);
    x4 = T4(1:3,4);
    
    T5 = rob.A(1,q) * rob.A(2,q) * rob.A(3,q) * rob.A(4,q) * rob.A(5,q);
    x5 = T5(1:3,4);
    
    T6 = rob.A(1,q) * rob.A(2,q) * rob.A(3,q) * rob.A(4,q) * rob.A(5,q)*rob.A(6,q);
    x6 = T6(1:3,4);
    
    vec = 0:0.2:1; % �ڻ�е���ϼ������
    m = size(vec,2);
    
    x01 = repmat(x1-x0,1,m) .* repmat(vec,3,1) + repmat(x0,1,m);
    x12 = repmat(x2-x1,1,m) .* repmat(vec,3,1) + repmat(x1,1,m);
    x23 = repmat(x3-x2,1,m) .* repmat(vec,3,1) + repmat(x2,1,m);
    x34 = repmat(x4-x3,1,m) .* repmat(vec,3,1) + repmat(x3,1,m);
    x45 = repmat(x5-x4,1,m) .* repmat(vec,3,1) + repmat(x4,1,m);
    x56 = repmat(x6-x5,1,m) .* repmat(vec,3,1) + repmat(x5,1,m);
    
    x = [x01 x12 x23 x34 x45 x56]; % 3*(6+6+6+6+6+6)���õ���е�������в������������Ϣ
    x=x'; % ������������Ϣ��36*3

    % G_ob_simply���ϼ�⣬���ǻ�е�۵İ뾶����cylinderRadius
    for j = 1:size(x,1)
        for i = 1:size(G_ob_simply,1)
                if (x(j,1)>=G_ob_simply(i,1) && x(j,1)<=G_ob_simply(i,1)+G_ob_simply(i,4)+cylinderRadius)...
                    && (x(j,2)>=G_ob_simply(i,2) && x(j,2)<=G_ob_simply(i,2)+G_ob_simply(i,5)+cylinderRadius)...
                    && (x(j,3)>=G_ob_simply(i,3) && x(j,3)<=G_ob_simply(i,3)+G_ob_simply(i,6)+cylinderRadius)
                    collision_arm = 1; % ��ײ 1 ����ײ 0
                    break;
                end
        end
    end
end
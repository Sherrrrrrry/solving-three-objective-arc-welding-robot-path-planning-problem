
function [RRTree1,pathFound,extendFail] = rrt_starExtend(RRTree1,RRTree2,goal,stepsize,maxFailedAttempts,disTh,map)
pathFound=[]; %if path found, returns new node connecting the two trees, index of the nodes in the two trees connected
failedAttempts=0;
while failedAttempts<=maxFailedAttempts % ��ʼѭ��
    %% �������������
    if rand < 0.5 %rand��ʾ����0��1��һ���������rand(1,2)��ʾ����1*2�����������
        sample=rand(1,2) .* size(map); % size(map)���map��������������.*��ʾ��ˣ���ͬ��С�ľ���Ԫ�ض�Ӧ���
    else 
        sample=goal;
    end
    %% �ҵ�RRTree1�Ͼ������������Ľڵ㣬�����ݽǶȺͲ�������½ڵ��λ������
    [~, I]=min(distanceCost(RRTree1(:,1:2),sample) ,[],1);
    %[A,I]=min(B,[],1])��ʾѰ�Ҿ���Bÿһ�е���Сֵ�����Ӧ������������������A��I��A������¼����Bÿ�е���Сֵ��I������¼ÿ����Сֵ�к�
    x_nearest= RRTree1(I,1:2);
    theta=atan2(sample(1)-x_nearest(1),sample(2)-x_nearest(2));
    x_new = double(int32(x_nearest(1:2) + stepsize * [sin(theta)  cos(theta)]));
    %% �ж�����ڵ����½ڵ�������Ƿ�����ײ���������������ص�ѭ��������²���
    if ~checkPath(x_nearest(1:2), x_new, map) % if extension of closest node in tree to the new point is feasible
        failedAttempts=failedAttempts+1;
        continue;%����continue����ֹ����ѭ�����ص�ѭ������㣨ǰ���while��䣩���²�������㣬��ʼ���еڶ��Σ���һ�Σ�ѭ��
    end
    %% ��Բ����x_new����С��r�����ڵ�������Ϣ���浽X_near�У���X_near��ѡ��x_min��Ϊx_new�ĸ��ڵ㣬������x_new�������ţ������RRTree�У���x_min��RRT�е������ţ�
    X_near = NearestVertices(x_new,RRTree1); % X_near������������½ڵ�x_new����С��r��n�����ڵ����Ϣ�Լ���Щ���ڵ���RRTree�е���������СΪn*4������û�У��� X_near = []
    if  size(X_near)==[0,0] % ��Բ�ڲ�����X_near�����Ҿ���x_new����Ľڵ㣬�����ýڵ�������Լ���RRTree�е��������ظ�X_near
        [~, I1]=min(distanceCost(RRTree1(:,1:2),x_new) ,[],1); 
        X_near = [RRTree1(I1,1:3),I1];
    end
    Ls = GetSortedList(x_new,X_near,RRTree1); % ����RRTree--X_near--x_new��·�����ȴ�С��������
                                              % ����X_near����n�����ڵ㣬��Ls�Ĵ�СΪ��1,3,n������ʾn��3�е����飬��1��2��3�зֱ𴢴�������Ϣ��·�����ȡ��켣
    x_min = ChooseBestParent(Ls,map); % �ҵ�X_near����x_new֮���·��������������ӹ켣��map����ײ�����ڵ㣬��������������Ϣ
                                      % x_min��������Ϣ�������ꡢ���ڵ������к��Լ�������RRTree�е��к�
    if ~size(x_min)==[0 0]
        RRTree1=[RRTree1;[x_new(1:2),x_min(4)]]; %��RRTree1�в����µĽڵ㣬x_min(4)����x_new�������������ײ�ĸ��ڵ�X_near��RRTree�е�������
        %% Բ���������ڵ���x_newΪ���ڵ㣬��������Щ���ڵ��·�����õ��µ�RRTree
        RRTree1=RewireVertices(x_min,x_new,Ls,RRTree1,map);
    end
    %% ��RRTree2��Ѱ����RRTree1�½ڵ��������Ľڵ㣬�������ڵ�ľ���С�ڷ�ֵ�����˳�ѭ������ʾ���ҵ����·��������RRTree1���½ڵ����RRTree1��
    [~, I2]=min(distanceCost(RRTree2(:,1:2),x_new) ,[],1);
    if distanceCost(RRTree2(I2(1),1:2),x_new)<disTh % if both trees are connected
        pathFound=[x_new I(1) I2(1)];
        extendFail=false;
        break; 
    end
    RRTree1=[RRTree1;x_new I(1)];% ��RRTree1���½ڵ����RRTree1��
%     scatter(x_new(2),x_new(1),20,[1 0 1],'filled');%���½ڵ��ô���ɫ��ʵ��Բ�����������Ӿ���
                                                   %ͬʱע��scatter��newpoint�ĺ�������λ�øպ��෴
    extendFail=false;break; % add node
end
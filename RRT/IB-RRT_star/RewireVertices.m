
% ��Բ���������ڵ���x_newΪ���ڵ����õ���·������С��ԭ�ȵ�·�����ȣ������·����RRTree_newΪ���º��·���������򲻸���
function RRTree_new=RewireVertices(x_min,x_new,Ls,RRTree,map)
[~,~,n]=size(Ls); % nΪԲ�ھ���С��r�����ڵ�ĸ�����Ls�Ѿ�����·�����ȴ�С�����ź�˳��ÿ���������δ洢������Ϣ��·�����ȡ��켣
for i=1:n
    x_near=Ls{1,1,i}; % ������Ϣ
    traj=Ls{1,3,i}; % �켣
    dis=Cost(RRTree,x_min); % Cost�����RRTree�ĸ��ڵ㣨��ʼ�㣩��x_min��·������
    if dis+distanceCost(x_min(1:2),x_new)+distanceCost(x_new,x_near(1:2))<Cost(RRTree,x_near)
    % ��RRTree-x_min-x_new-x_near��·�߳��� < RRTree-x_near��·�߳��ȣ�����£�����ά�ֲ���
        if checkPath(x_near(1:2),x_new,map) % ����x_min֮���x_near��x_new����ײ��������
            RRTree(x_near(4),3)=length(RRTree); % x_near(4)����x_near������RRTree�е������ţ���������������ҵ�x_near��Ȼ�����x_near���ڵ��������
                                                % �½ڵ�x_newΪx_near�ĸ��ڵ㣬�ʽ�x_new��RRTree�е������Ÿ���x_near�ĵ�3��Ԫ��
        end
    end
end
RRTree_new=RRTree;
end


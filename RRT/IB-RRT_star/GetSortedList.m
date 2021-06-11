% ���룺x_new,X_near,RRTree
% ���������·�����ȴ�С�������򣬼���X_near����n�����ڵ㣬��Ls�Ĵ�СΪ��1,3,n������ʾn��3�е����飬��1��2��3�зֱ𴢴�������Ϣ��·�����ȡ��켣
function Ls = GetSortedList(x_new,X_near,RRTree)
[n,~]=size(X_near);
Ls=cell(1,3,n); % �����������СΪn*3*1����n��3�У���ÿ��������ֻ��һ��Ԫ��
step=2;
for i=1:n
    traj = Steer(X_near(i,1:2),x_new,step); % traj = [X_near(i,1:2);x_new]
    cost = Cost(RRTree,X_near(i,:))+distanceCost(x_new,X_near(i,1:2)); % RRTree-X_near-x_new��·������
    Ls{1,1,i} = X_near(i,:); % Ls�еĵ�i�е�1�д��棺X_near(i,:)�����ꡢ���ڵ������к��Լ�������RRTree�е��к�������Ϣ����ͬ
    Ls{1,2,i} = cost; % ��i�е�2�д��棺RRTree-X_near-x_new��·������
    Ls{1,3,i} = traj; % ��i�е�3�д��棺traj = [X_near(i,1:2);x_new]��Ϊ2*2�ľ���
end
Ls=sortList(Ls);
end



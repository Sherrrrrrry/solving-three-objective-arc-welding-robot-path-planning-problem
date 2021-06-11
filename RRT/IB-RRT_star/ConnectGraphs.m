
%% ���RRT�Լ��ҵ��½ڵ�x_new�ĸ��ڵ�x_min������Բ���������ڵ��·���󷵻�flag=1
function [flag,RRTree]=ConnectGraphs(RRTree,x1,x2,stepsize,map)
theta=atan2(x1(1)-x2(1),x1(2)-x2(2)); % ����������ĽǶ�
x_new = double(int32(x2(1:2) + stepsize * [sin(theta)  cos(theta)])); % �õ��½ڵ������
X_near=NearestVertices(x_new,RRTree);  % X_near������������½ڵ�x_new����С��r��n�����ڵ����Ϣ�Լ���Щ���ڵ���RRTree�е���������СΪn*4������û�У��� X_near = []
Ls = GetSortedList(x1,X_near,RRTree);  % ����RRTree--X_near--x_new��·�����ȴ�С��������
                                       % ����X_near����n�����ڵ㣬��Ls�Ĵ�СΪ��1,3,n������ʾn��3�е����飬��1��2��3�зֱ𴢴�������Ϣ��·�����ȡ��켣
x_min = ChooseBestParent(Ls,map); % �ҵ�X_near����x_new֮���·��������������ӹ켣��map����ײ�����ڵ㣬��������������Ϣ
                                  % x_min��������Ϣ�������ꡢ���ڵ������к��Լ�������RRTree�е��к�
traj=[];
flag=0;
if ~size(x_min)==[0 0]
    RRTree=[RRTree;[x1(1:2),x_min(4)]];
    RRTree=RewireVertices(x_min,x_new,Ls,RRTree,map); % Բ���������ڵ���x_newΪ���ڵ㣬��������Щ���ڵ��·�����õ��µ�RRTree
    flag=1;
end
end


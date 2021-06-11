
% ���룺�½ڵ�x_new��RRTree����Ϣ
% �����X_near������������½ڵ�x_new����С��r��n�����ڵ����Ϣ�Լ���Щ���ڵ���RRTree�е���������СΪn*4������û�У��� X_near = []
function X_near = NearestVertices(x_new,RRTree)
% NearestVertices 
% ������RRTree�о�����������r���ڵĵ�
% ��¼�����꣬���ڵ㣬�����е�����������
[num,~]=size(RRTree); % ����RRTree����������numΪRRTree�����ڵ�ĸ���
gama =500;
r = gama*sqrt(log(num)/num); % �����logָ��ln��rΪԲ�İ뾶
dis = distanceCost(RRTree(:,1:2),x_new);
index = find(dis<=r); % ����RRTree����x_new֮��ľ���С��r���������ڵ���RRTree�е�����
[n,~] = size(index); % �������С��r�����ڵ�ĸ���
if n==0
    X_near=[];
else
    X_near=zeros(n,4);
    for i=1:n
        X_near(i,:)=[RRTree(index(i),1:3),index(i)]; % ���ؾ���С��r�����ڵ�����꣬���ڵ��������Լ���RRTree�е���������4�У�
    end
end
end


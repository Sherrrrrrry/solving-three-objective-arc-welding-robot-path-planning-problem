function [new_node,R]=my_ellipsoid(tree, end_node,segmentLength,dim)
F1 = tree(1,1:3);
F2 = end_node(1:3);
%���������
cc = 0.6; %��Բ�����ɱ� cc>0.5
a = pdist2(F1,F2)*cc;
b = sqrt(a^2-(norm(F1-F2)/2)^2);
c = b;
elli_dist = a - 0.5 * pdist2(tree(1,1:3),end_node(1:3));
unit = (end_node(1:3) - tree(1,1:3))/norm(end_node(1:3) - tree(1,1:3)); %���������ĵ�
elli_start = tree(1,1:3) - unit * elli_dist; % ����������˵�
elli_end =end_node(1:3) + unit * elli_dist; % ��������յ�˵�
g = 0;
R = 0;
while g == 0
randnum = (TruncatedGaussian(1.7, [-7,1],[1,3])+7)/8;  %��ó���������鷶Χ��[-1,1]��Χ��
randomPoint = randnum.*(elli_end-elli_start);
% find leaf on node that is closest to randomPoint
tmp = tree(:,1:dim)-randomPoint;
sqrd_dist = sum(tmp.*tmp,2);
[min_dist,idx] = min(sqrd_dist);
new_point = (randomPoint-tree(idx,1:dim));
new_point = tree(idx,1:dim)+(new_point/norm(new_point))*segmentLength;
% min_cost  = cost_np(tree(idx,:),new_point,dim);
min_cost  = cost_np(tree(idx,:),new_point,end_node,dim);
new_node  = [new_point, 0, min_cost, idx];
% if  ((R <= 50)&&(pdist2(new_node(1:dim),F1)+ pdist2(new_node(1:dim),F2)<= 2*a))||(R > 50) %((new_point(1)/a)^2+(new_point(2)^2 +new_point(3)^2)/b^2 <=1) 
if pdist2(new_node(1:dim),F1)+ pdist2(new_node(1:dim),F2)<= 2*a
    g=1;
else
    g=0;
end
R = R+1;
end
end
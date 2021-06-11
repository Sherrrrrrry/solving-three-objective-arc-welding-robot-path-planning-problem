function randomPoint = hyperellipsoid(cbest,tree,end_node)
point_F1 = tree;
point_F2 = end_node;

cmin = norm(point_F1-point_F2);
% cbest = cmin*para;
b=sqrt(cbest^2-cmin^2);%���᳤�ȣ�
c=sqrt(cbest^2-cmin^2);%���᳤�ȣ�
a=cmin;

cos_theta=abs((point_F1-point_F2)*[1 0 0]'/norm(point_F1-point_F2));
sin_theta=1-cos_theta^2;
A=[1 0 0;0 cos_theta -sin_theta;0 sin_theta cos_theta];%��ת����
point_rand(1)=(rand*2-1)*a;%x������,-a��a
point_rand(2)=(rand*2-1)*(1-(point_rand(1)/a)^2)*b;%y�����ƣ�
point_rand(3)=(rand*2-1)*(1-(point_rand(1)/a)^2-(point_rand(2)/b)^2)*c;%z������

randomPoint=(A*point_rand');%��תƽ�Ƶ���������ϵ
randomPoint=randomPoint'+0.5*(point_F1+point_F2);

end
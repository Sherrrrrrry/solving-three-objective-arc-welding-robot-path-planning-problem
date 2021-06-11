function z=costfunction(x,f1,f2) % x为一个个体，即一行序列，f1、f2分别是距离、能耗矩阵
f{1}=f1; % f1为distance_80的距离矩阵，各城市之间的距离已经提前计算好了，比如第2个城市与第3个城市之间的距离就存放在f1(2,3)或者f1(3,2)
f{2}=f2; % f2为energy_80能耗矩阵，同样地，第2个城市与第3个城市之间的能耗就存放在f2(2,3)或者f2(3,2)
n=size(x,2); % n为城市数/焊点数
for i=1:2
    dist=0;
    for j=1:n-1
        dist=dist+f{i}(x(j),x(j+1));
    end
    dist=dist+f{i}(x(n),x(1));
    z(i)=dist; 
end
end
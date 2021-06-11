% function result = costfunction(pop,city1,city2)
% distMat1 = squareform(pdist(city1)); % Precalculate Distance Matrix
% distMat2 = squareform(pdist(city2)); % Precalculate Distance Matrix
%     ind = pop;
%     distance1 = distMat1(ind(1), ind(end));
%     distance2 = distMat2(ind(1), ind(end));
%     Num = size(city1,1);
%     for iCity = 2:Num
%         twoCityIndices= [ind(iCity-1), ind(iCity)]; % Indices of distance matrix
%         distance1 = distance1 + distMat1(twoCityIndices(1), twoCityIndices(2));
%         distance2 = distance2 + distMat1(twoCityIndices(1), twoCityIndices(2));
%     end
% result = [distance1,distance2];
% end
function z=costfunction(x,f1,f2) % xΪһ�����壬��һ�����У�f1��f2�ֱ��Ǿ��롢�ܺľ���
f{1}=f1; % f1Ϊdistance_80�ľ�����󣬸�����֮��ľ����Ѿ���ǰ������ˣ������2���������3������֮��ľ���ʹ����f1(2,3)����f1(3,2)
f{2}=f2; % f2Ϊenergy_80�ܺľ���ͬ���أ���2���������3������֮����ܺľʹ����f2(2,3)����f2(3,2)
n=size(x,2); % nΪ������/������
for i=1:2
    dist=0;
    for j=1:n-1
        dist=dist+f{i}(x(j),x(j+1));
    end
    dist=dist+f{i}(x(n),x(1));
    z(i)=dist; 
end
end


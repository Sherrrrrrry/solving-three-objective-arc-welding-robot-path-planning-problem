function [new_node] = my_ellipsoid(tree,end_node,segmentLength,dim)
global para
point_F1 = tree(1,1:dim);
point_F2 = end_node(1:dim);
N=1;
new_node = [];
cmin = norm(point_F1-point_F2);
a = cmin;
cbest = cmin*1.2;
b = sqrt(cbest^2-cmin^2)*para;
c = b;

% randnum = 1-(TruncatedGaussian(1, [-3,1],[N,3])+7)/4;
randnum = abs((TruncatedGaussian(1.7, [-7,1],[1,3])+7)/8);
elli_dist = a - 0.5 * pdist2(tree(1,1:3),end_node(1:3));
unit = (end_node(1:3) - tree(1,1:3))/norm(end_node(1:3) - tree(1,1:3)); %椭球体中心点
elli_start = tree(1,1:3) - unit * elli_dist; % 椭球体的起点端点
elli_end =end_node(1:3) + unit * elli_dist; % 椭球体的终点端点
% randomPoint =elli_start + randnum.*(elli_end-elli_start);
sign = round(rand(1,dim)).*2-1;
randomPoint =0.5*(elli_end+elli_start) + randnum.*(elli_end-elli_start).*sign/2;

% randnum = rand(5,3);
% randomPoint = randnum*100;
% find leaf on node that is closest to randomPoint
% new_node = [];

tmp = tree(:,1:dim)-randomPoint;
sqrd_dist = sum(tmp.*tmp,2);
[min_dist,idx] = min(sqrd_dist);
new_point = (randomPoint-tree(idx,1:dim));
new_point = tree(idx,1:dim)+(new_point/norm(new_point))*segmentLength;
if pdist2(new_point,point_F1)+ pdist2(new_point,point_F2)<= 2*cbest
    % min_cost  = cost_np(tree(idx,:),new_point,dim);
    min_cost  = cost_np(tree(idx,:),new_point,end_node,dim);
    new_node  = [new_node;new_point, 0, min_cost, idx];
else
    para = para + rand()*0.05;
end
    
[~,xx] = sort(new_node(:,dim+2));
new_node = new_node(xx,:);

% if size(new_node,1)<N
% %     randomPoint = (end_node(1:dim)-tree(end,1:dim))*(elli_end-elli_start);
%     randomPoint = (rand(1,3))*(elli_end-elli_start);
%     tmp = tree(:,1:dim)-randomPoint(i,:);
%     sqrd_dist = sum(tmp.*tmp,2);
%     [min_dist,idx] = min(sqrd_dist);
%     new_point = (randomPoint(i,:)-tree(idx,1:dim));
%     new_point = tree(idx,1:dim)+(new_point/norm(new_point))*segmentLength;
%     min_cost  = cost_np(tree(idx,:),new_point,end_node,dim);
%     new_node  = [new_node;new_point, 0, min_cost, idx];
% end
end
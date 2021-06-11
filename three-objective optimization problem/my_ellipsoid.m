function [new_node] = my_ellipsoid(tree,end_node,segmentLength,dim,endcorner,origincorner,rob,G_ob_simply,cylinderRadius)
    global para
    point_F1 = tree(1,1:dim);
    point_F2 = end_node(1:dim);

    cmin = norm(point_F1-point_F2);
    a = cmin;
    cbest = cmin*1.2;
    b = sqrt(cbest^2-cmin^2)*para;
    c = b;
    elli_dist = a - 0.5 * pdist2(tree(1,1:3),end_node(1:3));
    unit = (end_node(1:3) - tree(1,1:3))/norm(end_node(1:3) - tree(1,1:3)); %椭球体中心点
    elli_start = tree(1,1:3) - unit * elli_dist; % 椭球体的起点端点
    elli_end =end_node(1:3) + unit * elli_dist; % 椭球体的终点端点
    new_node = [];
    while size(new_node,2)<1
        sign = round(rand(1,dim)).* 2 - 1;
        randnum = abs((TruncatedGaussian(1.7, [-7,1],[1,3])+3)/4);
        randomPoint = 0.5*(elli_start + elli_end) +randnum.*(elli_end-elli_start).*sign/2;
        %     randomPoint = elli_start +randnum.*(elli_end-elli_start);
        %     randomPoint = elli_start +randnum*norm(elli_end-elli_start).*sign(elli_end-elli_start);
        %     randomPoint = randnum.*(endcorner-origincorner);
        tmp = tree(:,1:dim)-ones(size(tree,1),1)*randomPoint;
        sqrd_dist = sum(tmp.*tmp,2);
        [~,idx] = min(sqrd_dist);
        new_point = (randomPoint-tree(idx,1:dim));
        new_point = tree(idx,1:dim)+(new_point/norm(new_point))*segmentLength;
        if pdist2(new_point,point_F1)+ pdist2(new_point,point_F2)<= 2*cbest
            % min_cost  = cost_np(tree(idx,:),new_point,dim);
            min_cost  = cost_np(tree(idx,:),new_point,end_node,dim);
            new_node  = [new_point, 0, min_cost, idx];
        end
    end

% if rand < 0.1
%     randomPoint = point_F2;
%     tmp = tree(:,1:dim)-randomPoint;
%     sqrd_dist = sum(tmp.*tmp,2);
%     [~,idx] = min(sqrd_dist);
%     add_point = (randomPoint-tree(idx,1:dim));
%     new_point(end,:) = tree(idx,1:dim)+(add_point/norm(add_point))*segmentLength;
% end
end
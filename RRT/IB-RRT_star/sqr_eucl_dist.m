
% 输入：array(节点个数N*dim，维度dim)
% 输出：e_dist(N*1)，每一行的值为树中节点到随机点的距离平方和（开方则为其欧氏距离）

function e_dist = sqr_eucl_dist(array,dim)
    sqr_e_dist = zeros(size(array,1),dim);
    for i=1:dim
        sqr_e_dist(:,i) = array(:,i).*array(:,i);
    end
    
    e_dist = zeros(size(array,1),1);
    for i=1:dim
        e_dist = e_dist+sqr_e_dist(:,i);
    end
end
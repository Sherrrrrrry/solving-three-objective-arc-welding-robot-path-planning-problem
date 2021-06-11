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
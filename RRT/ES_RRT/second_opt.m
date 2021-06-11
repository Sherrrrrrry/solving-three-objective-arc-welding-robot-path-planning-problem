function [tree] = second_opt(tree,dim,world,segmentLength)
Path = tree;
node_num = size(tree,1)-2;
gradiant = zeros(node_num,1);
for i = 1:node_num
    vector1 = tree(i+1,1:dim)-tree(i,1:dim);
    vector2 = tree(i+2,1:dim)-tree(i+1,1:dim);
    gradiant(i,:)=  abs(dot(vector1,vector2)/(norm(vector1)*norm(vector2)));
end 
[~,ind] = sort(gradiant,'descend');
order = 1;

while gradiant(ind(order),:) ~= min(gradiant)
    R = ceil(pdist2(tree(ind(order),1:dim), tree(ind(order)+2,1:dim))/segmentLength);
    if collision(tree(ind(order),:), tree(ind(order)+2,:), world, R, dim)==0
%         tree(ind(order)+2,dim+3)=tree(ind(order)+1,dim+3);
        tree(ind(order)+1,:)=[];
%         for k = 1:size(tree,1)-ind(order)-1
%             tree(k+ind(order)+1,dim+2) = tree(k+ind(order),dim+2)+line_cost(tree(k+ind(order),:),tree(k+ind(order)+1,1:dim),tree(end,1:dim),dim);
%         end
        node_num = size(tree,1)-2; 
        gradiant = zeros(node_num,1);
        for i = 1:node_num
            vector1 = tree(i+1,1:dim)-tree(i,1:dim);
            vector2 = tree(i+2,1:dim)-tree(i+1,1:dim);
            gradiant(i,:)= dot(vector1,vector2)/(norm(vector1)*norm(vector2));
        end
        [~,ind] = sort(gradiant,'descend');
        order = 1;
        
    else
        order = order +1;
    end
end
end
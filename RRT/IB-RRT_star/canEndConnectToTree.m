function flag = canEndConnectToTree(tree,end_node,minDist,world,dim)
  flag = 0;
  % check only last node added to tree since others have been checked
  if ( (norm(tree(end,1:dim)-end_node(1:dim))<minDist)...
     & (collision(tree(end,1:dim), end_node(1:dim), world,dim)==0) ),
    flag = 1;
  end

end
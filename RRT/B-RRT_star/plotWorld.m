function plotWorld(world,path,dim,pathlength,time)
  % the first element is the north coordinate
  % the second element is the south coordinate

 if dim ==3
  axis([world.origincorner(1),world.endcorner(1),...
      world.origincorner(2), world.endcorner(2),...
      world.origincorner(3), world.endcorner(3)]);
  hold on

  for i=1:world.NumObstacles
      radius = world.radius{i};
      X = [world.cx(i) world.cx(i)+radius(1) world.cx(i) world.cx(i) world.cx(i)+radius(1) world.cx(i) world.cx(i)+radius(1) world.cx(i)+radius(1)];
      Y = [world.cy(i) world.cy(i) world.cy(i)+radius(2) world.cy(i) world.cy(i)+radius(2) world.cy(i)+radius(2) world.cy(i) world.cy(i)+radius(2)];
      Z = [world.cz(i) world.cz(i) world.cz(i) world.cz(i)+radius(3) world.cz(i)+radius(3) world.cz(i)+radius(3) world.cz(i)+radius(3) world.cz(i)];
      V = [X;Y;Z]';
      F = [1 2 7 4;1 3 6 4;1 2 8 3; 5 8 3 6;5 7 2 8;5 6 4 7];
      patch('Faces',F,'Vertices',V,'FaceColor',[0.5 0.5 0.5]);
      hold on
  end

  X = path(:,1);
  Y = path(:,2);
  Z = path(:,3);
  p = plot3(X,Y,Z);
  end
  set(p,'Color','black','LineWidth',3)
  xlabel('X axis');
  ylabel('Y axis');
  zlabel('Z axis');
  title(['Bidirectional RRT Star Algorithm with pathlength ' num2str(pathlength) 'and time' num2str(time) 's']);
end
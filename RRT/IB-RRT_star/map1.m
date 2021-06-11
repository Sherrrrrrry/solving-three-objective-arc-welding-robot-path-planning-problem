function [world, start_node, end_node] = map1(endcorner, origincorner)
    if (endcorner(1) <= origincorner(1)) | (endcorner(2) <= origincorner(2)) | (endcorner(3) <= origincorner(3)),
      disp('Not valid corner specifications!')
      world=[];
    end
    NumObstacles = 4;
    world.NumObstacles = NumObstacles;
    world.endcorner = endcorner;
    world.origincorner = origincorner;
 
    world.radius{1} = [25 20 60];
    world.cx(1) = 7;
    world.cy(1) = 8;
    world.cz(1) = 5;

    world.radius{2} = [5 50 40];
    world.cx(2) = 37;
    world.cy(2) = 18;
    world.cz(2) = 15;

    world.radius{3} = [34 38 40];
    world.cx(3) = 58;
    world.cy(3) = 50;
    world.cz(3) = 15;

    world.radius{4} = [30 38 25];
    world.cx(4) = 60;
    world.cy(4) = 50;
    world.cz(4) = 60;
       
    start_node = [3, 3, 3,0, 0, 0];
    end_node = [80, 75, 58,0, 0, 0];
end
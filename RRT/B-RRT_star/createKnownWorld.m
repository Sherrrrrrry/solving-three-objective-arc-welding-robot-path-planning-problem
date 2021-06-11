function [world NumObstacles] = createKnownWorld(endcorner, origincorner)
    % check to make sure that the region is nonempty
    if (endcorner(1) <= origincorner(1)) | (endcorner(2) <= origincorner(2)) | (endcorner(3) <= origincorner(3)),
      disp('Not valid corner specifications!')
      world=[];
    end
    NumObstacles = 4;
    world.NumObstacles = NumObstacles;
    world.endcorner = endcorner;
    world.origincorner = origincorner;
 
    world.radius{1} = [25 20 60];
    cx = 7;
    cy = 8;
    cz = 5;
    world.cx(1) = cx;
    world.cy(1) = cy;
    world.cz(1) = cz;

    world.radius{2} = [5 50 40];
    cx = 37;
    cy = 18;
    cz = 15;
    world.cx(2) = cx;
    world.cy(2) = cy;
    world.cz(2) = cz;

    world.radius{3} = [34 38 40];
    cx = 58;
    cy = 50;
    cz = 15;
    world.cx(3) = cx;
    world.cy(3) = cy;
    world.cz(3) = cz;

    world.radius{4} = [30 38 25];
    cx = 60;
    cy = 50;
    cz = 60;
    world.cx(4) = cx;
    world.cy(4) = cy;
    world.cz(4) = cz;
       

end
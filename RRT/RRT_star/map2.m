function [world, start_node, end_node] = map2(endcorner, origincorner)
    if (endcorner(1) <= origincorner(1)) | (endcorner(2) <= origincorner(2)) | (endcorner(3) <= origincorner(3)),
      disp('Not valid corner specifications!')
      world=[];
    end
    NumObstacles = 13;
    world.NumObstacles = NumObstacles;
    world.endcorner = endcorner;
    world.origincorner = origincorner;
    
    world.radius{1} = [15 5 40];
    world.cx(1) = 5;
    world.cy(1) = 15;
    world.cz(1) = 60;
    
    world.radius{2} = [80 5 100];
    world.cx(2) = 20;
    world.cy(2) = 15;
    world.cz(2) = 0;

    world.radius{3} = [5 70 100];
    world.cx(3) = 0;
    world.cy(3) = 15;
    world.cz(3) = 0;

    world.radius{4} = [5 65 100];
    world.cx(4) = 95;
    world.cy(4) = 20;
    world.cz(4) = 0;
       
    world.radius{5} = [90 5 50];
    world.cx(5) = 5;
    world.cy(5) = 80;
    world.cz(5) = 0;
    
    world.radius{6} = [75 5 10];
    world.cx(6) = 5;
    world.cy(6) = 80;
    world.cz(6) = 50;
    
    world.radius{7} = [5 5 50];
    world.cx(7) = 90;
    world.cy(7) = 80;
    world.cz(7) = 50;
    
    world.radius{8} = [85 5 40];
    world.cx(8) = 5;
    world.cy(8) = 80;
    world.cz(8) = 60;
    
    world.radius{9} = [15 5 100];
    world.cx(9) = 5;
    world.cy(9) = 40;
    world.cz(9) = 0;
    
    world.radius{10} = [15 5 100];
    world.cx(10) = 30;
    world.cy(10) = 40;
    world.cz(10) = 0;
    
    world.radius{11} = [15 5 100];
    world.cx(11) = 55;
    world.cy(11) = 40;
    world.cz(11) = 0;
    
    world.radius{12} = [15 5 100];
    world.cx(12) = 80;
    world.cy(12) = 40;
    world.cz(12) = 0;
    
    world.radius{13} = [40 5 100];
    world.cx(13) = 30;
    world.cy(13) = 60;
    world.cz(13) = 0;
    
    start_node = [20,3,30, 0, 0, 0];
    end_node = [80,97,70, 0, 0, 0];
end
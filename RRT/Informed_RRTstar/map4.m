function [world, start_node, end_node] = map4(endcorner, origincorner)
    if (endcorner(1) <= origincorner(1)) | (endcorner(2) <= origincorner(2)) | (endcorner(3) <= origincorner(3)),
      disp('Not valid corner specifications!')
      world=[];
    end
    NumObstacles = 18;
    world.NumObstacles = NumObstacles;
    world.endcorner = endcorner;
    world.origincorner = origincorner;
    
    world.radius{1} = [5 35 100];
    world.cx(1) = 10;
    world.cy(1) = 15;
    world.cz(1) = 0;
    
    world.radius{2} = [50 5 100];
    world.cx(2) = 20;
    world.cy(2) = 15;
    world.cz(2) = 0;

    world.radius{3} = [5 10 100];
    world.cx(3) = 65;
    world.cy(3) = 5;
    world.cz(3) = 0;

    world.radius{4} = [5 10 100];
    world.cx(4) = 40;
    world.cy(4) = 20;
    world.cz(4) = 0;
       
    world.radius{5} = [5 15 100];
    world.cx(5) = 30;
    world.cy(5) = 35;
    world.cz(5) = 0;
    
    world.radius{6} = [60 5 100];
    world.cx(6) = 35;
    world.cy(6) = 35;
    world.cz(6) = 0;
    
    world.radius{7} = [5 10 100];
    world.cx(7) = 55;
    world.cy(7) = 40;
    world.cz(7) = 0;
    
    world.radius{8} = [5 15 100];
    world.cx(8) = 80;
    world.cy(8) = 20;
    world.cz(8) = 0;
    
    world.radius{9} = [5 20 100];
    world.cx(9) = 80;
    world.cy(9) = 45;
    world.cz(9) = 0;
    
    world.radius{10} = [40 5 100];
    world.cx(10) = 5;
    world.cy(10) = 60;
    world.cz(10) = 0;
    
    world.radius{11} = [5 15 100];
    world.cx(11) = 45;
    world.cy(11) = 50;
    world.cz(11) = 0;
    
    world.radius{12} = [5 20 100];
    world.cx(12) = 50;
    world.cy(12) = 60;
    world.cz(12) = 0;
    
    world.radius{13} = [10 5 100];
    world.cx(13) = 55;
    world.cy(13) = 60;
    world.cz(13) = 0;
    
    world.radius{14} = [15 5 100];
    world.cx(14) = 80;
    world.cy(14) = 70;
    world.cz(14) = 0;
    
    world.radius{15} = [20 5 100];
    world.cx(15) = 65;
    world.cy(15) = 80;
    world.cz(15) = 0;
    
    world.radius{16} = [15 5 100];
    world.cx(16) = 5;
    world.cy(16) = 80;
    world.cz(16) = 0;
    
    world.radius{17} = [15 5 100];
    world.cx(17) = 15;
    world.cy(17) = 75;
    world.cz(17) = 0;
    
    world.radius{18} = [5 10 100];
    world.cx(18) = 30;
    world.cy(18) = 80;
    world.cz(18) = 0;
    
    start_node = [10,10,75, 0, 0, 0];
    end_node = [95,80,15, 0, 0, 0];
end
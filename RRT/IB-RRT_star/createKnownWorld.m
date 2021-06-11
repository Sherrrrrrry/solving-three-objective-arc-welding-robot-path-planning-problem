
% 输入：障碍物数量NumObstacles，环境最大坐标endcorner（100,100），最小坐标origincorner（0,0），维度dim(假设为2)
% 输出：world结构体，存放着NumObstacles，endcorner，origincorner以及各障碍物的中心点坐标矩阵cx,cy，半径矩阵radius

function world = createKnownWorld(NumObstacles,endcorner, origincorner,dim)
    %% 2维情况下
    if dim == 2
        % check to make sure that the region is nonempty
        if (endcorner(1) <= origincorner(1)) || (endcorner(2) <= origincorner(2))  % 确保极端坐标有效
          disp('Not valid corner specifications!');
          world=[];
        else
        % create world data structure
        world.NumObstacles = NumObstacles;
        world.endcorner = endcorner;
        world.origincorner = origincorner;

        % create NumObstacles
        maxRadius = 10;
        world.radius(1) = maxRadius; % 第1个障碍物（圆）
        cx = 50;
        cy = 50;
        world.cx(1) = cx;
        world.cy(1) = cy;

        world.radius(2) = maxRadius; % 第2个障碍物（圆）
        cx = 75;
        cy = 25;
        world.cx(2) = cx;
        world.cy(2) = cy;

        world.radius(3) = maxRadius; % 第3个障碍物（圆）
        cx = 25;
        cy = 75;
        world.cx(3) = cx;
        world.cy(3) = cy;

        world.radius(4) = maxRadius; % 第4个障碍物（圆）
        cx = 25;
        cy = 25;
        world.cx(4) = cx;
        world.cy(4) = cy;

        world.radius(5) = maxRadius; % 第5个障碍物（圆）
        cx = 75;
        cy = 75;
        world.cx(5) = cx;
        world.cy(5) = cy;
	end
  %% 3维情况下
    elseif dim == 3
        % check to make sure that the region is nonempty
        if (endcorner(1) <= origincorner(1)) || (endcorner(2) <= origincorner(2)) || (endcorner(3) <= origincorner(3))
          disp('Not valid corner specifications!');
          world=[];
        else
        % create world data structure
        world.NumObstacles = NumObstacles;
        world.endcorner = endcorner;
        world.origincorner = origincorner;

        % create NumObstacles
        maxRadius = 10;
        world.radius(1) = maxRadius; % 第1个障碍物（球体）
        cx = 50;
        cy = 50;
        cz = 50;
        world.cx(1) = cx;
        world.cy(1) = cy;
        world.cz(1) = cz;

        world.radius(2) = maxRadius; % 第2个障碍物（球体）
        cx = 25;
        cy = 25;
        cz = 25;
        world.cx(2) = cx;
        world.cy(2) = cy;
        world.cz(2) = cz;

        world.radius(3) = maxRadius; % 第3个障碍物（球体）
        cx = 75;
        cy = 75;
        cz = 75;
        world.cx(3) = cx;
        world.cy(3) = cy;
        world.cz(3) = cz;

        world.radius(4) = maxRadius; % 第4个障碍物（球体）
        cx = 25;
        cy = 50;
        cz = 75;
        world.cx(4) = cx;
        world.cy(4) = cy;
        world.cz(4) = cz;

        world.radius(5) = maxRadius; % 第5个障碍物（球体）
        cx = 75;
        cy = 50;
        cz = 25;
        world.cx(5) = cx;
        world.cy(5) = cy;
        world.cz(5) = cz;
     end
   end
end
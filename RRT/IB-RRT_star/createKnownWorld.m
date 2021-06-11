
% ���룺�ϰ�������NumObstacles�������������endcorner��100,100������С����origincorner��0,0����ά��dim(����Ϊ2)
% �����world�ṹ�壬�����NumObstacles��endcorner��origincorner�Լ����ϰ�������ĵ��������cx,cy���뾶����radius

function world = createKnownWorld(NumObstacles,endcorner, origincorner,dim)
    %% 2ά�����
    if dim == 2
        % check to make sure that the region is nonempty
        if (endcorner(1) <= origincorner(1)) || (endcorner(2) <= origincorner(2))  % ȷ������������Ч
          disp('Not valid corner specifications!');
          world=[];
        else
        % create world data structure
        world.NumObstacles = NumObstacles;
        world.endcorner = endcorner;
        world.origincorner = origincorner;

        % create NumObstacles
        maxRadius = 10;
        world.radius(1) = maxRadius; % ��1���ϰ��Բ��
        cx = 50;
        cy = 50;
        world.cx(1) = cx;
        world.cy(1) = cy;

        world.radius(2) = maxRadius; % ��2���ϰ��Բ��
        cx = 75;
        cy = 25;
        world.cx(2) = cx;
        world.cy(2) = cy;

        world.radius(3) = maxRadius; % ��3���ϰ��Բ��
        cx = 25;
        cy = 75;
        world.cx(3) = cx;
        world.cy(3) = cy;

        world.radius(4) = maxRadius; % ��4���ϰ��Բ��
        cx = 25;
        cy = 25;
        world.cx(4) = cx;
        world.cy(4) = cy;

        world.radius(5) = maxRadius; % ��5���ϰ��Բ��
        cx = 75;
        cy = 75;
        world.cx(5) = cx;
        world.cy(5) = cy;
	end
  %% 3ά�����
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
        world.radius(1) = maxRadius; % ��1���ϰ�����壩
        cx = 50;
        cy = 50;
        cz = 50;
        world.cx(1) = cx;
        world.cy(1) = cy;
        world.cz(1) = cz;

        world.radius(2) = maxRadius; % ��2���ϰ�����壩
        cx = 25;
        cy = 25;
        cz = 25;
        world.cx(2) = cx;
        world.cy(2) = cy;
        world.cz(2) = cz;

        world.radius(3) = maxRadius; % ��3���ϰ�����壩
        cx = 75;
        cy = 75;
        cz = 75;
        world.cx(3) = cx;
        world.cy(3) = cy;
        world.cz(3) = cz;

        world.radius(4) = maxRadius; % ��4���ϰ�����壩
        cx = 25;
        cy = 50;
        cz = 75;
        world.cx(4) = cx;
        world.cy(4) = cy;
        world.cz(4) = cz;

        world.radius(5) = maxRadius; % ��5���ϰ�����壩
        cx = 75;
        cy = 50;
        cz = 25;
        world.cx(5) = cx;
        world.cy(5) = cy;
        world.cz(5) = cz;
     end
   end
end
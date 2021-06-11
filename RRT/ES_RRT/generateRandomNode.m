function node=generateRandomNode(world,dim)

if dim ==2;
% randomly pick configuration
px       = (world.endcorner(1)-world.origincorner(1))*rand;
py       = (world.endcorner(2)-world.origincorner(2))*rand;

chi      = 0;
cost     = 0;
node     = [px, py, chi, cost, 0];

% check collision with obstacle
while collision(node, node, world,dim),
px       = (world.endcorner(1)-world.origincorner(1))*rand;
py       = (world.endcorner(2)-world.origincorner(2))*rand;

chi      = 0;
cost     = 0;
node     = [px, py, chi, cost, 0];
end

elseif dim ==3;
% randomly pick configuration
px       = (world.endcorner(1)-world.origincorner(1))*rand;
py       = (world.endcorner(2)-world.origincorner(2))*rand;
pz       = (world.endcorner(3)-world.origincorner(3))*rand;

chi      = 0;
cost     = 0;
node     = [px, py, pz, chi, cost, 0];

% check collision with obstacle
while collision(node, node, world,dim),
px       = (world.endcorner(1)-world.origincorner(1))*rand;
py       = (world.endcorner(2)-world.origincorner(2))*rand;
pz       = (world.endcorner(3)-world.origincorner(3))*rand;

chi      = 0;
cost     = 0;
node     = [px, py, pz, chi, cost, 0];
end

end

end
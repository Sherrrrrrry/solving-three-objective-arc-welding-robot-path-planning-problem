
% 输出：路径距离最短且无碰撞的树节点的坐标信息
function x_min = ChooseBestParent(Ls,map)
x_min=[];
[~,~,n]=size(Ls);
for i=1:n
    traj=Ls{1,3,i}; % 获取X_near中第i个树节点与x_new的路径
    if checkPath(double(int32(traj(1,:))),double(int32(traj(end,:))),map) %无碰撞
        x_min=Ls{1,1,i};
        break; % 找到路径距离最短且无碰撞的树节点后即可跳出循环
    end
end

end


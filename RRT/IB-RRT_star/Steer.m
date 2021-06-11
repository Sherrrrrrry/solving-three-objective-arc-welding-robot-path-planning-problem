% 输入：X_near和x_new均只有一个坐标，step
% 输出：traj = [X_near;X_near]，为step*2的矩阵
function traj=Steer(X_near,x_new,step)
traj=zeros(step,2);
x=linspace(X_near(1),x_new(1),step); % 产生以X_near(1)为起始点，x_new(1)为终止点的step个间隔均匀的数，若step为2，则只取X_near(1)、x_new(1)两个数
y=linspace(X_near(2),x_new(2),step); % 
traj(:,1)=x'; % '表示转置，把行向量转换成列向量
traj(:,2)=y';
end


% ���룺X_near��x_new��ֻ��һ�����꣬step
% �����traj = [X_near;X_near]��Ϊstep*2�ľ���
function traj=Steer(X_near,x_new,step)
traj=zeros(step,2);
x=linspace(X_near(1),x_new(1),step); % ������X_near(1)Ϊ��ʼ�㣬x_new(1)Ϊ��ֹ���step��������ȵ�������stepΪ2����ֻȡX_near(1)��x_new(1)������
y=linspace(X_near(2),x_new(2),step); % 
traj(:,1)=x'; % '��ʾת�ã���������ת����������
traj(:,2)=y';
end


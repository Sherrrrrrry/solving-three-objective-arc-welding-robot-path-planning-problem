
% �����·���������������ײ�����ڵ��������Ϣ
function x_min = ChooseBestParent(Ls,map)
x_min=[];
[~,~,n]=size(Ls);
for i=1:n
    traj=Ls{1,3,i}; % ��ȡX_near�е�i�����ڵ���x_new��·��
    if checkPath(double(int32(traj(1,:))),double(int32(traj(end,:))),map) %����ײ
        x_min=Ls{1,1,i};
        break; % �ҵ�·���������������ײ�����ڵ�󼴿�����ѭ��
    end
end

end


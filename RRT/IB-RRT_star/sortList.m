
% ������X_near������Ϣ��·�������Լ��켣������Ls����·�����ȴ�С��������󷵻ظ�sorted_Ls
% ����X_near��i�����ڵ㣬��sorted_Ls�Ĵ�СΪ��1,3,i������ʾi��3�е����飬��1��2��3�зֱ𴢴�������Ϣ��·�����ȡ��켣
function sorted_Ls = sortList(Ls)
[~,~,n]=size(Ls);
sorted_Ls = cell(1,3,n);
cost=zeros(n,1);
for i=1:n
    cost(i)=Ls{1,2,i}; % ��X_near�е�i�����ڵ��RRTree-X_near-x_new��·��������ȡ��������n�������з���
end
[~,index]=sort(cost); % ���մ�С��������indexΪ������������������cost�е��к�
for i=1:n
    for j=1:3
        sorted_Ls{1,j,i}=Ls{1,j,index(i)};
    end
end
end


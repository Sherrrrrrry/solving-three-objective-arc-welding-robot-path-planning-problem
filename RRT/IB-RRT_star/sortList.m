
% 将包含X_near坐标信息、路径长度以及轨迹的数组Ls按照路径长度从小到大排序后返回给sorted_Ls
% 由于X_near有i个树节点，故sorted_Ls的大小为（1,3,i），表示i行3列的数组，第1、2、3列分别储存坐标信息、路径长度、轨迹
function sorted_Ls = sortList(Ls)
[~,~,n]=size(Ls);
sorted_Ls = cell(1,3,n);
cost=zeros(n,1);
for i=1:n
    cost(i)=Ls{1,2,i}; % 将X_near中第i个树节点的RRTree-X_near-x_new的路径长度提取出来，共n个，按列放置
end
[~,index]=sort(cost); % 按照从小到大排序，index为结果的索引，即结果在cost中的行号
for i=1:n
    for j=1:3
        sorted_Ls{1,j,i}=Ls{1,j,index(i)};
    end
end
end


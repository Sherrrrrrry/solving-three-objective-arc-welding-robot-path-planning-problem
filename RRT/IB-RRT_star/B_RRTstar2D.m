% ? Rahul Kala, IIIT Allahabad, Creative Commons Attribution-ShareAlike 4.0 International License. 
% The use of this code, its parts and all the materials in the text; creation of derivatives and their publication; and sharing the code publically is permitted without permission. 

% Please cite the work in all materials as: R. Kala (2014) Code for Robot Path Planning using Rapidly-exploring Random Trees, Indian Institute of Information Technology Allahabad, Available at: http://rkala.in/codes.html

% ԭ����RRT�����ڽ����޸�Ϊ bi-RRT*
% �ο����ģ�
% ��Intelligent bidirectional rapidly-exploring random trees for optimal
% motion planning in complex cluttered environments��
% Algrithm 5: bi-RRT*
% ����:�� ��
% 2019/9/8

clear;
close all;
for N = 1:31 % ����30�ν����ȥ���״Σ������棺·������+����ʱ��
tic;
%% set parameters
% map=imbinarize(imread('map1.bmp')); %����һ�������һ��
map=im2bw(imread('map8.bmp')); % imread(filename.fmt)��ȡ�ļ���Ϊfilename,��ʽΪfmt��ͼ�����ݣ����Ϊͼ������ؾ�����500*500��
                               % im2bw()��ͼ��ת��ɶ�����ͼ��,���ֻ�кڰ���ɫ��0Ϊ��ɫ���򣬼��ϰ�������1Ϊ��ɫ���򣬼����ɿռ�
                               % mapΪ500*500����0��1��ɵ��߼�����
source=[10 10]; % ��ʼ����㣬��Ӧ�ķֱ���y���x�ᣬҲ��������ͺ���
goal=[490 490]; % ��ֹ�����
stepsize=20; % ��������ʼ�����ֹ��ᡢ������֮��ӦΪ�����ı�����������������������ʼ�����ֹ�㣨����ʵ��ľ��飩
disTh=stepsize; % ���յ�·����һ���պý���ʼ�����ֹ���������������ֻҪ��ֹ����������Ľڵ�֮��ľ���С��disTH�����ֵ������Ϊ�ҵ������·����
                % ��Ȼ��õ��������ʼ�����ֹ��պ��������������������õĲ�����С�й�
maxFailedAttempts = 100000;
display=true; % display of RRTree 

if ~feasiblePoint(source,map), error('source lies on an obstacle or outside map'); end
if ~feasiblePoint(goal,map), error('goal lies on an obstacle or outside map'); end
% if display, 
%     imshow(map);
%     rectangle('position',[1 1 size(map)-1],'edgecolor','k'); 
% end
RRTree1=double([source -1]); % First RRT rooted at the source, representation node and parent index
RRTree2=double([goal -1]); % Second RRT rooted at the goal, representation node and parent index
counter=0;
% hold on;
tree1ExpansionFail=false; % sets to true if expansion after set number of attempts fails
tree2ExpansionFail=false; % sets to true if expansion after set number of attempts fails
% scatter(10,10,50,[1 0 0],'filled');%scatter(�����꣬�����꣬Բ�Ĵ�С����ɫ��'filled'��ʾʵ��Բ)��������ά��ɢ��ͼ
% scatter(490,490,50,[0 1 0],'filled');%����[1 0 0]��[0 1 0]�ֱ��ʾ��ԭɫ�еĺ�ɫ����ʼ�㣩����ɫ����ֹ�㣩����ԭɫ��0��1��ɵ�3*1�����ʾ����8��

%% �㷨��ʼѭ��
while ~tree1ExpansionFail || ~tree2ExpansionFail  % loop to grow RRTs
    %% RRTree1��RRTree2�Ⱥ������չ����RRTree1��ͨ�������õ�һ�����ڵ㣬Ȼ��RRTree2ͨ����һ�������õ���һ�����ڵ㡣
    if ~tree1ExpansionFail 
        [RRTree1,pathFound,tree1ExpansionFail]=rrt_starExtend(RRTree1,RRTree2,goal,stepsize,maxFailedAttempts,disTh,map); % RRT 1 expands from source towards goal
        % ��ʾRRTree1��չ�Ĺ���
%         if ~tree1ExpansionFail && isempty(pathFound) && display
%             line([RRTree1(end,2);RRTree1(RRTree1(end,3),2)],[RRTree1(end,1);RRTree1(RRTree1(end,3),1)],'color','b');
%             counter=counter+1;
%             M(counter)=getframe;
%         end
    end
    
    if ~tree2ExpansionFail
        [RRTree2,pathFound,tree2ExpansionFail]=rrt_starExtend(RRTree2,RRTree1,source,stepsize,maxFailedAttempts,disTh,map); % RRT 2 expands from goal towards source
        if ~isempty(pathFound)
            pathFound(3:4)=pathFound(4:-1:3); % ����pathFound������RRTree1��RRTree2���м�ڵ������λ��˳��Ȼ��RRTree2�����һ���ڵ����˳��������RRTree1��֮�����RRTree1�ҵ����·����
        end % path found
        % ��ʾRRTree2��չ�Ĺ���
%         if ~tree2ExpansionFail && isempty(pathFound) && display
%             line([RRTree2(end,2);RRTree2(RRTree2(end,3),2)],[RRTree2(end,1);RRTree2(RRTree2(end,3),1)],'color','r');
%             counter=counter+1;
%             M(counter)=getframe;
%         end 
    end
    
    if ~isempty(pathFound) % path found
        path=[pathFound(1,1:2)]; % compute path
        prev=pathFound(1,3); % add nodes from RRT 1 first
        while prev>0
            path=[RRTree1(prev,1:2);path];
            prev=RRTree1(prev,3);
        end
        prev=pathFound(1,4); % then add nodes from RRT 2
        while prev>0
            path=[path;RRTree2(prev,1:2)];
            prev=RRTree2(prev,3);
        end
        break;
    end
end

if size(pathFound,1)<=0
    error('no path found. maximum attempts reached'); 
end

pathLength1=0;
for i=1:length(path)-1 % length()��������������Ľϴ�ֵ�����ڵ�ĸ���
    pathLength1=pathLength1+distanceCost(path(i,1:2),path(i+1,1:2)); 
end
t = toc;
save_pathLength1(N,:) = pathLength1;
save_time(N,:) = t;
end
save_pathLength1(1,:) = [];
save_time(1,:) = [];

mean_pathLength1 = mean(save_pathLength1);
min_pathLength1 = min(save_pathLength1);
max_pathLength1 = max(save_pathLength1);
mean_time = mean(save_time);
fprintf('mean_pathLength1=%d \nmin_pathLength1=%d \nmax_pathLength1=%d \nmean_time=%d  \n\n', mean_pathLength1 ,min_pathLength1 ,max_pathLength1 ,mean_time);

% fprintf('processing time=%d \nPath Length=%d \n',toc,pathLength); %��ʾ��ʱ��·������
% line(path(:,2),path(:,1),'LineWidth',2.5,'Color',[0 1 0]);
% hold on;
% counter=counter+1;
% M(counter)=getframe;
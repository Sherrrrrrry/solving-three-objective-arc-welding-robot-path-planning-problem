%% ����30��9-13
% load('30run2_9_13.mat');
% path = Path.Path;
% length = Path.save_pathLength1;
% time = Path.save_time;
% its = Path.save_its;

% load('22_12.mat');%30run_12_22

% for j = 1:30 
%     path = cell2mat(Path(j));
%     pathLength1(j) = 0;
%     for i = 1:size(path,1)-1
%         pathLength1(j) = pathLength1(j) + norm(path(i,1:3)-path(i+1,1:3));
%     end
% end
%    [~,k]=sort(pathLength1);             
% path = cell2mat(Path(1));
% Path.Path = [Path.Path,path];
% Path.save_pathLength1 = [Path.save_pathLength1;length];
% Path.save_time = [Path.save_time;time];
% Path.save_its = [Path.save_its;its];
% save('30run1_9_13.mat','Path');


%% ��ʼ�㷭ת·��
% load('1_13.mat');
% % path = flipud(cell2mat(Path.Path));
% path = flipud(cell2mat(Path));
% % Path = [];
% Path{1} = path;
% save( '13_1.mat', 'Path');


% mean_pathLength1 = mean(Path.save_pathLength1);
% var_pathLength1 = var(Path.save_pathLength1);
% [min_pathLength1,min_pathIndex] = min(Path.save_pathLength1);
% min_path = Path.Path{min_pathIndex};
% max_pathLength1 = max(Path.save_pathLength1);
% mean_time = mean(Path.save_time);
% mean_its = mean(Path.save_its);
% fprintf('mean_pathLength1=%d \nvar_pathLength1=%d  \nmin_pathLength1=%d \nmax_pathLength1=%d \nmean_time=%d  \nmean_tis =%d  \n\n', mean_pathLength1 ,var_pathLength1, min_pathLength1 ,max_pathLength1 ,mean_time,mean_its);


% ����������ͼ����ɫ��
% Path = './';                   % �������ݴ�ŵ��ļ���·��
% File = dir(fullfile(Path,'*.stl'));  % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.txt�ļ���������Ϣ
% FileNames = {File.name}';            % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1��
% hold on;
% fv = stlread(FileNames{5}); % ��ȡstl�ļ����������θ��Ǳ��棬�õ���������faces�������ζ���vertices����
% mean_dif = [1566.88081496667,1198.42971853333,-20.9673186333333];
% fv.vertices = [-fv.vertices(:,1)+mean_dif(1,1).*ones(size(fv.vertices,1),1) -fv.vertices(:,2)+mean_dif(1,2).*ones(size(fv.vertices,1),1) fv.vertices(:,3)+mean_dif(1,3).*ones(size(fv.vertices,1),1)];
% patch(fv,'FaceColor','y','EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15);
% hold on;
% % start_cord = weldpoint_adjust(start,:);  %��ʼ�㣬��ɫ
% % goal_cord = weldpoint_adjust(goal,:);  %��ֹ�㣬��ɫ
% start_cord = path(1,1:3);
% goal_cord = path(end,1:3);
% start_node = [start_cord,0,0,0]; %��dim+1Ϊ1��ʾ�õ�����յ������dim+2��Ÿõ굽��ʼ������·���ܳ��ȣ�dim+3����丸�ڵ��������
% end_node = [goal_cord,0,0,0];
% scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[0 1 0], 'filled');
% scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[1 0 0], 'filled');
% hold on
% scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[1 0 0],'filled');%scatter(�����꣬�����꣬Բ�Ĵ�С����ɫ��'filled'��ʾʵ��Բ)��������ά��ɢ��ͼ
% scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[0 1 0],'filled');%����[1 0 0]��[0 1 0]�ֱ��ʾ��ԭɫ�еĺ�ɫ����ʼ�㣩����ɫ����ֹ�㣩����ԭɫ��0��1��ɵ�3*1�����ʾ����8��
% hold on
% X = path(:,1);
% Y = path(:,2);
% Z = path(:,3);
% p = plot3(X,Y,Z);
% set(p,'Color',[1 0 1],'LineWidth',2);

load('2_26.mat');
Path = Path.Path;
% Path =[];
% Path = path;
save( '2_26.mat', 'Path');


clear
clc;
close all;
%% ��������
load('weldpoint_adjust.mat') % ����˵�����
load('G_ob_simply.mat'); % ȫ����դ�񣨻�׼������+���߳���
GP = 5; % դ���СΪ5
rob = createRobot(); % ����������
cylinderRadius = 0; % cylinderRadius = [150 80 80 100 80 80]; % ��Բ���彫��е�۰�Χ��cylinderRadiusΪ��Բ����İ뾶

%% ��ͼ
% for i=1:size(G_ob_simply,1) % ��ʾAABB����(��ɫ)
%     patch(obsgen(G_ob_simply(i,:))); % obsgen()Ϊ��Χ�к�����obs�Ĵ�СΪN*6��ǰ��άΪ���������꣬����άΪ��Χ�����ߵĳ���
%     hold on;
% end
% label = {'1','2','3','4','5','6','7','8','9','10',... %������
%     '11','12','13','14','15','16','17','18','19','20',...
%     '21','22','23','24','25','26','27','28','29','30'};
% for i = 1:size(weldpoint_adjust_adjust,1) % ��ʾ���к��㣨��ɫ��
%     hold on
%     scatter3(weldpoint_adjust_adjust(i,1),weldpoint_adjust_adjust(i,2),weldpoint_adjust_adjust(i,3),30,[0 1 0],'filled');%����[1 0 0]��[0 1 0]�ֱ��ʾ��ԭɫ�еĺ�ɫ����ʼ�㣩����ɫ����ֹ�㣩����ԭɫ��0��1��ɵ�3*1�����ʾ����8��
% %     text(weldpoint_adjust_adjust(i,1),weldpoint_adjust_adjust(i,2)+5,weldpoint_adjust_adjust(i,3),label{i});
% end
% ����������ͼ����ɫ��
Path = './';                   % �������ݴ�ŵ��ļ���·��
File = dir(fullfile(Path,'*.stl'));  % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.txt�ļ���������Ϣ
FileNames = {File.name}';            % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1��
hold on;
fv = stlread(FileNames{5}); % ��ȡstl�ļ����������θ��Ǳ��棬�õ���������faces�������ζ���vertices����
mean_dif = [1566.88081496667,1198.42971853333,-20.9673186333333];
fv.vertices = [-fv.vertices(:,1)+mean_dif(1,1).*ones(size(fv.vertices,1),1) -fv.vertices(:,2)+mean_dif(1,2).*ones(size(fv.vertices,1),1) fv.vertices(:,3)+mean_dif(1,3).*ones(size(fv.vertices,1),1)];
patch(fv,'FaceColor',[0.8 0.8 0.8],'EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15);

weld = [9 5 10 11 4 3 2 1 15 14 8 13 12 7 6];
joint = [ 18 9; 10 19; 20 21; 22 7; 8 5; 6 4; 3 2; 1 30; 29 28; 27 15; 16 25; 26 23; 24 14; 13 12; 11 17];
path_whole =[];
for i = 1:15
    start = joint(i,1);
    goal = joint(i,2);
    filename = strcat(num2str(start),'_',num2str(goal),'.mat');
    load(filename);
    path = cell2mat(Path);
%     path(end,:)=[];
    path_whole = [path_whole;path];
end
path_whole = path_whole(:,1:3);
point = intersect(path_whole,weldpoint_adjust,'rows');
hold on
scatter3(path_whole(:,1),path_whole(:,2),path_whole(:,3),30,[1 1 0], 'filled');
hold on
scatter3(weldpoint_adjust(joint(:,1),1),weldpoint_adjust(joint(:,1),2),weldpoint_adjust(joint(:,1),3),30,[1 0 0], 'filled'); % Ending point��ɫ
scatter3(weldpoint_adjust(joint(:,2),1),weldpoint_adjust(joint(:,2),2),weldpoint_adjust(joint(:,2),3),30,[0 1 0], 'filled'); % Starting point��ɫ
% scatter3(point(:,1),point(:,2),point(:,3),30,[0 1 0], 'filled');
hold on
X = path_whole(:,1);
Y = path_whole(:,2);
Z = path_whole(:,3);
p = plot3(X,Y,Z,'--');
set(p,'Color',[0.82 0.41 0.12],'LineWidth',2);%��ɫ���ɵ�
hold on
spot = [1,2;3,4;5,6;7,8;9,10;11,12;13,14;15,16;17,18;19,20;21,22;23,24;25,26;27,28;29,30];
for i = 1:15
    line = [weldpoint_adjust(spot(i,1),:);weldpoint_adjust(spot(i,2),:)];
    q = plot3(line(:,1),line(:,2),line(:,3));
    set(q,'Color',[0 0 0],'LineWidth',2);
    hold on
end
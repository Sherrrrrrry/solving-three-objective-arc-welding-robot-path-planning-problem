% ES-RRT*Ѱ��ǰ�����ܵı���·��---���ڱ༭
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
patch(fv,'FaceColor','y','EdgeColor','none','FaceLighting','gouraud','AmbientStrength', 0.15);

%% ��֤���к���ĩ��λ���Լ��ؽ��Ƿ���ײ�������ײ���Կ��ǵ�����Ӧ��װ�оߡ�դ�񻯹����Ļ�׼�������Լ�΢�����������
for i = 1:size(weldpoint_adjust,1)
    xGoal = weldpoint_adjust(i,:); %Ŀ��λ��
    qGoal = rob.ikine(transl(xGoal),zeros(1,6),[1,1,1,0,0,0]);%����λ����Ϣ��������⣨�ؽڽǶȣ�
    collision_end = endCollison(G_ob_simply,xGoal); %ĩ����ײ��� 1����ײ 0������ײ
    if (collision_end)
        j = i
    end
    % ��麸���Ƿ�ɴ�
    collision_arm = armCollison(rob, qGoal, G_ob_simply, cylinderRadius);
    if (collision_arm)
        i
    end
end

Path = {};
for N = 1:30 %����30�ν�������棬·������+����ʱ��
    N
    for start = 9
        for goal = 13
%             start
%             goal
            if ((start==goal)||(start==1&&goal==2)||(start==3&&goal==4)||(start==5&&goal==6)||(start==7&&goal==8)||(start==9&&goal==10)||(start==11&&goal==12)||(start==13&&goal==14)...
                    ||(start==15&&goal==16)||(start==17&&goal==18)||(start==19&&goal==20)||(start==21&&goal==22)||(start==23&&goal==24)||(start==25&&goal==26)||(start==27&&goal==28)||(start==29&&goal==30)...
                    ||(start==2&&goal==1)||(start==4&&goal==3)||(start==6&&goal==5)||(start==8&&goal==7)||(start==10&&goal==9)||(start==12&&goal==11)||(start==14&&goal==13)||(start==16&&goal==15)...
                    ||(start==18&&goal==17)||(start==20&&goal==19)||(start==22&&goal==21)||(start==24&&goal==23)||(start==26&&goal==25)||(start==28&&goal==27)||(start==30&&goal==29))
                continue;
            end
                        filename = strcat('30run2_',num2str(start),'_',num2str(goal),'.mat');
%             filename = strcat(num2str(start),'_',num2str(goal),'.mat');
            tic; %��ʼ��ʱ
            % ��������
            dim = 3; %3D
            radius = 40; %���½ڵ�ʱѡ���Բ�η�Χ�뾶
            segmentLength = 20; %��չ������ͬstepsize��
            origincorner = [0 -1600 -200]; %��Ϊ����Space�߽�
            endcorner = [2000 2000 1000];
            
            % ��֤���к����ĩ��λ���Լ����ؽ��Ƿ���ײ�������ײ���Ե�����Ӧ��װ�оߡ�դ�񻯹����Ļ�׼�������Լ�΢�����������
            for i = 1:size(weldpoint_adjust,1)
                xGoal = weldpoint_adjust(i,:); %Ŀ��λ��
                qGoal = rob.ikine(transl(xGoal),zeros(1,6),[1,1,1,0,0,0]); %����λ����Ϣ��������⣨�ؽڽǶȣ�
                collision_end = endCollison(G_ob_simply,xGoal); %ĩ����ײ��� 1����ײ 0������ײ
                if (collision_end)
                    j = i
                end
                % ��麸���Ƿ�ɴ�
                collision_arm = armCollison(rob, qGoal, G_ob_simply, cylinderRadius);
                if (collision_arm)
                    i
                end
            end
            
            start_cord = weldpoint_adjust(start,:);  %��ʼ�㣬��ɫ
            goal_cord = weldpoint_adjust(goal,:);  %��ֹ�㣬��ɫ
            start_node = [start_cord,0,0,0]; %��dim+1Ϊ1��ʾ�õ�����յ������dim+2��Ÿõ굽��ʼ������·���ܳ��ȣ�dim+3����丸�ڵ��������
            end_node = [goal_cord,0,0,0];
            
            counter = 0;
            hold on;
            scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[1 0 0], 'filled');
            scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[0 1 0], 'filled');
            kk=0;
            %% ��ʼ��չ
            % �ж���ʼ�����ֹ���Ƿ��ܹ�ֱ�����ӣ�norm��������ŷ�Ͼ��룬pathCollision()���Ϊ0��ʾ����ײ��1��ʾ����ײ
            if ~pathCollision(start_node,end_node,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,dim)
                path = [start_node; end_node];
                tree = path;
                its = 0;
            else
                its = 0;
                numPaths = 0;
                flag = 0;
                tree = start_node;
                while numPaths < 1
                    % tree��չ
                    [tree,flag] = extendTree(tree,end_node,segmentLength,radius,origincorner,endcorner,rob,G_ob_simply,cylinderRadius,flag,dim);
                    numPaths = numPaths + flag; %ֱ�����һ���ڵ����յ������� flag=1����ʾ�ҵ�ȫ��·��
                    its = its + 1;
                    if (numPaths)
                        path = findMinimumPath(tree,end_node,dim);
                        %                         path(end,:) = [];
                        break;
                    end
%                     t = toc;
%                     if toc > 1800
%                         kk =1;
%                         break;
%                     end
                end
            end
            if kk <1
                % �����Ż�
                path = second_opt(path,dim,segmentLength,rob,G_ob_simply,origincorner,endcorner,cylinderRadius);
                
                pathLength1 = 0;
                for i = 1:size(path,1)-1
                    pathLength1 = pathLength1 + norm(path(i,1:3)-path(i+1,1:3));
                end
                
                %��ʱ����
                            t = toc;
%                 Path{N} = path;
                Path.Path{N} = path;
                Path.save_pathLength1(N,:) = pathLength1;
                Path.save_time(N,:) = t;
                Path.save_its(N,:) = its;
                save(filename, 'Path');
            else
                continue;
            end
        end
    end
end

mean_pathLength1 = mean(save_pathLength1);
var_pathLength1 = var(save_pathLength1);
[min_pathLength1,min_pathIndex] = min(save_pathLength1);
min_path = Path{min_pathIndex};
max_pathLength1 = max(save_pathLength1);
mean_time = mean(save_time);
mean_its = mean(save_its);
fprintf('mean_pathLength1=%d \nvar_pathLength1=%d  \nmin_pathLength1=%d \nmax_pathLength1=%d \nmean_time=%d  \nmean_tis =%d  \n\n', mean_pathLength1 ,var_pathLength1, min_pathLength1 ,max_pathLength1 ,mean_time,mean_its);
% 
% %  ��ͼ����õ�·��ͼ
% hold on
% scatter3(start_cord(:,1),start_cord(:,2),start_cord(:,3),30,[1 0 0],'filled');%scatter(�����꣬�����꣬Բ�Ĵ�С����ɫ��'filled'��ʾʵ��Բ)��������ά��ɢ��ͼ
% scatter3(goal_cord(:,1),goal_cord(:,2),goal_cord(:,3),30,[0 1 0],'filled');%����[1 0 0]��[0 1 0]�ֱ��ʾ��ԭɫ�еĺ�ɫ����ʼ�㣩����ɫ����ֹ�㣩����ԭɫ��0��1��ɵ�3*1�����ʾ����8��
% hold on
% X = min_path(:,1);
% Y = min_path(:,2);
% Z = min_path(:,3);
% p = plot3(X,Y,Z);
% set(p,'Color',[1 0 1],'LineWidth',2);
            
            
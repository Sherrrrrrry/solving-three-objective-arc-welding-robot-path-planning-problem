%% �ѿ�������ϵ������ܺ�
clc
clear
load weldpoint; % ����ĺ�������
startup_rvc;
Path = './';                   % �������ݴ�ŵ��ļ���·��
File = dir(fullfile(Path,'*.mat'));  % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.mat�ļ���������Ϣ
FileNames = {File.name}';            % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1��
clear L
%% ����������ģ��
% %           th    d       a        alpha    sigma m        r1       r2       r3           I1            I2         I3         I4          I5      I6      Jm
L(1) = Link([ 0     453    160       pi/2     0     37.37    0        0       0.125         0.9919      0.9919      0.426       0           0       0       0],'standard');%��������
L(2) = Link([ pi/2  0      590       0        0     56.35    0        0       0.25          4.95        4.95        0.5381  	0           0       0       0],'standard');
L(3) = Link([ 0     0      200       pi/2     0     23.21    0.07     0       0.09          0.367       0.367       0.23        0           0       0       0],'standard');
L(4) = Link([ 0     723     0        -pi/2    0     5.61     0        0       0.2           0.3026      0.3026      6.07e-3     0           0       0       0],'standard');
L(5) = Link([ 0     0       0        pi/2     0     1.1      0        0       0.1           0.0149      0.0149      4.63e-4     0           0       0       0],'standard');
L(6) = Link([ pi    290     0        0        0     0.192    0        0       0.0175        1.19e-4     1.19e-4     8.07e-5     0           0       0       0],'standard');
%% ������m r �Ȳ����������ܺ�ʱ���޷�����,sigma�����趨���˵�����
sixlink = SerialLink(L,'name','six link');
robot = createRobot();%����������
robot.links(1,6).d = 290;

energy=zeros(30,30); % �ܺľ���
Smooth = zeros(30,30);
tSample=0:0.05:2; % �趨ÿ��������֮�����תʱ��Ϊ2s��ʱ��t��������41��ʱ�������
enegy_tmp=0;    

for o=1:840 % �ܹ���420��������ת·��
    
    name = load(FileNames{o});
    tmp=FileNames{o,1};
    tmp1=tmp(4:strfind(tmp,'.')-1);
    start = str2num(tmp1(1:strfind(tmp,'_')-4));
    goal = str2num(tmp1(strfind(tmp,'_')-2:end));
%     path_cor = [weldpoint(start,:);path;weldpoint(goal,:)]; % ƴ�����������ʼ�����ֹ��
    path_cor = name.path;
    length = 0;
    for i=1:size(path_cor,1)-1 
        length=length+norm(path_cor(i,:)-path_cor(i+1,:));        
    end
    seg_rate = zeros(size(path_cor,1)-1,1);
    inverse_kinematics = zeros(size(path_cor,1)-1,6);
    for j=1:size(path_cor,1)
        inverse_kinematics(j,:)=robot.ikine(transl(path_cor(j,:)),zeros(1,6),[1,1,1,0,0,0],'pinv');% �������
        if j < size(path_cor,1)
        seg_rate(j,:) = norm(path_cor(j,:)-path_cor(j+1,:))/length;
        end
    end
    smoothness = zeros(size(inverse_kinematics,1)-1,1);
    for i=1:size(inverse_kinematics,1)-1
       [qSample,qd,qdd]=jtraj(inverse_kinematics(i,:),inverse_kinematics(i+1,:), tSample*seg_rate(i)); % ��ζ���ʽ�岹
        F=rne(sixlink,qSample,qd,qdd);
        for t=1:size(F,1)
            for tt=1:6
                enegy_tmp=enegy_tmp+abs(F(t,tt)*qd(t,tt))*0.05; % �ܺ����
            end
        end
    %% smoothness
        acceleration = zeros(size(qdd,1)-1,6);
        for k  = 2 : size (qdd,1)-1
            time_pre = 0.05 * seg_rate(i);%norm(path_cor(q,:)-path_cor(q-1,:))/f;
            time_curr = 0.05 * seg_rate(i);%norm(path_cor(q+1,:)-path_cor(q,:))/f;
            % ���ٶȵ�λΪmm/s����˳���1000���Ի���Ϊm/s
            acceleration(k,:) = (2 * (qSample(k-1,:))/(time_pre*(time_pre+time_curr)) - 2 * (qSample(k,:))/(time_pre*time_curr) + 2 * (qSample(k+1,:))/(time_curr*(time_pre+time_curr)));%/1000;
            smoothness(i,:)  = max(sum(acceleration(k,:).^2)/6);
        end
        Smooth(start,goal) = Smooth(start,goal) + smoothness(i,:)*seg_rate(i);
    end 

    energy(start,goal)=enegy_tmp;
%     energy(goal,start)=enegy_tmp;
enegy_tmp=0;
 
%     parameter.qSample = qSample;
%     parameter.qd = qd;
%     parameter.qdd = qdd;
%     parameter.acceleration = acceleration;
%     parameter.smoothness = smoothness;
%     parameter. MaxSmoothness = Smoothness;
%     filename = strcat(num2str(start),'-',num2str(goal));
%     save( ['Smoothness/',filename], 'parameter');
    %% �������йؽڵĽǶȱ仯���ߡ����ٶȱ仯���ߡ��Ǽ��ٶȱ仯����
% % L1��������L6��ʾ�ؽ�1��2��������6�ĽǶ�
% L1=qSample(:,1);
% L2=qSample(:,2);
% L3=qSample(:,3);
% L4=qSample(:,4);
% L5=qSample(:,5);
% L6=qSample(:,6);
% % K1��������K6��ʾ�ؽ�1��2��������6�Ľ��ٶ�
% K1=qd(:,1);
% K2=qd(:,2);
% K3=qd(:,3);
% K4=qd(:,4);
% K5=qd(:,5);
% K6=qd(:,6);
% % M1��������M6��ʾ�ؽ�1��2��������6�ĽǼ��ٶ�
% M1=qdd(:,1);
% M2=qdd(:,2);
% M3=qdd(:,3);
% M4=qdd(:,4);
% M5=qdd(:,5);
% M6=qdd(:,6);
% t = 1 : 41;
% % �����ؽ�1��2��������6�ĽǶȱ仯����
% figure(1)
% subplot(2,3,1)
% plot(t,L1);
% title('angle of joint 1');
% hold on
% subplot(2,3,2)
% plot(t,L2);
% title('angle of joint 2');
% hold on
% subplot(2,3,3)
% plot(t,L3);
% title('angle of joint 3');
% hold on
% subplot(2,3,4)
% plot(t,L4);
% title('angle of joint 4');
% hold on
% subplot(2,3,5)
% plot(t,L5);
% title('angle of joint 5');
% hold on
% subplot(2,3,6)
% plot(t,L6);
% title('angle of joint 6');
% 
% % �����ؽ�1��2��������6�Ľ��ٶȱ仯����
% figure(2);
% subplot(2,3,1)
% plot(t,K1);
% title('angle velocity of joint 1');
% hold on
% subplot(2,3,2)
% plot(t,K2);
% title('angle velocity of joint 2');
% hold on
% subplot(2,3,3)
% plot(t,K3);
% title('angle velocity of joint 3');
% hold on
% subplot(2,3,4)
% plot(t,K4);
% title('angle velocity of joint 4');
% hold on
% subplot(2,3,5)
% plot(t,K5);
% title('angle velocity of joint 5');
% hold on
% subplot(2,3,6)
% plot(t,K6);
% title('angle velocity of joint 6');
% 
% % �����ؽ�1��2��������6�Ľ��ٶȶȱ仯����
% figure(3);
% subplot(2,3,1)
% plot(t,M1);
% title('angle acceleration of joint 1');
% hold on
% subplot(2,3,2)
% plot(t,M2);
% title('angle acceleration of joint 2');
% hold on
% subplot(2,3,3)
% plot(t,M3);
% title('angle acceleration of joint 3');
% hold on
% subplot(2,3,4)
% plot(t,M4);
% title('angle acceleration of joint 4');
% hold on
% subplot(2,3,5)
% plot(t,M5);
% title('angle acceleration of joint 5');
% hold on
% subplot(2,3,6)
% plot(t,M6);
% title('angle acceleration of joint 6');
    
end

energy = energy./1000000;
save Energy energy
save Smooth Smooth
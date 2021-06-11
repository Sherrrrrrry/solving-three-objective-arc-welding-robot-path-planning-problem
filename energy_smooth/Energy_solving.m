%% 笛卡尔坐标系下求解能耗
clc
clear
load weldpoint; % 最初的焊点坐标
startup_rvc;
Path = './';                   % 设置数据存放的文件夹路径
File = dir(fullfile(Path,'*.mat'));  % 显示文件夹下所有符合后缀名为.mat文件的完整信息
FileNames = {File.name}';            % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列
%% 建立机器人模型
% %           th    d       a        alpha    sigma m        r1       r2       r3           I1            I2         I3         I4          I5      I6      Jm
L(1) = Link([ 0     453    160       pi/2     0     37.37    0        0       0.125         0.9919      0.9919      0.426       0           0       0       0],'standard');%定义连杆
L(2) = Link([ pi/2  0      590       0        0     56.35    0        0       0.25          4.95        4.95        0.5381  	0           0       0       0],'standard');
L(3) = Link([ 0     0      200       pi/2     0     23.21    0.07     0       0.09          0.367       0.367       0.23        0           0       0       0],'standard');
L(4) = Link([ 0     723     0        -pi/2    0     5.61     0        0       0.2           0.3026      0.3026      6.07e-3     0           0       0       0],'standard');
L(5) = Link([ 0     0       0        pi/2     0     1.1      0        0       0.1           0.0149      0.0149      4.63e-4     0           0       0       0],'standard');
L(6) = Link([ pi    290     0        0        0     0.192    0        0       0.0175        1.19e-4     1.19e-4     8.07e-5     0           0       0       0],'standard');
%% 若不给m r 等参数，计算能耗时则无法计算,sigma可以设定连杆的类型
sixlink = SerialLink(L,'name','six link');
robot = createRobot();%创建机器人
robot.links(1,6).d = 290;

energy=zeros(30,30); % 能耗矩阵
tSample=0:0.05:2; % 设定每两个焊点之间的跳转时长为2s，时间t采样，共41个时间采样点

for o=1:840 % 总共有420条焊缝跳转路径
    enegy_tmp=0;
    name =load(FileNames{o});
    tmp=FileNames{o,1};
    tmp1=tmp(4:strfind(tmp,'.')-1);
    start = str2num(tmp1(1:strfind(tmp,'_')-4));
    goal = str2num(tmp1(strfind(tmp,'_')-2:end));
%     path_cor = [weldpoint(start,:);path;weldpoint(goal,:)]; % 拼接上最初的起始点和终止点
    path_cor = name.path;
    for i=1:size(path_cor,1)
        inverse_kinematics(i,:)=robot.ikine(transl(path_cor(i,:)),zeros(1,6),[1,1,1,0,0,0],'pinv');% 先求逆解
%     inverse_kinematics(i,:)=ikine(transl(path_cor(i,:)),zeros(1,6),[1,1,1,0,0,0],'pinv');
    end
    for i=1:size(inverse_kinematics,1)-1
       [qSample,qd,qdd]=jtraj(inverse_kinematics(i,:),inverse_kinematics(i+1,:), tSample); % 五次多项式插补
        F=rne(sixlink,qSample,qd,qdd);
        for t=1:size(F,1)
            for tt=1:6
                enegy_tmp=enegy_tmp+abs(F(t,tt)*qd(t,tt))*0.05; % 能耗求解
            end
        end
    end   
    energy(start,goal)=enegy_tmp;
%     energy(goal,start)=enegy_tmp;
%     enegy_tmp=0;
end

energy = energy./1000000;
save Energy energy
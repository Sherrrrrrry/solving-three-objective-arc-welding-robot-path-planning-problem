clc;clear;
addpath Public;
%% 参数设定
maxGEN = 300;
N = 100;
M = 2; 
H = 99;
[~,W] = F_weight(H,M);
W(W==0) = 0.000001;
selection_pressure = 4;
crosP = 0.9;%交叉概率
mutP = 0.6; %变异概率
nr = 2;
ALG = ('HV_GH48');
% [Num,distance1] = Read('kroA100.tsp');
% [~,distance2] = Read('kroB100.tsp');
load 48_gr48.txt;  % 距离矩阵
load 48_hk48.txt; %能耗矩阵
distance1 = X48_gr48;
distance2 = X48_hk48;
Num = size(distance1,1);
path_distan=distance1;
A = 2;
for p = 1:30
tic;
    %初始化向量
    [~,W] = F_weight(H,M);
    W(W==0) = 0.000001;
    %邻居判断
    B = zeros(N);
    for i = 1 : N-1
        for j = i+1 : N
            B(i,j) = norm(W(i,:)-W(j,:));%计算向量范数（向量大小），也是一种距离
            B(j,i) = B(i,j);
        end
    end
    [~,B] = sort(B,2);%B中各行按升序排列,B为每行改动顺序，得到了每个粒子最近的10个粒子（自变量） 
    L=B;
    T = floor(N/10);
    %初始化种群
    Population=zeros(N,Num);
    cost=zeros(N,2);

    for i=1:N
        Population(i,:)=randperm(Num);%每行代表一个序列
    end
    for i=1:N
        FunctionValue(i,:)=costfunction(Population(i,:),distance1,distance2);
    end
    Z = min(FunctionValue);
%% 开始迭代
for gen = 1:maxGEN
    %对每个个体执行操作
        for i = 1 : N
            %归一化
            Fmax = max(FunctionValue);
            Fmin = Z;
            FunctionValue = (FunctionValue-repmat(Fmin,N,1))./repmat(Fmax-Fmin,N,1);
            %选出父母
            k = randperm(T);
            k = B(i,k(1:2));
            %产生子代
            Offspring = P_generator([Population(k(1),:);Population(k(2),:)],'Binary',N);
            OffFunValue = costfunction(Offspring,distance1,distance2);
            OffFunValue = (OffFunValue-Fmin)./(Fmax-Fmin);
            
            %更新最优理想点
            Z = min(Z,OffFunValue);

            %更新邻居个体
            for j = 1 : T
                if A == 1
                    g_old = max(abs(FunctionValue(B(i,j),:)-Z).*W(B(i,j),:));
                    g_new = max(abs(OffFunValue-Z).*W(B(i,j),:));
                elseif A == 2
                    d1 = abs(sum((FunctionValue(B(i,j),:)-Z).*W(B(i,j),:)))/norm(W(B(i,j),:));
                    g_old = d1+5*norm(FunctionValue(B(i,j),:)-(Z+d1*W(B(i,j),:)/norm(W(B(i,j),:))));               
                    d1 = abs(sum((OffFunValue-Z).*W(B(i,j),:)))/norm(W(B(i,j),:));
                    g_new = d1+5*norm(OffFunValue-(Z+d1*W(B(i,j),:)/norm(W(B(i,j),:))));
                end
                if g_new < g_old
                    %更新当前向量的个体
                    Population(B(i,j),:) = Offspring;
                    FunctionValue(B(i,j),:) = OffFunValue;
                end
            end

            %反归一化
            FunctionValue = FunctionValue.*repmat(Fmax-Fmin,N,1)+repmat(Fmin,N,1);

        end
        %% 出图
        [fun_pf,index]=sortrows(FunctionValue,1);
        
        %% 每次迭代HV值
        pf = fun_pf./100000; % 归一化
        RefPoint = ones(1,M);
        HV_value = P_evaluate('HV',pf,RefPoint);
        HV_cal(gen) = HV_value;
        
%         plot(Fin(:,1),Fin(:,2),'k*');
%         xlabel('F1');ylabel('F2');
%         title(strcat('Interaction ',num2str(gen), ' Pareto non-dominated solutions'));
%         pause(0.02)
end
% 出图
    t=toc;
    
    path_best_value{p}=fun_pf;
    sequence{p}=Population;
    HV{p} = HV_cal;
    
%     fun_pf = fun_pf./500000; % 归一化    
%     RefPoint = ones(1,M);
%     HV_value = P_evaluate('HV',fun_pf,RefPoint);
%     HV(p) = HV_value;
end
    BEST.path_best_value=path_best_value;BEST.sequence=sequence;BEST.HV = HV;
    save(ALG, 'BEST');

%     [HV_max,index] = max(HV);
%     HV_min = min(HV);
%     HV_mean = mean(HV);
%     HV_var = var(HV);
%     best_PF = path_best_value{index};
%     fprintf('HV_mean为%d   (%d)  \n最好的次数为第%d次，对应的HV_max为%d \nHV_min为%d \n平均运行时间为%ds \n',HV_mean,HV_var,index,HV_max,HV_min,t);

%     axis([0 1 0 1]); % 设置坐标轴的范围 axis( [xmin xmax ymin ymax zmin zmax] )
%     plot(best_PF(:,1),best_PF(:,2),'r*-'); % 输出最好一次的PF
%     xlabel('f1');
%     ylabel('f2');
%     title('归一化的PFknown');
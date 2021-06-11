%% NSGA-III
    clear;clc;close all
    addpath Public;
    tic;
    %初始化向量
    Generations=300;   
    p1=9;
    p2=0;    M=2;  
    [N,W] = F_weight(p1,p2,M);
    W(W==0) = 0.000001;
    N=100;      
    ALG = ('HV_GH48');
    load 48_gr48.txt;  % 距离矩阵
    load 48_hk48.txt; %能耗矩阵
    distance1 = X48_gr48;
    distance2 = X48_hk48;
    Num = size(distance1,1);
    for p = 1:30
        Population=zeros(N,Num);
        Coding='Binary';
        
        %初始化种群
        for i=1:N
            Population(i,:)=randperm(Num);%每行代表一个序列
        end
        %开始迭代
        for Gene = 1 : Generations
            %产生子代
            MatingPool = F_mating(Population);
            [Offspring] = P_generator(MatingPool,N);
            Population = [Population;Offspring];
            for i=1:size(Population,1)
                FunctionValue(i,:)=costfunction(Population(i,:),distance1,distance2);
            end
            
            [FrontValue,MaxFront] = P_sort(FunctionValue,'half');
            
            %选出非支配的个体
            Next = zeros(1,N);
            NoN = numel(FrontValue,FrontValue<MaxFront);
            Next(1:NoN) = find(FrontValue<MaxFront);
            
            %选出最后一个面的个体
            Last = find(FrontValue==MaxFront);
            Choose = F_choose(FunctionValue(Next(1:NoN),:),FunctionValue(Last,:),N-NoN,W);
            Next(NoN+1:N) = Last(Choose);
            
            %下一代种群
            Population = Population(Next,:);
            FunctionValue= FunctionValue(Next,:);
            
            fun_pf=FunctionValue;
            [fun_pf,~]=sortrows(fun_pf,1);
            %% 每次迭代HV值
            pf = fun_pf./100000; % 归一化
            RefPoint = ones(1,M);
            HV_value = P_evaluate('HV',pf,RefPoint);
            HV_cal(Gene) = HV_value;
        
            % 画图
%             plot(fun_pf(:,1),fun_pf(:,2),'r*-');
%             xlabel('Path Length');ylabel('Energy Consumption');
%             title(strcat('Interaction ',num2str(Gene), ' Pareto non-dominated solutions'));
%             pause(0.05)
            
        end
        t=toc;
        
        %     [Fin,index]=sortrows(fun_pf,1);
        %     plot(Fin(:,1),Fin(:,2),'k*-');
        
%         fun_pf = fun_pf./1000000; % 归一化
        path_best_value{p}=fun_pf;
        sequence{p}=Population;
        HV{p} = HV_cal; 
        
%         RefPoint = ones(1,M);
%         HV_value = P_evaluate('HV',fun_pf,RefPoint);
%         HV(p) = HV_value;
    end
    BEST.path_best_value=path_best_value;BEST.sequence=sequence;BEST.HV=HV;
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
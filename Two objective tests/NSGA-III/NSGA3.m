%% NSGA-III
    clear;clc;close all
    addpath Public;
    tic;
    %��ʼ������
    Generations=300;   
    p1=9;
    p2=0;    M=2;  
    [N,W] = F_weight(p1,p2,M);
    W(W==0) = 0.000001;
    N=100;      
    ALG = ('HV_GH48');
    load 48_gr48.txt;  % �������
    load 48_hk48.txt; %�ܺľ���
    distance1 = X48_gr48;
    distance2 = X48_hk48;
    Num = size(distance1,1);
    for p = 1:30
        Population=zeros(N,Num);
        Coding='Binary';
        
        %��ʼ����Ⱥ
        for i=1:N
            Population(i,:)=randperm(Num);%ÿ�д���һ������
        end
        %��ʼ����
        for Gene = 1 : Generations
            %�����Ӵ�
            MatingPool = F_mating(Population);
            [Offspring] = P_generator(MatingPool,N);
            Population = [Population;Offspring];
            for i=1:size(Population,1)
                FunctionValue(i,:)=costfunction(Population(i,:),distance1,distance2);
            end
            
            [FrontValue,MaxFront] = P_sort(FunctionValue,'half');
            
            %ѡ����֧��ĸ���
            Next = zeros(1,N);
            NoN = numel(FrontValue,FrontValue<MaxFront);
            Next(1:NoN) = find(FrontValue<MaxFront);
            
            %ѡ�����һ����ĸ���
            Last = find(FrontValue==MaxFront);
            Choose = F_choose(FunctionValue(Next(1:NoN),:),FunctionValue(Last,:),N-NoN,W);
            Next(NoN+1:N) = Last(Choose);
            
            %��һ����Ⱥ
            Population = Population(Next,:);
            FunctionValue= FunctionValue(Next,:);
            
            fun_pf=FunctionValue;
            [fun_pf,~]=sortrows(fun_pf,1);
            %% ÿ�ε���HVֵ
            pf = fun_pf./100000; % ��һ��
            RefPoint = ones(1,M);
            HV_value = P_evaluate('HV',pf,RefPoint);
            HV_cal(Gene) = HV_value;
        
            % ��ͼ
%             plot(fun_pf(:,1),fun_pf(:,2),'r*-');
%             xlabel('Path Length');ylabel('Energy Consumption');
%             title(strcat('Interaction ',num2str(Gene), ' Pareto non-dominated solutions'));
%             pause(0.05)
            
        end
        t=toc;
        
        %     [Fin,index]=sortrows(fun_pf,1);
        %     plot(Fin(:,1),Fin(:,2),'k*-');
        
%         fun_pf = fun_pf./1000000; % ��һ��
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
%     fprintf('HV_meanΪ%d   (%d)  \n��õĴ���Ϊ��%d�Σ���Ӧ��HV_maxΪ%d \nHV_minΪ%d \nƽ������ʱ��Ϊ%ds \n',HV_mean,HV_var,index,HV_max,HV_min,t); 
%     axis([0 1 0 1]); % ����������ķ�Χ axis( [xmin xmax ymin ymax zmin zmax] )
%     plot(best_PF(:,1),best_PF(:,2),'r*-'); % ������һ�ε�PF
%     xlabel('f1');
%     ylabel('f2');
%     title('��һ����PFknown');
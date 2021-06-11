clc;clear;
addpath Public;
%% �����趨
maxGEN = 300;
N = 100;
M = 2; 
H = 99;
[~,W] = F_weight(H,M);
W(W==0) = 0.000001;
selection_pressure = 4;
crosP = 0.9;%�������
mutP = 0.6; %�������
nr = 2;
ALG = ('HV_GH48');
% [Num,distance1] = Read('kroA100.tsp');
% [~,distance2] = Read('kroB100.tsp');
load 48_gr48.txt;  % �������
load 48_hk48.txt; %�ܺľ���
distance1 = X48_gr48;
distance2 = X48_hk48;
Num = size(distance1,1);
path_distan=distance1;
A = 2;
for p = 1:30
tic;
    %��ʼ������
    [~,W] = F_weight(H,M);
    W(W==0) = 0.000001;
    %�ھ��ж�
    B = zeros(N);
    for i = 1 : N-1
        for j = i+1 : N
            B(i,j) = norm(W(i,:)-W(j,:));%��������������������С����Ҳ��һ�־���
            B(j,i) = B(i,j);
        end
    end
    [~,B] = sort(B,2);%B�и��а���������,BΪÿ�иĶ�˳�򣬵õ���ÿ�����������10�����ӣ��Ա����� 
    L=B;
    T = floor(N/10);
    %��ʼ����Ⱥ
    Population=zeros(N,Num);
    cost=zeros(N,2);

    for i=1:N
        Population(i,:)=randperm(Num);%ÿ�д���һ������
    end
    for i=1:N
        FunctionValue(i,:)=costfunction(Population(i,:),distance1,distance2);
    end
    Z = min(FunctionValue);
%% ��ʼ����
for gen = 1:maxGEN
    %��ÿ������ִ�в���
        for i = 1 : N
            %��һ��
            Fmax = max(FunctionValue);
            Fmin = Z;
            FunctionValue = (FunctionValue-repmat(Fmin,N,1))./repmat(Fmax-Fmin,N,1);
            %ѡ����ĸ
            k = randperm(T);
            k = B(i,k(1:2));
            %�����Ӵ�
            Offspring = P_generator([Population(k(1),:);Population(k(2),:)],'Binary',N);
            OffFunValue = costfunction(Offspring,distance1,distance2);
            OffFunValue = (OffFunValue-Fmin)./(Fmax-Fmin);
            
            %�������������
            Z = min(Z,OffFunValue);

            %�����ھӸ���
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
                    %���µ�ǰ�����ĸ���
                    Population(B(i,j),:) = Offspring;
                    FunctionValue(B(i,j),:) = OffFunValue;
                end
            end

            %����һ��
            FunctionValue = FunctionValue.*repmat(Fmax-Fmin,N,1)+repmat(Fmin,N,1);

        end
        %% ��ͼ
        [fun_pf,index]=sortrows(FunctionValue,1);
        
        %% ÿ�ε���HVֵ
        pf = fun_pf./100000; % ��һ��
        RefPoint = ones(1,M);
        HV_value = P_evaluate('HV',pf,RefPoint);
        HV_cal(gen) = HV_value;
        
%         plot(Fin(:,1),Fin(:,2),'k*');
%         xlabel('F1');ylabel('F2');
%         title(strcat('Interaction ',num2str(gen), ' Pareto non-dominated solutions'));
%         pause(0.02)
end
% ��ͼ
    t=toc;
    
    path_best_value{p}=fun_pf;
    sequence{p}=Population;
    HV{p} = HV_cal;
    
%     fun_pf = fun_pf./500000; % ��һ��    
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
%     fprintf('HV_meanΪ%d   (%d)  \n��õĴ���Ϊ��%d�Σ���Ӧ��HV_maxΪ%d \nHV_minΪ%d \nƽ������ʱ��Ϊ%ds \n',HV_mean,HV_var,index,HV_max,HV_min,t);

%     axis([0 1 0 1]); % ����������ķ�Χ axis( [xmin xmax ymin ymax zmin zmax] )
%     plot(best_PF(:,1),best_PF(:,2),'r*-'); % ������һ�ε�PF
%     xlabel('f1');
%     ylabel('f2');
%     title('��һ����PFknown');
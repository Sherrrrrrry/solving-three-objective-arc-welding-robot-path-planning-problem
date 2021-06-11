
clc;clear;

%% �����趨
maxGEN = 300;
popSize = 100;
M = 2; 
H = 99;
[~,W] = F_weight(H,M);
W(W==0) = 0.000001;
selection_pressure = 4;
crosP = 0.9;%�������
mutP = 0.1; %�������
nr = 2;
ALG = ('test0_kroCD100.mat');
% [Num,distance1] = Read('kroA100.tsp');
% [~,distance2] = Read('kroB100.tsp');
load 100_kroC100.txt;  % �������
load 100_kroD100.txt; %�ܺľ���
distance1 = X100_kroC100;
distance2 = X100_kroC100;
Num = size(distance1,1);
path_distan=distance1;

for p = 1:30
tic;
pop =[];
result =[];

%% ��ʼ����Ⱥ

for i=1:popSize
pop(i,:) = randperm(Num); 
% ����Ŀ�꺯��ֵ
result(i,:) = costfunction(pop(i,:),distance1,distance2);
end
[iBest,Bestind] = min(result);
[iWorst,Worstind] = max(result);
Direct = pop(Bestind,:);
%% �ھ��ж�
B = zeros(popSize);
for i = 1 : popSize
    for j = i : popSize
        B(i,j) = norm(W(i,:)-W(j,:));
        B(j,i) = B(i,j);
    end
end
[~,B] = sort(B,2);
%% ��ʼ����
rate = 0;
for gen = 1:maxGEN
    T =10;
   
    for l = 1:popSize
        D(l,:) = F_Fitness(W,iBest,result(l,:),rate,l);
    end
    Archive = pop;    Archive_fun = result; DD=D;
    mu_pop = [];    mu_result = [];    mu_D =[];
    Population = [];  functionvalue = []; fitness = [];
    cc = [];
% ��Ӧ��ֵ����
    for i = 1:popSize
        %ѡ����ĸ
        P = B(i,1:T);
        k = randperm(T);
        randomPair = P(k(2:selection_pressure+1));
        MatingPool(1,:) = pop(P(k(1)),:);
        winner_index = randomPair(randperm(selection_pressure,1));
        MatingPool(2,:) = pop(winner_index,:);

%         �������
        [Offspring,Offspring_mu] = F_generator(MatingPool,crosP,mutP,Direct);
        %������Ӧ��ֵ
        result2 = costfunction(Offspring,distance1,distance2);
        D2 = F_Fitness(W,iBest,result2,rate,l);
        if ~isempty(Offspring_mu)
            result2_mu = costfunction(Offspring_mu,distance1,distance2); 
            D2_mu = F_Fitness(W,iBest,result2_mu,rate,l);
            if sum(result2_mu <= result2) == 1
                mu_pop = [mu_pop;Offspring_mu];
                mu_result = [mu_result;result2_mu];
                mu_D = [mu_D;D2_mu];
            end
            if sum(result2_mu <= result2) == 2
                Offspring = Offspring_mu;
                result2 = result2_mu;
                D2 = D2_mu;
            end
        end
            
        iBest = min(iBest,result2);
        iWorst = min(iWorst,max(result));
        if sum(iBest >= result2)>0
        seq = find(iBest >= result2);
        Direct(seq,:) =  repmat(Offspring,size(seq,2),1);
        end
       %% ѡ��������Ⱥѡ��ʽ
        if  rate <= 0
            %��ʽ1��NS.GA-III���ַ�֧������
                    Population = [Population;Offspring];
                    functionvalue = [functionvalue;result2];
                    count(i)=1;
        else
            %��ʽ2��MOEA/D�����ѡ��ʽ
            c = 0;
            for f = P(k)%randperm(length(P))
                if c >= nr
                    break;
                end
                if (D2 < D(f))
                    %���µ�ǰ�����ĸ���
                    pop(f,:) = Offspring;
                    result(f,:) = result2;
                    D(f,:) = D2;
                    c = c+1;
                    cc = [cc;f];
                end
            end
        end
    end

        % �������
    pop = Reverse(pop, path_distan);
    for i = 1:popSize
        result(i,:) = costfunction(pop(i,:),distance1,distance2);
        D(i,:) = F_Fitness(W,iBest,result(i,:),rate,i);
    end
    iBest =min(iBest,min(result));
    iWorst = min(iWorst,max(result));
    X = [Archive;pop;Population;mu_pop];
    Y = [Archive_fun; result;functionvalue;mu_result];
    
    [s,jh] = P_sort(Y,'half');
    XX = X(s~=inf,:);
    YY = Y(s~=inf,:);
    s(s==inf)=[];
    df = [];
    r=0;
    while numel(df)<(size(XX,1) - popSize)
        df=[df,find(s == jh-r)];
        r = r+1;
    end
    if ~isempty(df)
        Z_map = Weight_scalarization(W,YY,size(YY,2));
        Cosine   = acos( 1 - pdist2(YY-repmat(iBest,size(YY,1),1),Z_map,'cosine'));
        [Theta,Pio] = min(Cosine',[],1);   %��ÿ����������Ĳο�������
        fv=[];
        while size(fv,2)<(size(XX,1) - popSize)
            [~,dens]  = max(Theta(df));
            fv = [fv,dens];
            Theta(df(dens))=0;
        end
        XX(df(fv),:)=[];
        YY(df(fv),:)=[];
    end
    pop = XX;
    result = YY;
    re = unique(result,'rows');
    [~,ee] = intersect(Archive_fun, re,'rows');
    rate = 1 - (popSize-size(ee,1))/popSize;
        %% ��ͼ
        [fun_pf,index]=sortrows(result,1);
        
%         %% ÿ�ε���HVֵ
%         pf = fun_pf./500000; % ��һ��
%         RefPoint = ones(1,M);
%         HV_value = P_evaluate('HV',pf,RefPoint);
%         HV_cal(gen) = HV_value;
        
%         plot(Fin(:,1),Fin(:,2),'k*');
%         xlabel('F1');ylabel('F2');
%         title(strcat('Interaction ',num2str(gen), ' Pareto non-dominated solutions'));
%         pause(0.02)
end
% ��ͼ
%     [fun_pf,index]=sortrows(result,1);

    t=toc;
            
    path_best_value{p}=fun_pf;
    sequence{p}=Population;
%     HV{p} = HV_cal;
        fun_pf = fun_pf./500000; % ��һ��
        RefPoint = ones(1,M);
        HV_value = P_evaluate('HV',fun_pf,RefPoint);
        HV(p) = HV_value;
end
    BEST.path_best_value=path_best_value;BEST.sequence=sequence; BEST.HV = HV;
    save(ALG, 'BEST');

    [HV_max,index] = max(HV);
    HV_min = min(HV);
    HV_mean = mean(HV);
    HV_var = var(HV);
    best_PF = path_best_value{index};
%     fprintf('HV_meanΪ%d   (%d)  \n��õĴ���Ϊ��%d�Σ���Ӧ��HV_maxΪ%d \nHV_minΪ%d \nƽ������ʱ��Ϊ%ds \n',HV_mean,HV_var,index,HV_max,HV_min,t); 
%     axis([0 1 0 1]); % ����������ķ�Χ axis( [xmin xmax ymin ymax zmin zmax] )
%     plot(best_PF(:,1),best_PF(:,2),'r*-'); % ������һ�ε�PF
%     xlabel('f1');
%     ylabel('f2');
%     title('��һ����PFknown');
function Offspring = F_operator(MatingPool, MaxOffspring)
% This function generates a new population by genetic operators
Coding='Binary';

    [N,D] = size(MatingPool);
    if nargin < 3 || MaxOffspring < 1 || MaxOffspring > N
        MaxOffspring = N;
    end
    
    switch Coding
    case 'Real'    
        [N,D] = size(MatingPool);
        %-----------------------------------------------------------------------------------------
        % Parameters setting
        ProC = 1;       % The probability of crossover
        ProM = 1/D;     % The probability of mutation
        DisC = 20;   	% The parameter of crossover
        DisM = 20;   	% The parameter of mutation
        %-----------------------------------------------------------------------------------------
        % Simulated binary crossover
        Parent1 = MatingPool(1:N/2,:);
        Parent2 = MatingPool(N/2+1:end,:);
        beta    = zeros(N/2,D);
        miu     = rand(N/2,D);
        beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
        beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
        beta = beta.*(-1).^randi([0,1],N/2,D);
        beta(rand(N/2,D)<0.5) = 1;
        beta(repmat(rand(N/2,1)>ProC,1,D)) = 1;
        Offspring = [(Parent1+Parent2)/2+beta.*(Parent1-Parent2)/2
            (Parent1+Parent2)/2-beta.*(Parent1-Parent2)/2];
        %-----------------------------------------------------------------------------------------
        % Polynomial mutation
        MaxValue = repmat(Boundary(1,:),N,1);
        MinValue = repmat(Boundary(2,:),N,1);
        k    = rand(N,D);
        miu  = rand(N,D);
        Temp = k<=ProM & miu<0.5;
        Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
        Temp = k<=ProM & miu>=0.5;
        Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));
        %-----------------------------------------------------------------------------------------
        % Set the offsprings which are infeasible to boundary values
        Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
        Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
        %二进制交叉、变异
        case 'Binary'
            %遗传操作参数
            ProM = 0.01;	%变异概率
            Pc=0.9;         %交叉概率
            Pm=0.05;        %变异概率
            [Offspring]=Recombin(MatingPool,Pc);
            [Offspring]=Mutate(Offspring,Pm);
    end
end
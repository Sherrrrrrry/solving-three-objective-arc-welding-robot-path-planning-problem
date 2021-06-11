function DistanceValue = F_distance(FunctionValue,M)

    [N,M] = size(FunctionValue);
    PopObj = FunctionValue;
%%  sumof OBJECTIVE
 
    fmax   = repmat(max(PopObj,[],1),N,1);
    fmin   = repmat(min(PopObj,[],1),N,1);
    PopObj = (PopObj-fmin)./(fmax-fmin);
    fpr    = mean(PopObj,2);
    [~,rank] = sort(fpr);
    
 %%%%%%%%%%%%% % SDE with Sum of Objectives  %%%%%%%%%%%%%%%%%%%%
    DistanceValue = zeros(1,N);                             
    

    for j = 2 : N

        SFunctionValue = max(PopObj(rank(1:j-1),:),repmat(PopObj(rank(j),:),(j-1),1));
        
        Distance = inf(1,j-1);
            
        for i = 1 : (j-1)
            Distance(i) = norm(SFunctionValue(i,:)-PopObj(rank(j),:))/M;
        end
           
        Distance = min(Distance);
        
        DistanceValue(rank(j)) = exp(-Distance);

         
    end



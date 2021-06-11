function MatingPool = MatingSelection(PopObj,DistanceValue)

    N = size(PopObj,1);

    %% Binary tournament selection
    Parent1   = randi(N,1,N);
    Parent2   = randi(N,1,N);
    MatingPool = zeros(1,N);
   
    for i = 1:N
       if DistanceValue(Parent1(i)) < DistanceValue(Parent2(i))
           MatingPool(i) = Parent1(i);
       elseif DistanceValue(Parent1(i)) > DistanceValue(Parent2(i))
           MatingPool(i) = Parent2(i);
       else
           if rand< 0.5
                MatingPool(i) = Parent1(i);
           else
                MatingPool(i) = Parent2(i);
           end
       end
    end
  
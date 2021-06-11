load('test_new.mat');
solutions=[];
for i = 1:20
    solutions=[solutions;BEST.path_best_value{i}];
end
s = P_sort(solutions,'first');
solution = solutions(s==1,:);
for k = 1:20
    F = intersect(BEST.path_best_value{k},solution,'rows');
    P(k)= size(F,1)/size(solution,1);
end
[~,P_max] = max(P);
Choosed_nsga3 = BEST.path_best_value{P_max};

 
figure 
plot(Choosed_nsga3(:,1),Choosed_nsga3(:,2)/10,'b<-');
xlabel('Path Length /mm');ylabel('Energy /KJ');
title(strcat('Pareto non-dominated solutions in 300 interactions'));
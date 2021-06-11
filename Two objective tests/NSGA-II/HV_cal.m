
load('kroAB200.mat');
M=2;
for i = 1:30
fun_pf = cell2mat(BEST.path_best_value(i));
fun_pf = fun_pf./500000; % 归一化

RefPoint = ones(1,M);
HV_value = P_evaluate('HV',fun_pf,RefPoint);
HV(i) = HV_value;
end
[HV_max,index] = max(HV);
HV_min = min(HV);
HV_mean = mean(HV);
HV_var = var(HV);
fprintf('HV_mean为%d   (%d)  \n最好的次数为第%d次，对应的HV_max为%d \nHV_min为%d \n',HV_mean,HV_var,index,HV_max,HV_min);

BEST.HV=HV;
save('kroAB200.mat','BEST');
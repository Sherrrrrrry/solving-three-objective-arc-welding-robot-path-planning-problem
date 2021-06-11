
load('kroAR200.mat');
M=2;
for i = 1:30
fun_pf = cell2mat(BEST.path_best_value(i));
fun_pf = fun_pf./500000; % ��һ��

RefPoint = ones(1,M);
HV_value = P_evaluate('HV',fun_pf,RefPoint);
HV(i) = HV_value;
end
[HV_max,index] = max(HV);
HV_min = min(HV);
HV_mean = mean(HV);
HV_var = var(HV);
fprintf('HV_meanΪ%d   (%d)  \n��õĴ���Ϊ��%d�Σ���Ӧ��HV_maxΪ%d \nHV_minΪ%d \n',HV_mean,HV_var,index,HV_max,HV_min);

BEST.HV=HV;
save('kroAR200.mat','BEST');
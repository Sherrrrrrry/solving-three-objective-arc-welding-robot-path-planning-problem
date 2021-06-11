function Z_map = Weight_scalarization(W,YY,M)        
%权重向量值归一化
min_FV=min(YY);
min_FV0=zeros(size(min_FV));
%         min_FV(abs(min_FV)<interval)=min_FV0(abs(min_FV)<interval);
YY=YY-min_FV;
Extreme = zeros(1,M);           %每维的边界点
w = zeros(M)+0.000001+eye(M);
for i = 1 : M                   %找出每维边界点
    [~,Extreme(i)] = min(max(YY./repmat(w(i,:),size(YY,1),1),[],2));
end
max_Extreme_FV=max(YY(Extreme,:));
Z_map=W(:,1:M).*max_Extreme_FV;%将超平面映射到决策空间
end
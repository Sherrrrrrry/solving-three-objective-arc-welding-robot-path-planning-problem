function Z_map = Weight_scalarization(W,YY,M)        
%Ȩ������ֵ��һ��
min_FV=min(YY);
min_FV0=zeros(size(min_FV));
%         min_FV(abs(min_FV)<interval)=min_FV0(abs(min_FV)<interval);
YY=YY-min_FV;
Extreme = zeros(1,M);           %ÿά�ı߽��
w = zeros(M)+0.000001+eye(M);
for i = 1 : M                   %�ҳ�ÿά�߽��
    [~,Extreme(i)] = min(max(YY./repmat(w(i,:),size(YY,1),1),[],2));
end
max_Extreme_FV=max(YY(Extreme,:));
Z_map=W(:,1:M).*max_Extreme_FV;%����ƽ��ӳ�䵽���߿ռ�
end
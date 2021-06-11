function D = F_Fitness(W,iBest,FunctionValue,rate,k)
% d1 = abs(sum((FunctionValue-iBest).*W(k,:)))/norm(W(k,:));
% d2 = norm(FunctionValue-iBest -(d1*W(k,:))/norm(W(k,:)));
% % if rate >= rand
%     D = d1*(cos(W(k,2)-W(k,1))) + 5*d2;
% % else
% %     D = sum(max(abs(FunctionValue-iBest).*W));
% % end

normW   = sqrt(sum(W(k,:).^2,2));
normP   = sqrt(sum((FunctionValue-iBest).^2,2));
CosineP = sum((FunctionValue-iBest).*W(k,:),2)./normW./normP;
% if rate >= 0.3
    penalty = cos(mean(abs(W(k,:) - mean(W(k,:)))));
    D = normP.*CosineP*penalty + 5*normP.*sqrt(1-CosineP.^2);
% else
%     D = max(abs(FunctionValue-iBest).*W(k,:));
% end

end
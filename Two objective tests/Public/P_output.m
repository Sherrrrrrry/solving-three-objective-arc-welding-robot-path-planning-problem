function   [IGD,HV,GD]=P_output (Population,time,Algorithm,Problem,M,Run)
% �㷨����ĸ�ʽ�����, ������������ָ��ֵ,����ͼ��,��������
% ����: Population, �㷨�Ľ��(���߿ռ�)
%       time,       �㷨�ĺ�ʱ
%       Algorithm,  �㷨����
%       Problem,    ������������
%       M,          ��������ά��
%       Run,        ���д������

    %���㺯��ֵ
     FunctionValue = P_objective('value',Problem,M,Population);
    
    %ȥ����֧�����
%    NonDominated  = P_sort(FunctionValue,'first')==1;
%    Population    = Population(NonDominated,:);
%    FunctionValue = FunctionValue(NonDominated,:);
    
    %������ʵ������
    TruePoint = P_objective('true',Problem,M,500);
    
    %���۽������
    IGD = P_evaluate('IGD',FunctionValue,TruePoint)
    HV  = P_evaluate('HV',FunctionValue,TruePoint)
    GD = P_evaluate('GD',FunctionValue,TruePoint) 
    if M<3
      plot(TruePoint(:,1),TruePoint(:,2),'r-',FunctionValue(:,1),FunctionValue(:,2),'b*');
      xlabel('F1');ylabel('F2');
      legend('���㷨���ķ��ӽ�','Pareto Front');
      title([Algorithm,' on ',Problem,' with ',num2str(M),' objectives']);
      tb1=strcat(num2str(Problem),'.fig');
      saveas(gcf,tb1);
    elseif M>=3
      plot3(TruePoint(:,1),TruePoint(:,2),TruePoint(:,3),'r.',FunctionValue(:,1),FunctionValue(:,2),FunctionValue(:,3),'b*');   
      axis tight;xlabel('F1');ylabel('F2');zlabel('F3');
      title([Algorithm,' on ',Problem,' with ',num2str(M),' objectives']);
      view(135,30)
      tb1=strcat(num2str(Problem),'.fig');
      saveas(gcf,tb1);
    end
%          ���ƽ��
    if M < 4
        figure;
        P_draw(FunctionValue);
        title([Algorithm,' on ',Problem,' with ',num2str(M),' objectives']);
%         legend('���㷨���ķ��ӽ�')
        Range(1:2:2*M) = min(FunctionValue,[],1);
        Range(2:2:2*M) = max(FunctionValue,[],1)*1.02;
        axis(Range);
        set(gcf,'Name',[num2str(size(FunctionValue,1)),' points  IGD=',num2str(IGD,5),'  HV=',num2str(HV,5),'  Runtime=',num2str(time,5),'s']);
        pause(0.1);
    end
%     
%     if M >= 4
%         figure;
%         P_draw(FunctionValue);
%         title([Algorithm,' on ',Problem,' with ',num2str(M),' objectives']);
%         set(gcf,'Name',[num2str(size(FunctionValue,1)),' points  IGD=',num2str(IGD,5),'  HV=',num2str(HV,5),'  Runtime=',num2str(time,5),'s']);
%         pause(0.1);    
%     end
    
    %������
%     eval(['save Data/',Algorithm,'/',Algorithm,'_',Problem,'_',num2str(M),'_',num2str(Run),' Population FunctionValue time'])
end


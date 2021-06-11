function [FrontValue,MaxFront] = P_sort(FunctionValue,Operation)
% ���з�֧������
% ����: FunctionValue, ���������Ⱥ(Ŀ��ռ�)
%       Operation,     ��ָ���������һ����,����ǰһ�����,�����������еĸ���, Ĭ��Ϊ�������еĸ���
% ���: FrontValue, ������ÿ���������ڵ�ǰ������, δ����ĸ���ǰ������Ϊinf
%       MaxFront,   ��������ǰ����

    if nargin < 2
        Kind = 1;
    elseif strcmp(Operation,'half')
        Kind = 2;
    elseif strcmp(Operation,'first')
        Kind = 3;
    else
        Kind = 1;
    end
	[N,M] = size(FunctionValue);%��һ�е���ֵ�������ƶ�ÿһ�У������һ�е���ֵ����ͬ�ģ��������ұȽ�
    
    MaxFront = 0;
    cz = zeros(1,N);
    FrontValue = zeros(1,N)+inf;
    [FunctionValue,Rank] = sortrows(FunctionValue);
    while (Kind==1 && sum(cz)<N) || (Kind==2 && sum(cz)<N/2) || (Kind==3 && MaxFront<1)
        MaxFront = MaxFront+1;
        d = cz;%�Ѿ��������е�i
        for i = 1 : N
            if ~d(i)%�����ǰ��һ������֧�䣬��һ��f1��СĬ�ϲ���֧��
                for j = i+1 : N
                    if ~d(j)
                        k = 1;
                        for m = 2 : M
                            if FunctionValue(i,m) > FunctionValue(j,m)%ǰ1��2����С�ں�������һ����֧��
                                k = 0;
                                break;
                            end
                        end
                        if k == 1
                            d(j) = 1;
                        end
                    end
                end
                FrontValue(Rank(i)) = MaxFront;
                cz(i) = 1;
            end
        end
    end
end



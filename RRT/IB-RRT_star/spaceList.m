
% ����point��������Space�ռ��ҵ��������Ŀռ䣨bΪ0��ʾ�������ɿռ䣬bΪ1��ʾ�����ϰ��ռ䣩
function b = spaceList (point,Space)
    if (point(1) == 0)
            point(1) = 1;
        end
        if (point(2) == 0)
            point(2) = 1;
        end
        if (point(3) == 0)
            point(3) = 1;
        end
    b = Space((point(1)-1)*10000+(point(2)-1)*100+point(3),4);
end
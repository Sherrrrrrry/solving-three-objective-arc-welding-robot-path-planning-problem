
% 根据point的坐标在Space空间找到其所属的空间（b为0表示处于自由空间，b为1表示处于障碍空间）
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
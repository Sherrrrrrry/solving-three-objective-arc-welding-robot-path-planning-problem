function city = swap_three(city,n)
city = city';
    ind1 = 0; ind2 = 0; ind3 = 0;
    while (ind1 == ind2) || (ind1 == ind3) ...
            || (ind2 == ind3) || (abs(ind1-ind2) == 1)
        ind1 = ceil(rand.*n);
        ind2 = ceil(rand.*n);
        ind3 = ceil(rand.*n);
    end
    tmp1 = ind1;tmp2 = ind2;tmp3 = ind3;
    % È·±£ind1 < ind2 < ind3
    if (ind1 < ind2) && (ind2 < ind3)
        ;
    elseif (ind1 < ind3) && (ind3 < ind2)
        ind2 = tmp3;ind3 = tmp2;
    elseif (ind2 < ind1) && (ind1 < ind3)
        ind1 = tmp2;ind2 = tmp1;
    elseif (ind2 < ind3) && (ind3 < ind1)
        ind1 = tmp2;ind2 = tmp3; ind3 = tmp1;
    elseif (ind3 < ind1) && (ind1 < ind2)
        ind1 = tmp3;ind2 = tmp1; ind3 = tmp2;
    elseif (ind3 < ind2) && (ind2 < ind1)
        ind1 = tmp3;ind2 = tmp2; ind3 = tmp1;
    end
   tmplist1 = city((ind1+1):(ind2-1),:);
    city((ind1+1):(ind1+ind3-ind2+1),:) = ...
        city((ind2):(ind3),:);
    city((ind1+ind3-ind2+2):ind3,:) = ...
        tmplist1;
city = city';

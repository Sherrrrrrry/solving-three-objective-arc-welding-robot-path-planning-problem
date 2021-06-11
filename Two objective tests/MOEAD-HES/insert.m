function city = insert(city,n)
    
    ind1 = 0; ind2 = 0;
    while (ind1 == ind2)
        ind1 = ceil(rand.*n);
        ind2 = ceil(rand.*n);
    end
    if ind1 > ind2
        temp = ind1;
        ind1 = ind2;
        ind2 = temp;
    end
    templist = city(ind1:ind2);
    for i = 0:(ind2-ind1-1)
        city(ind1+i) = templist(i+2);
    end
    city(ind2) = templist(1);

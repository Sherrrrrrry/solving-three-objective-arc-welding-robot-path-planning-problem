function city = swap_two(city,n)
%     points = randi(n,1,2);
%     while ~all(diff(points))
%         points = randi(n,1,2);
%     end
%     temp = city(points(1),:);
%     city(points(1),:) = city(points(2),:);
%     city(points(2),:) = temp;

    ind1 = 0; ind2 = 0;
    while (ind1 == ind2)
        ind1 = ceil(rand.*n);
        ind2 = ceil(rand.*n);
    end
%     tmp1 = city(:,ind1);
%     city(:,ind1) = city(:,ind2);
%     city(:,ind2) = tmp1;
%     
    city=city';
    tmp1 = city(ind1,:);
    city(ind1,:) = city(ind2,:);
    city(ind2,:) = tmp1;
    city=city';
end
            
            
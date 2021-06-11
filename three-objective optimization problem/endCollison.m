function collison_end = endCollison(G_ob_simply,xGoal)
    collison_end = 0;
    % obs±ÜÕÏ¼ì²â
    for i = 1:size(G_ob_simply,1)
        if (xGoal(1)>=G_ob_simply(i,1) && xGoal(1)<=G_ob_simply(i,1)+G_ob_simply(i,4))...
            && (xGoal(2)>=G_ob_simply(i,2) && xGoal(2)<=G_ob_simply(i,2)+G_ob_simply(i,5))...
            && (xGoal(3)>=G_ob_simply(i,3) && xGoal(3)<=G_ob_simply(i,3)+G_ob_simply(i,6))
            collison_end = 1;  % Åö×² 1 ÎÞÅö×² 0
            break;
        end
    end
end
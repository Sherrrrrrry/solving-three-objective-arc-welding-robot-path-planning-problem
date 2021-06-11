load('weldpoint.mat');
load('weldpoint_adjust');
distance = zeros(30,30);
for i =1 : 30
    for j = 1: 30
        if ((i==j)||(i==1 && j==2)||(i==3 && j==4)||(i==5 && j==6)||(i==7 && j==8)||(i==9 && j==10)||(i==11 && j==12)||(i==13 && j==14)...
                ||(i==15 && j==16)||(i==17 && j==18)||(i==19 && j==20)||(i==21 && j==22)||(i==23 && j==24)||(i==25 && j==26)||(i==27 && j==28)...
                ||(i==29 && j==30)||(i==2 && j==1)||(i==4 && j==3)||(i==6 && j==5)||(i==8 && j==7)||(i==10 && j==9)||(i==12 && j==11)||(i==14 && j==13)...
                ||(i==16 && j==15)||(i==18 && j==17)||(i==20 && j==19)||(i==22 && j==21)||(i==24 && j==23)||(i==26 && j==25)||(i==28 && j==27)...
                ||(i==30 && j==29))
            continue;
        end
        filename = strcat(num2str(i),'_',num2str(j),'.mat');
        load(filename);
        Path = cell2mat(Path);
        Path = Path(:,1:3);
        path = [weldpoint(i,:);Path;weldpoint(j,:)];
        saldir ='C:\Users\gu\Desktop\ZX\distance_metric\';
        filename=[saldir 'new',num2str(i),'_',num2str(j),'.mat'];
%         filename=strcat('new',num2str(i),'_',num2str(j),'.mat');
        save(filename,'path'); 
        pathlength = 0;
        for k=1:size(path,1)-1 
            distance(i,j)=distance(i,j)+norm(path(k,:)-path(k+1,:));
        end
    end
end
 save distance; 
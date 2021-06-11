function [Offspring,Offspring_mu] = F_generator(MatingPool,crosP,mutP,Zind)

% Crossover
    Num = size(MatingPool,2);
    A =randi(Num,1,2);
    A = sort(A);
    indexA = A(1);
    indexB = A(2);
    Offspring = MatingPool(1,:);
    m = rand();
    Genes = MatingPool(1,indexA+1:indexB);
    parentGenes =[MatingPool(1,1:indexA),MatingPool(1,indexB+1:end)];
    Genes2 = MatingPool(2,indexA+1:indexB);
    parentGenes2 = [MatingPool(2,1:indexA),MatingPool(2,indexB+1:end)];
    if m < crosP
        Offspring =  [fliplr(Genes2),parentGenes];
        repeatgene1 = intersect(parentGenes,Genes2,'stable');
        [repeatgene2, ink] = intersect(parentGenes2,Genes,'stable');
        F=[];
        for n = 1:numel(repeatgene1)
            x = find(Offspring == repeatgene1(n));
            x = x(x>(indexB-indexA));
            Offspring(x) = repeatgene2(n);
            F = [F;x];
        end
        Off2 = Offspring(1:numel(Genes));
        Off1 = Offspring(numel(Genes)+1:numel(Genes)+indexA);
        Off3 = Offspring(numel(Genes)+indexA+1:end);
        Offspring = [Off1,Off2,Off3];
    else
        Offspring = Zind(1,:);
    end

% Mutation
Offspring_mu = [];
    if rand() < mutP
        if rand < 0.3
            Offspring_mu = Mutate(Offspring);
        elseif rand < 0.6
            Offspring_mu = insert(Offspring,Num);
        else
            Offspring_mu = swap_three(Offspring,Num);
        end
    end

end
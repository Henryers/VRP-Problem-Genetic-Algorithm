clear
clc

maxgen = 200; % 最大迭代次数
size = 50;  % 种群个体数量
pcross = 0.6;
pmutation = 0.01;

lenchrom = [1,1,1];   % 染色体情况，长度为3，每个取值为[-5,5]
bound = [-5, 5; -5, 5; -5, 5];

% 个体结构体：包括 适应度fitness、基因排列情况chrom
individuals = struct('fitness', zeros(1, size), 'chrom', []);
avgfitness = [];
bestfitness = [];
bestchrom = [];

% 初始化种群中所有个体
for i = 1 : size
    % 初始化所有个体的基因排列情况
    individuals.chrom(i, :) = Produce(lenchrom, bound);
    x = individuals.chrom(i, :);
    % 根据基因情况算出每个个体的适应度
    individuals.fitness(i) = square(x);
end

[bestfitness, bestindex] = min(individuals.fitness);
bestchrom = individuals.chrom(bestindex, :);
avgfitness = sum(individuals.fitness) / size;

trace = [];
for i = 1 : maxgen
    % 选择: Select函数选出来的新种群也是满足size大小
    individuals = Select(individuals, size);

    % 交叉
    individuals.chrom = Cross(pcross, lenchrom, individuals.chrom, size, bound);

    % 变异
    individuals.chrom = Mutation(pmutation, lenchrom, individuals.chrom, size, [i, maxgen], bound);

    % 所有个体的适应度 fitness 重新计算
    for j = 1: size
        x = individuals.chrom(j, :);
        individuals.fitness(j) = square(x);
    end

    % 重新选出最优的适应度和基因排列情况，进行迭代
    [newbestfitness, newbestindex] = min(individuals.fitness);
    [worstfitness, worstindex] = max(individuals.fitness);
    if bestfitness > newbestfitness
        bestfitness = newbestfitness;
        bestchrom = individuals.chrom(newbestindex, :);
    end
    individuals.chrom(worstindex, :) = bestchrom;
    individuals.fitness(worstindex) = bestfitness;
 
    avgfitness = sum(individuals.fitness) / size;
    trace = [trace; avgfitness, bestfitness];
end


figure
plot((1 : maxgen)', trace(:, 1), 'r-', (1: maxgen)', trace(:, 2), 'b--');
title(['函数值曲线' '终止代数=' num2str(maxgen)], 'FontSize', 12);
xlabel('进化代数', 'FontSize', 12);
ylabel('函数值', 'FontSize', 12);
legend('各代平均值', '各代最佳值', 'fontsize', 12);
ylim([-0.5, 5])
disp('函数值                    变量')
disp([bestfitness, x]);



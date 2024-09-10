% 选择
function ret = Select(individuals, size)

% 取倒数，得到适应度值
individuals.fitness = 1 ./ individuals.fitness;
sumfitness = sum(individuals.fitness);

% 轮盘：每个个体被选择的概率
sumf = individuals.fitness ./ sumfitness;

index = [];

% 进行 size 次轮盘选择操作，重新选择出新的种群个体，同时和旧种群一样都是 size 个
for i = 1 : size
    % 随机选一个值
    pick = rand;
    while pick == 0
        pick = rand;
    end
    % 不断减去概率，看哪个个体的值刚好落到0附近，即轮盘选中这个个体
    for j = 1 : size
        pick = pick - sumf(j);
        if pick < 0
            % 选中的个体，其索引加到index数组里
            index = [index, j];
            break
        end
    end
end

% 新选择的个体对应的索引都在index数组里，拿到这些个体并更新individuals信息
individuals.chrom = individuals.chrom(index, :);
individuals.fitness = individuals.fitness(:, index);
ret = individuals;



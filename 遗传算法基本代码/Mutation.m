% 变异
function ret = Mutation(pmutation, lenchrom, chrom, size, pop, bound)

for i = 1: size
    % size 个 个体里面随机选择一个
    pick = rand;
    while pick  == 0
        pick = rand;
    end
    index = ceil(pick * size);

    % 随机值 > pmutation 就不用基因突变，直接遍历下一个个体，否则需要突变处理
    pick = rand;
    if pick > pmutation
        continue;
    end

    % 和交叉类过程类似，这个染色体需要在某个点位进行基因突变
    flag = 0;
    while flag == 0
        pick = rand;
        while pick == 0
            pick = rand;
        end
        pos = ceil(pick * sum(lenchrom));
        v = chrom(i, pos);

        % 变异的方法可以重新生成随机数，也可以按下面复杂公式生成
        v1 = v - bound(pos, 1);
        v2 = bound(pos, 2) - v;
        pick = rand;
        if pick > 0.5
            delta = v2 * (1 - pick ^ ((1 - pop(1) / pop(2)) ^ 2));
            chrom(i, pos) = v + delta;
        else
            delta = v1 * (1 - pick ^ ((1 - pop(1) / pop(2)) ^ 2));
            chrom(i, pos) = v + delta;
        end
        flag = test(lenchrom, bound, chrom(i, :));
    end
end

ret = chrom;



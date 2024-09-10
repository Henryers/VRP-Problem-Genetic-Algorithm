% 交叉
function ret = Cross(pcross, lenchrom, chrom, size, bound)

% 遍历所有个体
for i = 1 : size
    % disp('-------------------- 脑瘫!!!!! 停下!!!!!!-----------------------------')
    % disp(i)
    % 选出两个个体
    pick = rand(1,2);
    while prod(pick) == 0
        pick = rand(1,2);
    end
    % 随机数扩大50倍并向上取整，得到两个个体的索引
    index = ceil(pick .* size);

    % 随机选一个值，如果大于pcross，就不进行染色体交叉，否则交叉
    pick = rand;
    while pick == 0
        pick = rand;
    end
    if pick > pcross
        continue;
    end

    % 这对染色体需要在某个点位进行交叉互换
    flag = 0;
    while flag == 0
        pick = rand;
        while pick == 0
            pick = rand;
        end
        % 随机点位
        pos = ceil(pick .* sum(lenchrom));
        pick = rand;
        % v1 v2 为这两个染色体对应点位上的内容

        % disp('chrom如下')
        % disp(chrom)
        % disp(index)
        % disp(pos)
        % disp('为什么报错？！！！')
        % disp('第几次啊!!!')
        % disp(i)

        v1 = chrom(index(1), pos);
        v2 = chrom(index(2), pos);
        % pick = 1 交换    pick = 0 原样   由于是数值，所以pick可以是0-1之间的任意值，数值改了就算有交换
        chrom(index(1), pos) = pick * v2 + (1 - pick) * v1;
        chrom(index(2), pos) = pick * v1 + (1 - pick) * v2;
        flag1 = test(lenchrom, bound, chrom(index(1), :));
        flag2 = test(lenchrom, bound, chrom(index(2), :));
        if flag1 * flag2 == 0
            flag = 0;
        else
            flag = 1;
        end
    end
end
ret = chrom;
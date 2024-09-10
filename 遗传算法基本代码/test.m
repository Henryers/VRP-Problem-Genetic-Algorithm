% 测试重新生成会不会越界错误
function flag = test(lenchrom, bound, singlechrom)

flag = 1;
[n, ~] = size(singlechrom); % 拿到行数，忽略列数
% singlechrom是一个个体染色体的情况，对每个点位进行遍历，需要都满足不能越界
for i = 1 : n
    if singlechrom(i) < bound(i, 1) || singlechrom(i) > bound(i, 2)
        flag = 0;
    end
end

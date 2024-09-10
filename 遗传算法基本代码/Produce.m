function ret = Produce(lenchrom, bound)

% flag = 0;
% while flag == 0
    pick = rand(1, length(lenchrom));
    ret = bound(:, 1)' + (bound(:, 2) - bound(:, 1))' .* pick;
    % 可能交叉后不满足情况，因此需要用test函数进行检验
    % flag = test(lenchrom, bound, ret);
% end
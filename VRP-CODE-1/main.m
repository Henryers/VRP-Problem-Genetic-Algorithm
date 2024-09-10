function main()

    % 从excel里面读取数据
    filename = '../data/dp.xlsx';
    cNode = 30;  % 送货节点数量（不包括快递公司）

     % 30个送货点、1个总公司，共31个
    x = zeros(cNode + 1, 1);
    y = zeros(cNode + 1, 1);
    demand = zeros(cNode + 1, 1);
    
    % 配送中心的坐标
    x(1) = 0;
    y(1) = 0;
    demand(1) = 0;
    
    % 读取客户的坐标和需求量
    customers = readmatrix(filename, 'Range', sprintf('B2:D%d', 2 + cNode - 1));  % 读取30行数据
    x(2:end) = customers(:, 1);
    y(2:end) = customers(:, 2);
    demand(2:end) = customers(:, 3);
    
    % 读取车辆数量
    cCar = 30;
    
    % 读取车辆的容量和距离限制

    capacity = 25 * ones(cCar, 1);
    timeLimit = 360 * ones(cCar, 1);
    disp(capacity(10))

    
    % 求解 VRP
    % 初始化 paths 为一个空数组
    paths = [];
    times = [];
    allMiles = [];
    numCars = [];

    % 对其中一个参数进行改变，实验10次，进行敏感性分析用的
    % for i = 1:10:101
    %     [path, time, allMile, numCar] = Export(cNode + 1, x, y, demand, cCar, capacity, timeLimit, 1, 1, i, @Callback);
    %     paths = [paths, path];
    %     times = [times, time];
    %     allMiles = [allMiles, allMile];
    %     numCars = [numCars, numCar];
    % end

    % 正常跑一次下面的代码就是一次完整的遗传算法求解流程
    [path, time, allMile, numCar] = Export(cNode + 1, x, y, demand, cCar, capacity, timeLimit, 1, 1, 10, @Callback);
    paths = [paths, path];
    times = [times, time];
    allMiles = [allMiles, allMile];
    numCars = [numCars, numCar];

    disp(times)
    disp(allMiles)
    disp(numCars)

    % 画这两个图也是针对敏感性分析的，不做分析就不用画
    % % s=1 不同的 w_n 对应的总里程
    % figure('Position', [100, 100, 800, 600]); % 创建一个适合论文展示的图形窗口
    % plot(allMiles, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % 增加线宽和标记大小
    % 
    % xlabel('$w_n$', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % X轴标签，使用LaTeX解释器
    % ylabel('Total Miles', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % Y轴标签，使用LaTeX解释器
    % title('Total Miles for Different $w_n$ Values', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex'); % 图形标题，使用LaTeX解释器
    % ylim([300, max(allMiles) + 2]); % 设置 y 轴从 0 开始，最大值略高于数据的最大值
    % grid on; % 打开网格
    % 
    % set(gca, 'FontSize', 12, 'FontWeight', 'bold'); % 设置轴的字体大小和粗细
    % box on; % 在图形周围添加边框
    % 
    % % 在每个数据点旁边显示数字，保留1位小数点
    % for i = 1:length(allMiles)
    %     text(i, allMiles(i) - 6, num2str(allMiles(i), '%.1f'), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    % end
    % 
    % 
    % % s=1 不同的 w_n 对应的总快递员数量
    % figure('Position', [100, 100, 800, 600]); % 创建一个适合论文展示的图形窗口
    % plot(numCars, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % 增加线宽和标记大小
    % 
    % xlabel('$w_n$', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % X轴标签，使用LaTeX解释器
    % ylabel('The number of Couriers', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % Y轴标签，使用LaTeX解释器
    % title('Couriers for Different $w_n$ Values', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex'); % 图形标题，使用LaTeX解释器
    % ylim([0, max(numCars) + 2]); % 设置 y 轴从 0 开始，最大值略高于数据的最大值
    % grid on; % 打开网格
    % 
    % set(gca, 'FontSize', 12, 'FontWeight', 'bold'); % 设置轴的字体大小和粗细
    % box on; % 在图形周围添加边框
    
    % 在每个数据点旁边显示数字，保留1位小数点
    % for i = 1:length(numCars)
    %     text(i, numCars(i) - 0.5, num2str(numCars(i), '%.1f'), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    % end
    % 
    % % 输出结果（回调函数里写的）
    % for i = 1:cCar
    %     if pathLen(i) > 0
    %         fprintf('车辆 %d:\t', i);
    %         fprintf('%d ', path{i});
    %         fprintf('负载: %.2f 行驶里程: %.2f\n', load(i), mileage(i));
    %     end
    % end

    % 调用画图函数
    img(x, y, path);


end


function [time, allMile] = Callback(numCar, path, pathLen, load, mileage, time)
    % 回调函数
    % 总里程
    allMile = 0.0;
    % 输出每辆车的路径、负载和行驶里程
    for i = 1:numCar
        if pathLen(i) > 0
            fprintf('车辆 %d:\t', i);
            fprintf('%d ', path{i});
            fprintf('负载: %.2f 行驶里程: %.2f\n', load(i), mileage(i));
            allMile = allMile + mileage(i);
        end
    end
    fprintf('总时间: %.2f 行驶里程: %.2f\n', time, allMile);
end




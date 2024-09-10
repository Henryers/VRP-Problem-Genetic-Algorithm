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
    % 速度有变化，距离用时间单位来代替（单位：分钟）
    timeLimit = 360 * ones(cCar, 1);
    % 要加money了
    cost = zeros(cCar, 1);
    disp(capacity(10))

    % 求解 VRP
    [path, pathLen, load, mileage] = Export(cNode + 1, x, y, demand, cCar, capacity, timeLimit, cost, 100, 1, 1, @Callback);
    
    % 输出结果（回调函数里写的）
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


function Callback(numCar, path, pathLen, load, mileage, time)
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




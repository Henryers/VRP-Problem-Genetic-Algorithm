% 类似接口函数，提供VRP接口
function [path, pathLen, load, mileage] = Export(numNode, x, y, demand, numCar, capacity, timeLimit, cost, k1, k2, k3, Callback)

    % 创建 VRP 对象
    vrp = VRP();
    % 添加节点信息
    for i = 1:numNode
        vrp.addNode(x(i), y(i), demand(i));
    end
    disp(numNode)

    % 添加车辆信息
    for i = 1:numCar
        vrp.addCar(capacity(i), timeLimit(i), cost(i));
    end

    % 设置权重
    vrp.setWeights(k1, k2, k3);

    % 调用vrp中的函数求解
    res = vrp.solve();

    % disp(res.toString());

    % 提取结果
    path = cell(numCar, 1);  % 每个元素都是一个路径集合，而不是一个值，所以不用zeros
    pathLen = zeros(numCar, 1); % 记录该辆车经过的节点个数
    load = zeros(numCar, 1);
    mileage = zeros(numCar, 1);
    time = res.time;

    for i = 1:numCar
        cNode = length(res.path{i});
        path{i} = res.path{i};
        pathLen(i) = cNode;
        load(i) = res.load(i);
        mileage(i) = res.mileage(i);
    end

    % 调用回调函数
    Callback(numCar, path, pathLen, load, mileage, time);
end

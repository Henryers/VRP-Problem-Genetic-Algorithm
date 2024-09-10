classdef Chrom
    properties
        nodeInfo
        carInfo
        dis
        gene
        time        % 时间矩阵
        mileage     % 里程矩阵
        load        % 负载矩阵
        allTime     % 总时间
        allMileage  % 总里程
        courierNum  % 快递员人数
        valid
        k1
        k2
        k3
    end
    
    methods
        % 构造方法
        function obj = Chrom(vrp)

            % 初始化节点信息和车辆信息
            obj.nodeInfo = vrp.nodeInfo;
            obj.carInfo = vrp.carInfo;
            obj.dis = vrp.dis;
            obj.k1 = vrp.k1;
            obj.k2 = vrp.k2;
            obj.k3 = vrp.k3;
            
            cNode = length(obj.nodeInfo) - 1;
            cCar = length(obj.carInfo);
            
            % 记录各辆车的行驶时间、里程和装载货物重量，共cCar辆车
            obj.time = zeros(cCar, 1);
            obj.mileage = zeros(cCar, 1);
            obj.load = zeros(cCar, 1);
            
            % 初始化基因序列，由所有节点编号组成
            obj.gene = 1:cNode;
            % rng('shuffle'); % 确保每次运行时生成不同的随机序列
            obj.gene = obj.gene(randperm(cNode));
            % obj.gene = [3, 2, 1, 0, 10, 8, 0, 9, 5, 4, 0, 6, 7, 0];
 
            % 对基因序列进行结果的初始化，得到一个满足题目要求但不是最优解的结果
            % 序列之间用0隔开，代表不同车运输的情况
            index = 1;
            for i = 1:cCar - 1  % 循环cCar-1次就插入这么多次分隔符0
                % 而且每次车都尽可能装满货物，不可能出现最后一辆车还装不下的情况
                sum = 0.0;
                last = 1;
                allTime = 0.0;
                while true
                    % 约束：不能越界、不能超重、总里程不能超过约束！
                    % 1、不能越界
                    if index > length(obj.gene)
                        break;
                    end
                    % 2、不能超重
                    sum = sum + obj.nodeInfo(obj.gene(index)+1).demand;
                    if sum > obj.carInfo(i).capacity
                        break;
                    end
                    % 3、不能超时间（停留一次送货点10分钟）
                    allTime = allTime + obj.dis(last, obj.gene(index)+1)*2.4 + 10;
                    last = obj.gene(index)+1;
                    if (allTime + obj.dis(last, 1)*2.4) > obj.carInfo(i).timeLimit
                        break;
                    end
                    % 该辆车没超重，没超出总里程，就尝试前往下一个城市运输货物
                    index = index + 1;
                end
                % 最终退出循环时，车辆只能装到index-1这个地方的货物
                % index这个节点装不下的/总里程过长/越界的，所以才退出循环
                % 因此基因要在index处插入0，作为车辆运输货物的节点集合分隔符
                obj.gene = [obj.gene(1:index-1), 0, obj.gene(index:end)];
                % 跳过分隔符，由下一辆车开始，运输下一座城市的货物
                index = index + 1;
            end

            % 第一次更新不会超重，前面初始化已经做过处理了
            obj = obj.update();
        end
        
        function obj = update(obj)
            % 更新时间、里程和载荷
            for i = 1 : length(obj.mileage) % 其实就是车辆数量
                obj.time(i) = 0.0;
                obj.mileage(i) = 0.0;
                obj.load(i) = 0.0;
            end
            
            iCar = 1;   % 车辆索引
            last = 1;   % 节点索引，1代表快递公司处，其他代表送货点
            % 对基因序列进行遍历
            for i = 1 : length(obj.gene)
                % 遇到分隔符
                if obj.gene(i) == 0
                    % 送完了，要返回快递公式，因此需要加上当前位置last到快递公司1的距离
                    obj.mileage(iCar) = obj.mileage(iCar) + obj.dis(last, 1);
                    % fprintf('iCar的里程mileage为：%.2f\n', obj.mileage(iCar))

                    % 耗时约束: 当前耗时 + 回到公司耗时 < 总时间约束，才符合条件
                    obj.time(iCar) = obj.time(iCar) + obj.dis(last, 1) * 2.4;
                    if obj.time(iCar) > obj.carInfo(iCar).timeLimit
                        % disp('变异产生的新个体不合格')
                        obj.valid = false;
                        return;
                    end
                    iCar = iCar + 1;  % 下一辆车来送
                    last = 1;         % 从快递公司出发
                % 没遇到分隔符
                else   
                    % 之前承载加上当前送货点的重量
                    obj.load(iCar) = obj.load(iCar) + obj.nodeInfo(obj.gene(i)+1).demand;
                    % 超重，标记valid为false，直接return掉，后面不做处理
                    if obj.load(iCar) > obj.carInfo(iCar).capacity
                        obj.valid = false;
                        return;
                    end
                    % 不满足先return，满足了才进行下面一系列操作
                    % 当前快递员耗时
                    obj.time(iCar) = obj.time(iCar) + obj.dis(last, obj.gene(i)+1)*2.4 + 10;
                    % 从上次位置last出发，到当前点的距离（距离矩阵中第一个点是快递公司，所以要+1）
                    obj.mileage(iCar) = obj.mileage(iCar) + obj.dis(last, obj.gene(i)+1);

                    % 迭代，位置更新
                    last = obj.gene(i)+1;

                    % todo: 可能有其他约束
                    
                end
            end
            % 最后一辆任务车还要加上回快递公司的距离
            obj.mileage(iCar) = obj.mileage(iCar) + obj.dis(last, 1);
            obj.time(iCar) = obj.time(iCar) + obj.dis(last, 1) * 2.4;
            % 最后一辆车的耗时约束
            if obj.time(iCar) > obj.carInfo(iCar).timeLimit
                % disp('变异产生的新个体不合格')
                obj.valid = false;
                return;
            end

            % time length cnt 就是三个优化评价指标

            % 总时间就是所有车之中耗时最久的
            obj.allTime = max(obj.time);
            % 所有车辆行驶总里程
            obj.allMileage = sum(obj.mileage);
            % 有进行运输的车辆数（有行驶里程的就是有运输的）
            obj.courierNum = sum(obj.mileage > 0);

            % 前面false已经return掉了，现在到这里的肯定为true
            obj.valid = true;
        end
        
        function obj = mutation(obj)
            % % 随机交换基因
            % i = randi(length(obj.gene));
            % j = randi(length(obj.gene));
            % temp = obj.gene(i);
            % obj.gene(i) = obj.gene(j);
            % obj.gene(j) = temp;
            % 
            % % 更新后验证合法性
            % temp_time = obj.time;
            % temp_length = obj.length;
            % temp_cnt = obj.cnt;
            % obj = obj.update();
            % if ~obj.valid
            %     % 交换无效，恢复原状
            %     temp = obj.gene(i);
            %     obj.gene(i) = obj.gene(j);
            %     obj.gene(j) = temp;
            %     obj.time = temp_time;
            %     obj.length = temp_length;
            %     obj.cnt = temp_cnt;
            %     obj.valid = true;
            % end

            % 上面这样变异率太低了，没用，最优解一直是第一个个体
            obj.valid = false;  % 变异合法且不变坏，才让你退出
            while ~obj.valid
                % 重新随机交换基因
                % rng('shuffle'); % 设置随机数生成器的种子为当前时间
                i = randi(length(obj.gene));
                j = randi(length(obj.gene));
                temp = obj.gene(i);
                obj.gene(i) = obj.gene(j);
                obj.gene(j) = temp;
                
                % 更新后验证合法性
                temp_time = obj.allTime;
                temp_length = obj.allMileage;
                temp_cnt = obj.courierNum;
                obj = obj.update();  % 会为valid赋值的，更新成功才退出循环
                if ~obj.valid
                    % 交换无效，恢复原状，但是valid还是false，因为根本没更新，不能退出循环
                    temp = obj.gene(i);
                    obj.gene(i) = obj.gene(j);
                    obj.gene(j) = temp;
                    obj.allTime = temp_time;
                    obj.allMileage = temp_length;
                    obj.courierNum = temp_cnt;
                end
            end
        end
        
        function f = fitness(obj)
            % 计算适应度
            if ~obj.valid
                f = 1e8;   % 很大的数，说明不适应
            else
                % 根据三个指标，分配权重后，计算出最终评价指标值，越小越好！
                f = obj.k1 * obj.allTime + obj.k2 * obj.allMileage + obj.k3 * obj.courierNum;
            end
        end
        
        % 重载比较运算符，这样sort就知道要根据fitness的大小进行升序排序了
        % 而且刚好小的排在前面，最小的就算是所有个体的最优解
        function b = lt(obj, c)
            % 比较适应度
            b = obj.fitness() < c.fitness();
        end
                
        % 上面重载还不够
        function sortedArr = sort(objArray)
            % 根据元素中的函数计算出来的评价值不是属性，不能直接比较！要用arrayfun
            [~, idx] = sort(arrayfun(@(x) x.fitness(), objArray));
            % [~, idx] = sort([objArray.fitness]);
            sortedArr = objArray(idx);
        end
        
        function obj = copyFrom(obj, c)
            % 复制基因信息
            obj.gene = c.gene;
            obj.mileage = c.mileage;
            obj.load = c.load;
            obj.allTime = c.time;
            obj.allMileage = c.length;
            obj.courierNum = c.cnt;
            obj.valid = c.valid;
        end
        
        function res = decode(obj)
            disp('基因序列')
            disp(obj.gene)
            % 解码结果
            res.path = cell(length(obj.carInfo), 1);
            res.load = obj.load;
            res.mileage = obj.mileage;
            res.time = obj.allTime;
            
            % 结果就是一个字典，索引是车辆，值是该车辆经过的节点集合
            iCar = 1;
            for i = 1:length(obj.gene)
                if obj.gene(i) == 0
                    iCar = iCar + 1;
                else
                    res.path{iCar} = [res.path{iCar}, obj.gene(i)];
                end
            end

            % 统计快递员数量
            nonzero_count = 0;
            % 遍历元胞数组中的每个元素
            for i = 1:length(res.path)
                if ~isempty(res.path{i})  % 忽略空的 0x0 double 元素
                    nonzero_count = nonzero_count + 1;
                end
            end

            res.num = nonzero_count;
        end
        
        function s = toString(obj)
            % 转为字符串，遍历基因中每个节点数字，转为字符串后再接空格不断拼接
            s = 'gene: ';
            for i = 1:length(obj.gene)
                s = [s, num2str(obj.gene(i)), ' '];
            end
        end
    end
end

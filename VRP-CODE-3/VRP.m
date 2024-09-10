classdef VRP < handle
    properties
        cNode
        cCar
        k1
        k2
        k3
        nodeInfo
        carInfo
        dis
        update_num
    end
    
    methods
        function obj = VRP()
            obj.cNode = 0;
            obj.cCar = 0;
            obj.k1 = 1.0;
            obj.k2 = 1.0;
            obj.k3 = 1.0;
            obj.nodeInfo = [];
            obj.carInfo = [];
            obj.update_num = 0;
        end
        
        function obj = readDataFromFile(obj, filename)
            % 读取文件
            fid = fopen(filename, 'r');
            if fid == -1
                error('无法打开文件: %s', filename);
            end
            
            % 读取节点数量
            obj.cNode = fscanf(fid, '%d', 1);
            
            % 读取配送中心坐标
            x0 = fscanf(fid, '%lf', 1);
            y0 = fscanf(fid, '%lf', 1);
            obj.nodeInfo = [obj.nodeInfo, Node(0, x0, y0, 0.0)];
            
            % 读取客户节点
            for i = 1:obj.cNode
                x = fscanf(fid, '%lf', 1);
                y = fscanf(fid, '%lf', 1);
                d = fscanf(fid, '%lf', 1);
                obj.nodeInfo = [obj.nodeInfo, Node(i, x, y, d)];
            end
            
            % 读取车辆数量
            obj.cCar = fscanf(fid, '%d', 1);
            
            % 读取车辆信息
            for i = 1:obj.cCar
                w = fscanf(fid, '%lf', 1);  % 载重约束
                d = fscanf(fid, '%lf', 1);  % 里程约束
                obj.carInfo = [obj.carInfo, Car(i, w, d)];
            end
            
            fclose(fid);
        end
        
        function obj = addNode(obj, x, y, demand)
            obj.nodeInfo = [obj.nodeInfo, Node(obj.cNode, x, y, demand)];
            obj.cNode = obj.cNode + 1;
        end
        
        function obj = addCar(obj, capacity, disLimit)
            obj.carInfo = [obj.carInfo, Car(obj.cCar, capacity, disLimit)];
            obj.cCar = obj.cCar + 1;
        end
        
        function obj = setWeights(obj, k1, k2, k3)
            obj.k1 = k1;
            obj.k2 = k2;
            obj.k3 = k3;
        end
        
        function s = toString(obj)
            s = 'Node info:\n';
            for i = 1:length(obj.nodeInfo)
                s = [s, obj.nodeInfo(i).toString(), '\n'];
            end
            
            s = [s, '\nCar info:\n'];
            for i = 1:length(obj.carInfo)
                s = [s, obj.carInfo(i).toString(), '\n'];
            end
        end
        
        function res = solve(obj)
            % 预处理所有边的距离（欧式距离），距离矩阵和我用python写的一样
            obj.dis = zeros(obj.cNode, obj.cNode);
            for i = 1:obj.cNode
                for j = 1:obj.cNode
                    obj.dis(i, j) = sqrt((obj.nodeInfo(i).x - obj.nodeInfo(j).x)^2 + (obj.nodeInfo(i).y - obj.nodeInfo(j).y)^2);
                end
            end
            
            % 初始化种群，每个个体就是一个基因序列，代表着一个可能的结果
            chroms = [];
            while length(chroms) < 2000
                c = Chrom(obj);
                if c.valid
                    chroms = [chroms, c];
                    disp(chroms);
                end
            end
            
            % 遗传算法
            % cnt 是一个计数器，用于记录遗传算法中连续未找到更优解的代数
            % 当 cnt 达到某个预设的阈值时，算法会终止，用于避免算法陷入无限循环
            cnt = 0;
            numGeneration = 0;  % 代数：种群繁衍到第几代
            best = Chrom(obj);

            while true
                numGeneration = numGeneration + 1;
                % 重载了 lt < ，因此内置的sort函数能根据fitness进行升序排序
                % disp(chroms);
                chroms = sort(chroms);

                % disp(best.fitness())

                % 对1000个个体进行排序后，第一个就算当前代的最优解（局部最优解）
                if chroms(1) < best
                    % disp('更新')
                    disp(best.fitness())
                    obj.update_num = obj.update_num + 1;
                    best = chroms(1);
                    cnt = 0;
                else
                    cnt = cnt + 1;
                    disp(cnt)
                end
                % 无效种群迭代过多，终止迭代（可能已经逼近最优解了，无法再继续了）
                if cnt >= 50
                    break;
                end
                
                % 后面一半的个体，赋值为前一半那些优良个体，同时加入基因突变
                % 这样确保优良迭代的同时，也模拟了不确定性
                halfSize = floor(length(chroms) / 2);
                for i = halfSize+1 : length(chroms)
                    chroms(i) = chroms(i - halfSize);
                    chroms(i) = chroms(i).mutation();
                end
                % 太烂了，重新生成（双种群初始化可以参考借鉴）
                % for i = halfSize+quarterSize:length(chroms)
                %     chroms(i) = Chrom(obj);
                % end
            end
            
            % 解码结果
            disp('看看我更新了几次')
            disp(obj.update_num)
            res = best.decode();
            res.numGeneration = numGeneration;
        end
    end
end

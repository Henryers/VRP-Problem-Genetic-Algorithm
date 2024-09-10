classdef Result
    properties
        numGeneration  % 代数数量
        path           % 车辆路径
        load           % 车辆负载
        mileage        % 车辆里程
    end
    
    methods
        function obj = Result(numGeneration, path, load, mileage)
            % 构造函数，初始化属性
            if nargin > 0
                obj.numGeneration = numGeneration;
                obj.path = path;
                obj.load = load;
                obj.mileage = mileage;
            end
        end
        
        function s = toString(obj)
            % 返回结果信息的字符串表示
            s = ['Generation count: ', num2str(obj.numGeneration), '\n'];
            
            for i = 1:length(obj.path)
                if isempty(obj.path{i})
                    continue;
                end
                
                s = [s, 'Car ', num2str(i-1), ': 0->'];
                for j = 1:length(obj.path{i})
                    s = [s, num2str(obj.path{i}(j)), '->'];
                end
                s = [s, '0 load: ', num2str(obj.load(i)), ...
                    ' mileage: ', num2str(obj.mileage(i)), '\n'];
            end
            
            s = [s, '\ntotal time: ', num2str(obj.totalTime()), ...
                ' total mileage: ', num2str(obj.totalMileage()), ...
                ' car use: ', num2str(obj.totalCarUse()), '\n'];
        end
        
        function time = totalTime(obj)
            % 计算总时间
            time = max(obj.mileage);
        end
        
        function mileage = totalMileage(obj)
            % 计算总里程
            mileage = sum(obj.mileage);
        end
        
        function carUse = totalCarUse(obj)
            % 计算使用的车辆数量
            carUse = sum(cellfun(@(x) ~isempty(x), obj.path));
        end
    end
end

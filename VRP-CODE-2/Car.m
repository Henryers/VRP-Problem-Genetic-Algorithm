classdef Car
    properties
        id          % 车辆编号
        capacity    % 车辆容量
        timeLimit    % 行驶距离限制
        cost        % 快递员获得的酬金
    end
    
    methods
        function obj = Car(id, capacity, disLimit, cost)
            % 构造函数，初始化车辆属性
            obj.id = id;
            obj.capacity = capacity;
            obj.timeLimit = disLimit;
            obj.cost = cost;
        end
        
        function s = toString(obj)
            % 返回车辆信息的字符串表示
            s = ['Car ', num2str(obj.id), ':  \tcapacity: ', num2str(obj.capacity), '\tdistance limit: ', num2str(obj.timeLimit), '\tcost: ', num2str(obj.cost)];
        end
    end
end

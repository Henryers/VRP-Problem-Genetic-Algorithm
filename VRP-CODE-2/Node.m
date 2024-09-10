classdef Node
    properties
        id      % 节点编号
        x       % 节点的 x 坐标
        y       % 节点的 y 坐标
        demand  % 节点的需求
    end
    
    methods
        function obj = Node(id, x, y, demand)
            % 构造函数，初始化节点属性
            obj.id = id;
            obj.x = x;
            obj.y = y;
            obj.demand = demand;
        end
        
        function s = toString(obj)
            % 返回节点信息的字符串表示
            if obj.id == 0
                s = 'Center';
            else
                s = ['Node ', num2str(obj.id)];
            end
            s = [s, ': \t position: (', num2str(obj.x), ', ', num2str(obj.y), ') \t'];
            
            if obj.id ~= 0
                s = [s, 'demand: ', num2str(obj.demand)];
            end
        end
    end
end

classdef Random
    methods(Static)
        % 返回一个在 [a, b] 范围内的随机整数
        function result = UniformInt(a, b)
            result = randi([a, b]);
        end
        
        % 返回一个在 [a, b] 范围内的随机浮点数
        function result = UniformDouble(a, b)
            result = a + (b - a) * rand();
        end
        
        % 打乱一个整数向量
        function Shuffle(v)
            n = length(v);
            for i = n:-1:2
                j = randi([1, i]);
                temp = v(i);
                v(i) = v(j);
                v(j) = temp;
            end
        end
    end
end

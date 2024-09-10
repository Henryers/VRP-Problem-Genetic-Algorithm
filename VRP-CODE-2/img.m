function img(x, y, paths)
    
    % 绘制配送点
    figure;
    scatter(x, y, 'filled', 'k'); % 黑色点
    hold on;

    % 在每个配送点旁边添加编号
    for i = 1:length(x)
        text(x(i), y(i), num2str(i-1), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end

    % plot(x, y, 'k--'); % 连接配送点的虚线
    title('各个快递员行驶路径图');
    xlabel('X 坐标');
    ylabel('Y 坐标');
    
    % 绘制每辆车的路径
    % colors = parula(numel(paths)); % 自动生成不同的颜色
    colors = [
        0.6350, 0.0780, 0.1840; % 深红色
        0, 0.4470, 0.7410;      % 蓝色
        0.8500, 0.3250, 0.0980; % 橙色
        0.9290, 0.6940, 0.1250; % 黄色
        0.4940, 0.1840, 0.5560; % 紫色
        0.4660, 0.6740, 0.1880; % 绿色
        0.2660, 0.9740, 0.4880; % 浅绿色
        0.3010, 0.7450, 0.9330; % 浅蓝色
        0.1, 0.0, 0.0;         % 红色
        0.7, 0.7, 0.7;         % 灰色
        0.7, 0.2, 0.5;         % 粉紫色
        0.9, 1.0, 0.0;         % 黄色
        0.0, 1.0, 1.0;         % 天青色
        0.9, 0.2, 1.0;         % 浅紫色
    ];


    disp(paths)
    
    color_i = 1;
    for i = 1:numel(paths)
        path = paths{i} + 1;
        disp('path:')
        disp(path)
        if (~isempty(path))
            % 为路径添加起点和终点
            fullPath = [1, path, 1]; % 循环路径
            plot(x(fullPath), y(fullPath), 'LineWidth', 2, 'Color', colors(color_i, :));
            color_i = color_i + 1;
        end
    end
    
    % 添加图例
    % legend(arrayfun(@(i) sprintf('快递员 %d', i), 1:numel(paths), 'UniformOutput', false));
    legend_entries = [{'配送点'}, arrayfun(@(i) sprintf('快递员 %d', i), 1:numel(paths), 'UniformOutput', false)];
    legend(legend_entries, 'Location', 'best');
    hold off;

% 假设 times 是一个长度为 10 的数组
allMiles = [
    394.3797, 375.4711, 384.5759, 373.3628, 380.9788, 366.7665, 366.1999, 373.5301, 372.6248, 375.5784, 369.3880
];
numCars = [8, 8, 9, 8, 8, 8, 8, 8, 8, 8, 8];



% n=10 不同的 w_S 对应的总里程
figure('Position', [100, 100, 800, 600]); % 创建一个适合论文展示的图形窗口
plot(allMiles, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % 增加线宽和标记大小

xlabel('$w_s$', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % X轴标签，使用LaTeX解释器
ylabel('Total Miles', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % Y轴标签，使用LaTeX解释器
title('Total Miles for Different $w_s$ Values', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex'); % 图形标题，使用LaTeX解释器
ylim([300, max(allMiles) + 2]); % 设置 y 轴从 0 开始，最大值略高于数据的最大值
grid on; % 打开网格

set(gca, 'FontSize', 12, 'FontWeight', 'bold'); % 设置轴的字体大小和粗细
box on; % 在图形周围添加边框

% 在每个数据点旁边显示数字，保留1位小数点
for i = 1:length(allMiles)
    text(i, allMiles(i) - 6, num2str(allMiles(i), '%.1f'), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end


% n=10 不同的 w_S 对应的总里程
figure('Position', [100, 100, 800, 600]); % 创建一个适合论文展示的图形窗口
plot(numCars, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % 增加线宽和标记大小

xlabel('$w_s$', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % X轴标签，使用LaTeX解释器
ylabel('The number of Couriers', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex'); % Y轴标签，使用LaTeX解释器
title('Couriers for Different $w_s$ Values', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex'); % 图形标题，使用LaTeX解释器
ylim([0, max(numCars) + 2]); % 设置 y 轴从 0 开始，最大值略高于数据的最大值
grid on; % 打开网格

set(gca, 'FontSize', 12, 'FontWeight', 'bold'); % 设置轴的字体大小和粗细
box on; % 在图形周围添加边框

% 在每个数据点旁边显示数字，保留1位小数点
for i = 1:length(numCars)
    text(i, numCars(i) - 0.5, num2str(numCars(i), '%.1f'), 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
end
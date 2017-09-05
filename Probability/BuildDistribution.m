function [pd, distribution, index] = BuildDistribution(data)

figure('Name', 'Density');
histfit(data, 10, 'Kernel');
xlabel('data');
grid on;

pd = fitdist(data, 'Kernel');
data_min = min(data);
data_max = max(data);
index = linspace(data_min, data_max, 1000);
distribution = cdf(pd, index);
prob_75 = index(ceil(mean(find(0.74 < distribution & distribution < 0.76))));
prob_85 = index(ceil(mean(find(0.84 < distribution & distribution < 0.86))));
prob_95 = index(ceil(mean(find(0.94 < distribution & distribution < 0.96))));
figure('Name', 'Disrtibution (cumulative)');
plot(index, distribution, 'r', 'LineWidth', 2);
hold on;
plot(prob_75, 0:0.001:1, 'b');
plot(prob_85, 0:0.001:1, 'b');
plot(prob_95, 0:0.001:1, 'b');
xlabel('data');
grid on;

end


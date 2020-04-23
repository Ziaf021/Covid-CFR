function plot_estimates;

load mortality_estimate.mat

t = datetime(2020,3,19) - caldays(sampling_window);
clf
hold on;
plot(t, 100*mortality_estimates, '-ob', t, 100*lower_estimates, '--b', t, 100*upper_estimates, '--b', 'Linewidth', 2, 'MarkerFaceColor', [43, 140, 190]/255, 'Color', [43, 140, 190]/255);
plot(t, 100*direct_estimates, 'or-','Linewidth', 2,  'MarkerFaceColor', [227, 74, 51]/255, 'Color', [227, 74, 51]/255);
ytickformat('percentage')
ylabel('Estimated case fatality rate');
box on
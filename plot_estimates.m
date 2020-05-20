function plot_estimates(country_name)

fn=load([char(country_name),'_CI_Estimate', '.mat']);
ft= fn.final_table ;
t= ft(ft.parameters=='cfr',:);
time= t.time_upto;
mortality_estimates= t.optimized_values;
lower_estimates =t.lower_CI;
upper_estimates = t.upper_CI;
direct_estimates=t.cfr_direct;
%clf
hold on;
plot(time, 100*mortality_estimates, '-ob', time, 100*lower_estimates, '--b', time, 100*upper_estimates, '--b',...
        'Linewidth', 2, 'MarkerFaceColor', ...
            [43, 140, 190]/255, 'Color', [43, 140, 190]/255);
  set(gca, 'Yscale','log')
        
plot(time, 100*direct_estimates, 'or-','Linewidth', 2,  'MarkerFaceColor', [227, 74, 51]/255, 'Color', [227, 74, 51]/255);
xl=xlim;
yl = ylim;
 xlim([xl(1) xl(2)])
 ylim([0 yl(2)])
 set(gca, 'Yscale','log')
title(country_name)
ytickformat('percentage')
ylabel('\bf CFR (%)');
legend({'\bf CFR.estimated', '\bf lower.CI','\bf upper.CI', '\bf CFR.direct'}, 'Location', 'southeast');
axis tight
box on
function cfr_plots_ic_based(fileName)
%R= load(fileName);
fileName=fileName.ps;
%clf()
figure()
%subplot(2,1,1)
hold on
plot (fileName.time,  cumsum(fileName.actual_cases), '*', 'Linewidth', 2)
ylabel('\bf Actual.cases')
yyaxis right
plot (fileName.time,  cumsum(fileName.actual_death), 'o', 'Linewidth', 2)
plot (fileName.time,  cumsum(fileName.pred_death), '-', 'LineWidth', 2)
plot (fileName.time, cumsum(fileName.sol_mat), '--', 'LineWidth', 2)
title([fileName.p.country_name])
xlabel('\bf Time');
ylabel('\bf Pred.deaths & Actual.deaths(circles)')
hold off

end
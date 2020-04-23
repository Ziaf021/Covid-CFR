
function cfr_plots_optm()
countries= char('Sweden','UnitedStates', 'UnitedKingdom', 'SouthKorea');

for fname= 1:length(countries)
    subplot(2,2,fname)
   file= load([countries(fname),'_ps.mat']);
 cfr_plots_ic_based(file);
end
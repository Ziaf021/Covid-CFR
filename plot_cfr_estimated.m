function plot_cfr_estimated()
countries= {'Sweden','UnitedStates', 'UnitedKingdom', 'SouthKorea'};
clf
for i= 1:length(countries)
    subplot(2,2,i)
%    fn= load([char(countries(fname)),'_CI_Estimate', '.mat']);
%    x=fn.final_table;
% %    id_optm_sol=find(x.fval(1,:)==(min(x.fval(1,:))));
% %    
% %    parameters= x.prm_optm(id_optm_sol,:);
%    
   %p= lsq_pred_deaths(parameters(1,1),parameters(1,2),x.p.country_name, 3);
    plot_estimates(countries(i));



end
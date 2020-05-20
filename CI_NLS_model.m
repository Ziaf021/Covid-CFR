function CI_NLS_model(country_name,delta)

days_vec = [80 90 100 103];
% if country_name == 'SouthKorea'
%     days_vec = [50 60 70 80 90 105 114];
% end
addpath(genpath(pwd))
%countries= {'Sweden','UnitedStates', 'UnitedKingdom', 'SouthKorea'};
parameters = categorical({'mu', 'sigma', 'cfr'})' ;
%id = 2; 
final_table = table();
for d_i = 1:length(days_vec)
%%upload file : fn
fn=load([char(country_name),'_optm_',num2str(days_vec(d_i)), '.mat']);
%% reported_cases : xn
xn = fn.ps.actual_cases ;

%% actual_deaths : yn 
yn = fn.ps.actual_death ;
%% direct_estimate CFR
cum_cases = cumsum(xn);
 cum_deaths = cumsum (yn);
 cfr = cum_deaths(end) ./ cum_cases(end);

%% Optimized parameters - P_opt
 P_opt = fn.ps.prm_optm ;
%% Predicted_deaths
 fxn_p = fn.ps.sol_mat ;  %prd_deaths = lsq_pred_deaths (P_opt(1), P_opt(2), P_opt(3), country_name, 1)

%% Var(epsilon_n)~ variance of the error
 N = length (yn) ;
 k = length (P_opt) ;
 sigma_r = 1 ./ (N-k)  * fn.ps.fval ;  %OR %sum((yn'- prd_deaths)^.2)  
%% Hessain -Jacobian : H = J^t J
% define delta ; 
h = delta;
%% calculate fxn_ph (for mu, sigma, cfr)
fxn_ph_mu = lsq_pred_deaths (P_opt(1) + h, P_opt(2), P_opt(3), country_name, days_vec(d_i),2) ;
fxn_ph_sigma = lsq_pred_deaths (P_opt(1), P_opt(2) + h, P_opt(3), country_name,days_vec(d_i), 2);
fxn_ph_cfr = lsq_pred_deaths (P_opt(1)+h, P_opt(2), P_opt(3) + h, country_name,days_vec(d_i),  2);

%% Calculate Derivates  %df = (f(x + h) - f(x - h)) / (2*h)   % two sided

df_dmu = (fxn_p - fxn_ph_mu) ./ h;
df_dsigma = (fxn_p - fxn_ph_sigma) ./ h ;
df_dcfr = ((fxn_p - fxn_ph_cfr ) ./ h) ;
%% Jacobian 
 J_f = [ df_dmu'; df_dsigma'; df_dcfr' ]; 
%% Hessian ~~ H = J_f^t * J_f;
 H = J_f * J_f' ;
H_inv = inv (H) ;

%% 95% Confidence Interval ~ 
lower_CI = P_opt' - 1.96 * sqrt( diag (sigma_r .* H_inv) );

upper_CI = P_opt' + 1.96 * sqrt( diag (sigma_r .* H_inv) ) ;

optimized_values = P_opt' ;

cfr_direct = repelem(cfr, size(optimized_values,1))';

time_upto = repelem(fn.ps.p.date_time(end),size(optimized_values,1))' ;

output_table = table (parameters,time_upto, optimized_values, lower_CI, upper_CI, cfr_direct);

final_table = [final_table ; output_table];
end


%final_table ;

file_name = strcat(country_name,'_CI_Estimate', '.mat');

mkdir(country_name)

path_name= strcat(pwd,'\', country_name,'\',file_name);

save(path_name,'final_table');


%save(country_name, 'y')
end
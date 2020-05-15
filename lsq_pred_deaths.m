function y = lsq_pred_deaths (prm1,prm2,prm3, c_name, no_of_days,output_id)

p = cfr_prms(c_name, no_of_days);
p.r =  prm1;%
p.s = prm2;%
mu_D = log(p.r / sqrt(1 + p.s^2/p.r^2));
sigma_D = sqrt(log(1+p.s^2/p.r^2));

p.mu_D = mu_D;

p.sigma_D = sigma_D;

obs_deaths = p.obs_deaths;

obs_cases = p.obs_cases;

dths_vec = zeros(p.sampling_time_len+1,1);%[];

conditional_prob_dead = @(t, a, b) arrayfun(@(t)integral(@(s)lognpdf(s, a, b), 0, t), t);

time_window = p.sampling_window ;


 for ii =1:length(time_window)
     
     deaths = cumsum(obs_deaths(1:end-time_window(ii)));
    
    cases= cumsum(obs_cases(1:end-time_window(ii)));
    
    cases_current_window = (cases(2:end)-cases(1:end-1));
    
%    cum_cases = cumsum(cases_current_window);
    
    prob_of_death= conditional_prob_dead([length(cases_current_window)-1:-1:0], mu_D,sigma_D);

   cfr = prm3;

    prob_past = cfr*prob_of_death;
      
   mean = sum(prob_past .* cases_current_window');
    
    dths_vec(ii) =  mean ;
    
   % direct_estimates(ii) = deaths(end)/cum_cases(end);
 end
 
 cum_cases = cumsum(obs_cases);
 cum_deaths = cumsum (obs_deaths);
 p.cfr_direct = cum_cases ./ cum_deaths;
 
dths_vec (isnan(dths_vec)) = 0 ;

prd_deaths = (round(dths_vec))' ;

daily_deaths = [prd_deaths(1) prd_deaths(2:end)-prd_deaths(1:end-1)];

%p.direct_estimates (isnan(p.direct_estimates)) = 0 ;

p.predicted_deaths = daily_deaths ;

p.rss = sum((p.predicted_deaths - (p.obs_deaths(end-p.sampling_window)')).^2);


if output_id == 1
    
    y = p.rss; %sum((p.predictd_deaths - p.obs_deaths(end-p.sampling_window)).^2);
    
elseif output_id == 2

    y = p.predicted_deaths'  ; %round(p.dths_vec);
else
    y = p;
end



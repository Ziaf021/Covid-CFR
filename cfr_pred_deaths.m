function y = cfr_pred_deaths (p1,p2,p3, c_name, no_of_days)


p = cfr_prms( c_name, no_of_days );

obs_cases = p.obs_cases;

obs_deaths = p.obs_deaths; 


sampling_window =  p.sampling_window ;%flip(0:1:sampling_time_len);

r =  p1 ;%
s = p2 ;%
mu_D = log(r / sqrt(1 + s^2/r^2));
sigma_D = sqrt(log(1+s^2/r^2));

dths_vec=zeros(p.sampling_time_len+1,1);%[];

conditional_prob_dead = @(t, a, b) arrayfun(@(t)integral(@(s)lognpdf(s, a,b), 0, t), t);

time_window= sampling_window;


%parfor my_window = sampling_window
parfor ii =1:length(sampling_window)

   
    deaths = cumsum(obs_deaths(1:end-time_window(ii)));
    
    %country_allcases= obs_cases;
    
    cases= cumsum(obs_cases(1:end-time_window(ii)));
    
    cases_current_window = (cases(2:end)-cases(1:end-1)); %country_allcases(1:end-time_window(ii));
    
   
    prob_of_death= conditional_prob_dead([length(cases_current_window)-1:-1:0], mu_D,sigma_D);
    
   % potential_dead = sum(prob_of_death.* cases_current_window');
   
    cfr = p3;
         
     prob_past = cfr*prob_of_death;
 
     dths_vec(ii) =  sum(prob_past .* cases_current_window');
 
end

prd_deaths =(round(dths_vec))';

prd_deaths(isnan(prd_deaths))=0;

pds_daily = [prd_deaths(1)  prd_deaths(2:end)-prd_deaths(1:end-1)] ;

od=(obs_deaths(end-sampling_window)');


y = sum((pds_daily-od).^2);

%y =sum((prd_deaths - cumsum(obs_deaths(end-sampling_window)')).^2);


end
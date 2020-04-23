function pred_deaths =fn_squared_diff (x, time_window, obs_deaths, obs_cases)

dths_vec=[];
conditional_prob_dead = @(t) arrayfun(@(t)integral(@(s)lognpdf(s, x(1), x(2)), 0, t), t);

for my_window = time_window

    deaths = cumsum(obs_deaths(1:end-my_window));

    country_allcases= obs_cases;
    
    cases_current_window =country_allcases(1:end-my_window);
        
   potential_dead = sum(conditional_prob_dead([length(cases_current_window)-1:-1:0]).*cases_current_window');
   
   if potential_dead == 0
        cfr=0; 
   
    else
       
    cfr = deaths(end) / potential_dead;
    
    end
   
   dths_vec(end+1)=cfr*cases_current_window(end);
   
end
   

pred_deaths= round(dths_vec);

end
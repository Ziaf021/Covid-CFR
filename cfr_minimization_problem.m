function xval =cfr_minimization_problem (x, time_window, obs_deaths, obs_cases)

xval= @(x) lsqcurvefit(nestedfun(x, time_window, obs_deaths, obs_cases));

end
function y =nestedfun(x, time_window, obs_deaths, obs_cases)
        mn=x(1);
sd=x(2);
dths_vec=[];
%conditional_prob_dead = @(t, x(1), x(2)) arrayfun(@(t)integral(@(s)lognpdf(s, x(1), x(2)), 0, t), t);
conditional_prob_dead = @(t, a, b) arrayfun(@(t)integral(@(s)lognpdf(s, a, b), 0, t), t);

for my_window = time_window

    deaths = cumsum(obs_deaths(1:end-my_window));

    country_allcases= obs_cases;
    
    cases_current_window =country_allcases(1:end-my_window);
    
    % calculate the prob
    prob_of_death= conditional_prob_dead([length(cases_current_window)-1:-1:0], mn,sd);
        
   potential_dead = sum(prob_of_death.*cases_current_window');
   
   if potential_dead == 0
        cfr=0; 
   
    else
       
    cfr = deaths(end) / potential_dead;
    
    end
   
   dths_vec(end+1)=cfr*cases_current_window(end);
   
end
   

y= round(dths_vec);
               
        
    end

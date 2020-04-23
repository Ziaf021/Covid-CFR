
addpath(genpath(pwd))

new_cases_all = readtable('new_cases.csv', 'EmptyValue',0 );

new_deaths_all = readtable('new_deaths.csv', 'EmptyValue',0 );


% pdf 
r = 8.8; s = 5.7;

mu_D = log(r / sqrt(1 + s^2/r^2));
sigma_D = sqrt(log(1+s^2/r^2));

conditional_prob_dead = @(t) arrayfun(@(t)integral(@(s)lognpdf(s, mu_D, sigma_D), 0, t), t);

% test



%country_name= string(new_deaths_all .Properties.VariableNames(2:end));

%t_pred_deaths= new_deaths;

%t_pred_deaths{:,2:end}=0;

 sampling_window = flip(0:1: length(new_deaths_all .date)-1);

country_name = {'Sweden';'UnitedStates' ;'UnitedKingdom' ;'China'};
new_cases= new_cases_all{:, country_name};
new_deaths= new_deaths_all{:, country_name};

t_pred_deaths= zeros(size(new_cases));

for cntry_id=1:length(country_name)
    pred_deaths=[];
    subplot (sqrt(length(country_name)),sqrt(length(country_name)), cntry_id)
for  my_window = sampling_window
    
    deaths = cumsum(new_deaths(1:end-my_window, cntry_id));

    country_allcases= new_cases(:, cntry_id);
    
    cases_current_window =country_allcases(1:end-my_window);
        
   potential_dead = sum(conditional_prob_dead([length(cases_current_window)-1:-1:0]).*cases_current_window');

    if potential_dead == 0
        cfr=0; 
   
    else
       
    cfr = deaths(end) / potential_dead;
    
    end
    
    pred_deaths(end+1)= cfr*cases_current_window(end);

end
%t_pred_deaths.(country_name(cntry_id))=round(deaths_estimate)';

t_pred_deaths(:,cntry_id)= round(pred_deaths);

hold on 


plot (new_deaths_all.date, cumsum(new_cases(:,cntry_id)), '*', 'LineWidth', 1.5)
ylabel('\bf Actual.cases')
yyaxis right
plot(new_deaths_all.date, cumsum(t_pred_deaths(:, cntry_id)), '-', 'LineWidth', 2); 
plot (new_deaths_all.date, deaths, 'o', 'LineWidth', 1)
%title((country_name(id)))
xlabel('\bf Time');
ylabel('\bf Pred.deaths & Actual.cases')

legend({'\bf Actual.cases', '\bf Pred.deaths', '\bf Actual.deaths'}, 'Location', 'Northwest', 'Orientation', 'vertical')
legend boxoff

end






%a=t_pred_deaths{:,2:end}

%% Find the the countries whose data to be plotted

mean_korea= 19.1356; 

sd_korea= 28.1281;

cofv_korea= sd_korea/mean_korea

%cofv=sigma_D/ mu_D;

F= @(p,x) lognpdf(x, p(1), p(1)*cofv_korea);


output_lsq= table(country_name);

for id=1:length(country_name)


%subplot (sqrt(length(country_name)),sqrt(length(country_name)), id)
%pred_deaths = t_pred_deaths.(string(country_name(id)));
pred_deaths = t_pred_deaths(:, id);
%actual_deaths = (new_deaths.(string(country_name(id))))
actual_deaths = new_deaths(:, id);

%actual_cases = (new_cases.(string(country_name(id))));

actual_cases = new_cases(:,id);


sd= 0.01*(max(actual_deaths) - min(actual_deaths));

%x0= [sd/cofv_korea, sd];
x0= [log(mean(actual_deaths)), cofv_korea*log(mean(actual_deaths))];

Fsumsquares = @(x)sum((F(x,actual_deaths) - pred_deaths).^2);

[xunc,resn,resd, eflag] =  lsqcurvefit(F,x0,actual_deaths', pred_deaths');%fminunc(Fsumsquares,x0);%
output_lsq.ic_1(id)= x0(1);
output_lsq.ic_2(id)=x0(2);
output_lsq.mu(id)= xunc(1);
output_lsq.Sigma(id)= xunc(2);
output_lsq.Residual(id)= resn;
output_lsq.eflag(id)= eflag;

end
output_lsq

%x0 = [sigma_D*cofv sigma_D];
idx=find(actual_deaths>0)
xd= actual_deaths(idx)
yd= pred_deaths(idx)



F1= @(p,x) sum(x.*lognpdf(x, p(1), p(1)*cofv_korea));

Fsumsquares = @(x)sum((F1(x,xd) - yd).^2);
opts = optimoptions('fminunc','Algorithm','quasi-newton');
[xunc,resn,eflag,output] = fminunc(Fsumsquares,x0)


%[f,g,output]=fit(xd,yd,'poly2')

plot(f,xd,yd)

plot( yd, output.residuals, '.' )
xlabel( 'deaths' )
ylabel( 'Residuals' )

timesv = linspace(actual_deaths(1),actual_deaths(end),109);
plot(actual_deaths,pred_deaths,'ko',timesv,actual_cases'.*F(xunc,timesv),'b-')
legend('Data','Fitted exponential')
title('Data and Fitted Curve')



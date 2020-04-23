function estimate_cases(deaths)
% Estimates mortality of covid-19 infections based on south Korean data
% We assume that a case is confirmed directly at onset.
i
% Distribution of hospitalisation to death from Linton et al. (2020)
%
r = 8.8; s = 5.7;

mu_D = log(r / sqrt(1 + s^2/r^2));
sigma_D = sqrt(log(1+s^2/r^2));

% Distribution of time from officially reported to death. Assumed
% to equal time from hospitalization to death from Linton et al. (2020).
% Code for solving parameters from
% https://math.stackexchange.com/questions/1769765/weibull-distribution-from-mean-and-variance-to-shape-and-scale-factor

% mu = 8.9;
% sig2 = 5.4^2;
%
% f = @(k)sig2/mu^2-gamma(1+2./k)./gamma(1+1./k).^2+1;
% k0 = 10;               % Initial guess
% k = fzero(f,k0)       % Solve for k
% lam = mu/gamma(1+1/k) % Substitue to find lambda
%
% k
% lam
%
% % Probability that a person infected t days ago who eventually dies is now dead.
% t=[0:0.1:30]
% plot(t,wblpdf(t,lam, k))

%conditional_prob_dead = @(t) arrayfun(@(t)integral(@(s)wblpdf(s,k,lam), 0, t), t);
%death_dist =            @(t) arrayfun(@(t)integral(@(s)fun(t,s), 0, t), t);
conditional_prob_dead = @(t) arrayfun(@(t)integral(@(s)lognpdf(s, mu_D, sigma_D), 0, t), t);

conditional_prob_dead(100)

% m = integral(@(s) s.*wblpdf(s,lam,k), 0, 100)
% s2 = integral(@(s) (m-s).^2.*wblpdf(s,lam,k), 0, 100)

% Test
% m = integral(@(s) s.*lognpdf(s, mu_D, sigma_D), 0, 100)
% s2 = integral(@(s) (m-s).^2.*lognpdf(s, mu_D, sigma_D), 0, 100)

% Data from 2020-01-21 to 2020-03-16. Source
% https://ourworldindata.org/coronavirus-source-data

observed_deaths = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 2 5 7 10 12 13 13 17 18 22 28 32 35 42 44 50 51 54 60 66 66 72 75 75 81 86 91]
observed_cases = [1 1 1 2 2 2 4 4 4 4 11 12 15 15 16 18 23 24 24 27 27 28 28 28 28 28 29 30 31 51 104 204 346 602 763 977 1261 1766 2337 3150 3736 4212 4812 5328 5766 6284 6767 7134 7382 7513 7755 7869 7979 8086 8162 8236 8320 8413 8565];

upper_estimates = [];
mortality_estimates = [];
lower_estimates = [];
direct_estimates = [];

length(observed_deaths)

sampling_window = flip(0:1:14);

for my_window = sampling_window
    
    deaths = observed_deaths(1:end-my_window)
    cases = observed_cases(1:end-my_window)
    
    new_cases = [cases(2:end)-cases(1:end-1)];
    
    % new_cases(end) is assumed to be today. New cases today have 0 risk of
    % dying on the same day.
    
    potential_dead = sum(conditional_prob_dead([length(new_cases)-1:-1:0]).*new_cases);
    mortality_estimate = deaths(end) / potential_dead
    
    % Determine confidence intervals for mortality estimate
    
    upper_numbers = [];
    lower_numbers = [];
    
    prob_past = mortality_estimate*conditional_prob_dead([length(new_cases)-1:-1:0]);
    
    mean = sum(prob_past .* new_cases)
    variance = sum(new_cases .* prob_past .* (1 - prob_past));
    
    lower_cases = norminv(0.025, mean, sqrt(variance))
    upper_cases = norminv(0.975, mean, sqrt(variance))
    
    lower_estimate = lower_cases/potential_dead;
    upper_estimate  = upper_cases/potential_dead;
    
    disp(sprintf('Mortality estimate: %g (95%% CI %g-%g)', mortality_estimate, lower_estimate, upper_estimate))
    
    upper_estimates(end+1) = upper_estimate;
    lower_estimates(end+1) = lower_estimate;
    mortality_estimates(end+1) = mortality_estimate;
    direct_estimates(end+1) = deaths(end)/cases(end);
end

save mortality_estimate.mat

end
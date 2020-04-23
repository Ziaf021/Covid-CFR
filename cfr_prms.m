function p =  cfr_prms(c_name)

data=load('Data_tillApr17.mat');

p.country_name=c_name;

p.obs_cases= data.cases_world{:, p.country_name};

p.obs_deaths=data.deaths_world{:, p.country_name};

p.sampling_time_len=60;

p.sampling_window= flip(0:1:p.sampling_time_len);

p.date_time = data.cases_world.date(end-p.sampling_window);
p.r =  [];%prm(1);%
p.s =[];% prm(2);%



end
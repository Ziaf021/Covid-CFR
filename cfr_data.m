function p =cfr_data(str)


addpath(genpath(pwd))

cases_world = readtable('new_cases.csv', 'EmptyValue',0 );

deaths_world= readtable('new_deaths.csv', 'EmptyValue',0 );

save(str, 'cases_world','deaths_world')

end
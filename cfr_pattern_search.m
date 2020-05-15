
function cfr_pattern_search(c_name, no_of_days)
tic
p =  cfr_prms(c_name, no_of_days);
p.r= 8.8 ;
p.s= 5.7;
ic_len = 1;
ps.ic_mat = zeros(ic_len,3);

fun = @(p)cfr_pred_deaths(p(1),p(2),p(3), c_name, no_of_days);
A = []; b = [];

Aeq = []; beq = [];

cum_deaths = cumsum(p.obs_deaths);

cum_cases = cumsum (p.obs_cases) ;

cfr_ub = cum_deaths(end) / cum_cases(end)  + 0.01;

lb = [1 1 0];

ub = [11 20 cfr_ub];

nonlcon = [];

ps.actual_death = p.obs_deaths ;

ps.actual_cases = p.obs_cases ;

ps.prm_optm = zeros(size(ps.ic_mat));

ps.sol_mat = zeros(size(ps.actual_death,1),ic_len);
size (ps.sol_mat)

ps.time =  p.date_time ;%( p.first_case_day:(p.first_case_day+no_of_days-1));%(end-p.sampling_window);

ps.p = p;

ps.sol_mat = zeros(length(ps.time),ic_len); 

ps.fval = zeros(1,ic_len);

ps.exitf = zeros(1,ic_len);

ps.output = cell(1,ic_len);

for i= 1:ic_len
    
    disp(['Calculating_ic. No ' num2str(i)])
   % rng default  
   x1= lb(1) + (ub(1)-lb(1)) * rand(1);
   
   x2= lb(2) + (ub(2)-lb(2)) * rand(1);
   
   x3= lb(3) + (ub(3)-lb(3)) * rand(1);
   
   ps.ic_mat(i,:)= [x1 x2 x3]; 

   options = optimoptions( 'patternsearch', 'Display', 'iter',...
    'MeshTolerance', 1e-5, 'UseParallel', false, ...
            'CompleteSearch', 'on' );%,'SearchMethod',@searchlhs);%... 

    [xval,fval,exitf, output] = patternsearch( fun, ps.ic_mat(i,:), A, b, Aeq, beq, lb, ub, nonlcon, options);
    
    ps.prm_optm(i,:) = xval;

    ps.sol_mat(:,i) = lsq_pred_deaths (xval(1), xval(2), xval(3), c_name,  no_of_days, 2);
    
    ps.fval(:,i) = fval;
    
    ps.exitf(:,i) = exitf;
    
    ps.output{1,i} = output;
    
    toc
end

file_name = strcat(c_name,'_optm_',num2str(no_of_days),'.mat');

mkdir(c_name)

path_name= strcat(pwd,'\', c_name,'\',file_name);%strcat('/Users/Zia/Umu_PhD/Covid-CFR/',c_name,'/',file_name);

save(path_name,'ps')

toc
end


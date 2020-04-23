

function cfr_pattern_search(ic_len,c_name)

method_name= 'ps';
ps.data=load('Data_tillApr17.mat');

%options=optimset('PlotFcns', @optimplotfval);
p =  cfr_prms(c_name);
p.r= 8.8 ;
p.s= 5.7;
x0=[p.r p.s];

ps.ic_mat=zeros(ic_len,2);

ps.actual_death= p.obs_deaths(end-p.sampling_window);

ps.actual_cases= p.obs_cases(end-p.sampling_window);

ps.pred_death=lsq_pred_deaths(x0,c_name);

ps.prm_optm = zeros(size(ps.ic_mat));

%[xval, fval, exitf, output]= fminsearch(@(p)cfr_pred_deaths(p(1),p(2)), x0);

ps.time= p.date_time(end-p.sampling_window);
ps.p=p;

ps.sol_mat=zeros(length(ps.time),ic_len); 
ps.fval= zeros(length(ps.time),ic_len);
ps.exitf=zeros(length(ps.time),ic_len);
ps.output= cell(1,ic_len);

for i= 1:ic_len
    
    disp(['Calculating_ic. No ' num2str(i)])
   % rng default
    ps.ic_mat(i,:)= unifrnd(x0/1.5,x0*1.1);
    
fun= @(p)cfr_pred_deaths(p(1),p(2));
   
A=[]; b=[];
Aeq=[]; beq=[];
lb=[0 0];
ub=[10 10];
nonlcon=[];
%x0=[8.8 5.7];
options= optimoptions('patternsearch','Display', 'iter','FunctionTolerance', 1e-8, 'UseParallel', true);
[xval,fval,exitf, output]=patternsearch(fun, ps.ic_mat(i,:), A,b, Aeq,beq, lb, ub, nonlcon, options);
 
    ps.prm_optm(i,:)= xval;
    ps.sol_mat(:,i)= lsq_pred_deaths (xval,c_name);
    ps.fval(:,i)= fval;
    ps.exitf(:,i)=exitf;
    ps.output{1,i}=output;
    
end
var_name= strcat(c_name,'_',method_name);

save(var_name, 'ps');

end


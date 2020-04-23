
function fminsearch_cfr(ic_len,c_name)

fmin.data=load('Data_tillApr17.mat');

%options=optimset('PlotFcns', @optimplotfval);
p =  cfr_prms(c_name);
p.r= 8.8 ;
p.s= 5.7;
x0=[p.r p.s];

fmin.ic_mat=zeros(ic_len,2);

fmin.actual_death= p.obs_deaths(end-p.sampling_window);

fmin.pred_death=lsq_pred_deaths(x0,c_name);

fmin.prm_optm = zeros(size(fmin.ic_mat));

%[xval, fval, exitf, output]= fminsearch(@(p)cfr_pred_deaths(p(1),p(2)), x0);

fmin.time= p.date_time(end-p.sampling_window);
fmin.p=p;
%[xval, fval, exitf, output]= simulannealbnd(@(p)cfr_pred_deaths(p(1),p(2)), [2 3], [0, 0], [])

fmin.sol_mat=zeros(length(fmin.time),ic_len); 
fmin.fval= zeros(length(fmin.time),ic_len);
fmin.exitf=zeros(length(fmin.time),ic_len);
fmin.output= cell(1,ic_len);

for i= 1:ic_len
    disp(['Calculating_ic. No ' num2str(i)])
    
    fmin.ic_mat(i,:)= unifrnd(x0/1.5,x0*1.1);
    
    %options=optimset('PlotFcns', @optimplotfval);
    [xval, fval, exitf, output]= fminsearch(@(p)cfr_pred_deaths(p(1),p(2)), fmin.ic_mat(i,:));
    
    fmin.prm_optm(i,:)= xval;
    fmin.sol_mat(:,i)= lsq_pred_deaths (xval,c_name);
    fmin.fval(:,i)= fval;
    fmin.exitf(:,i)=exitf;
    fmin.output{1,i}=output;
    
end

save(c_name, 'fmin')

end


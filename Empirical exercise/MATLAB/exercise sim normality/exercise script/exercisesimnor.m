% Empirical exercise - Violation of the normality assumption

%% 1. Set a seed for reproducible results
% To understand how the OLS estimator behaves when the errors of the 
% regression are not normal.

%% 2. Set a seed for reproducible results
clear;
rng(3)

%% 3. Set the number of simulations 
N_sim = 75;

%% 4. Set the sample size
N_obs = 7500;

%% 5. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2;3.5];
N_par = 1;

%% 6. Create the systematic component of the regression equation
x_0 = ones(N_obs,1);
x_1 = unifrnd(-1,1,N_obs,1);
X = [x_0 x_1];
 
%% 7. Create empty matrices for storing simulated coefficient estimates 
B_hat_sim_x_1_OLS_normal = NaN(N_sim,N_par);
B_hat_sim_x_1_IRLS_normal = NaN(N_sim,N_par);
B_hat_sim_x_1_OLS_t = NaN(N_sim,N_par);
B_hat_sim_x_1_IRLS_t = NaN(N_sim,N_par);

%% 8. Degrees of freedom parameter
t_df = 2;

%% 9. Create sampling distributions for the OLS and IRLS estimators based on errors with different distributions  
for i = 1:N_sim 
    u_normal = normrnd(0,1,N_obs,1);
    y_normal = X*B_true+u_normal;
    u_t = trnd(t_df,N_obs,1);
    y_t = X*B_true+u_t;
    OLS = robustfit(x_1,y_normal,'ols');
    B_hat_sim_x_1_OLS_normal(i,1) = OLS(2,1);
    IRLS = robustfit(x_1,y_normal,'bisquare');
    B_hat_sim_x_1_IRLS_normal(i,1) = IRLS(2,1); 
    OLS = robustfit(x_1,y_t,'ols');
    B_hat_sim_x_1_OLS_t(i,1) = OLS(2,1);
    IRLS = robustfit(x_1,y_t,'bisquare');
    B_hat_sim_x_1_IRLS_t(i,1) = IRLS(2,1); 
end

%% 10. Plot example distributions of errors with different distributional assumptions   
ksdensity(u_normal)
hold on
ksdensity(u_t)
legend('Standard normal errors','t errors')
hold off

%% 11. Plot the sampling distributions of the OLS and IRLS estimators when errors are normal 
ksdensity(B_hat_sim_x_1_OLS_normal(:,1))
hold on
ksdensity(B_hat_sim_x_1_IRLS_normal(:,1))
legend('OLS estimator','IRLS estimator')
hold off

%% 12. Plot the sampling distributions of the OLS and IRLS estimators when errors are t  
ksdensity(B_hat_sim_x_1_OLS_t(:,1))
hold on
ksdensity(B_hat_sim_x_1_IRLS_t(:,1))
legend('OLS estimator','IRLS estimator')
hold off

%% 13. Plot the scatter plot and two regression lines fitted using the OLS and IRLS estimators  
scatter(x_1,y_t,'filled'); 
grid on; 
hold on
y_t_hat_OLS = OLS(1)+OLS(2)*x_1;
y_t_hat_IRLS = IRLS(1)+IRLS(2)*x_1; 
plot(x_1,y_t_hat_OLS,'red','LineWidth',2);
plot(x_1,y_t_hat_IRLS,'green','LineWidth',2)
legend('Data','OLS Regression','IRLS Regression')

%% 14. Exam
ksdensity(B_hat_sim_x_1_OLS_normal(:,1))
hold on
ksdensity(B_hat_sim_x_1_OLS_t(i,1))
legend('OLS estimator when errors are normal','OLS estimator when errors are t')
hold off

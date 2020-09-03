% Empirical exercise - Violation of the homoskedasticity assumption with heteroskedasticity

%% 1. Aim of the exercise
% To understand the implications of violating the spherical errors  
% assumption with heteroskedasticity for the sampling distribution of the 
% OLS estimator using simulation. 

%% 2. Set a seed for reproducible results
clear;
rng(1)

%% 3. Set the number of simulations
N_sim = 1000; 

%% 4. Set the sample size
N_obs = 1000;

%% 5. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2 0.5]';

%% 6. Generate data for the independent variable
x_0 = ones(N_obs,1);
x_1 = unifrnd(-1,1,N_obs,1);
X = [x_0 x_1];

%% 7. Create empty matrices and a vector array to store the simulated OLS coefficient estimates and the simulated sigma 
N_par = 2;
B_hat_sim_hete = NaN(N_sim,N_par);
B_hat_sim_homo = NaN(N_sim,N_par);
sigma_hat_sim_hete = NaN(N_sim,1); 

%% 8. Heteroskedasticity parameter 
Gamma = 1.5; 

%% 9. Create the sampling distribution of the OLS estimator under heteroskedasticity
for i = 1:N_sim  
    u_hete = normrnd(0,exp(x_1*Gamma),N_obs,1); % The variance of the error is a function of x_1 plus random noise.
    y_hete = X*B_true+u_hete;  
    LSS_hete = exercisefunctionlss(y_hete,X); % Least squares statistics. 
    B_hat_sim_hete(i,1) = LSS_hete.B_hat(1,1); % Each row contains a simulated estimate of the coefficient of x_0.
    B_hat_sim_hete(i,2) = LSS_hete.B_hat(2,1); % Each row contains a simulated estimate of the coefficient of x_1.
    sigma_hat_sim_hete(i,1) = LSS_hete.sigma_hat; % Each row contains a simulated estimate of the standard error of regression.
end

%% 10. Plot the scatter diagram and the OLS fitted line
scatter(X(:,2),y_hete,'filled','black')
hold on
set(lsline,'color','blue','LineWidth',2)
hold off
title('Fig 1. Heteroskedasticity Created by Simulating the Estimate of the S.D. of the Reg. Err. as a Fun. of x_1')
legend('Scatter Plot','Fitted Line');

%% 11. Create the sampling distribution of the OLS estimator under homoskedasticity
sigma_hat_sim_hete_mean = mean(sigma_hat_sim_hete); 
for i = 1:N_sim
    u_homo = normrnd(0,sigma_hat_sim_hete_mean,N_obs,1); % Use the average of sigma hat generated under heteroskedasticity.
    y_homo = X*B_true+u_homo;  
    LSS_homo = exercisefunctionlss(y_homo,X); 
    B_hat_sim_homo(i,1) = LSS_homo.B_hat(1,1);  
    B_hat_sim_homo(i,2) = LSS_homo.B_hat(2,1); 
end

%% 12. Plot the sampling distribution of the OLS estimator 
ksdensity(B_hat_sim_hete(:,2))
hold on 
ksdensity(B_hat_sim_homo(:,2))
hold on
line([mean(B_hat_sim_homo(:,2)) mean(B_hat_sim_homo(:,2))],ylim,'Color','black')
title('Fig 2. The Effect of Heteroskedasticity on the Sampling Distribution of the OLS estimator')
legend('Error is heteroskedastic','Error is homoskedastic','B\_hat\_sim\_mean');

%% 13. Check the variance of the error  
var(u_hete(x_1 > 0.1 & x_1 < 0.3,1)) % The row subscript is using logical indexing. 
var(u_hete(x_1 > 0.6 & x_1 < 0.8,1))

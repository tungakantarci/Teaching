% Empirical exercise - Sampling distribution of the OLS estimator 

%% 1. Aim of the exercise
% To learn about the sampling distribution of the OLS estimator.

%% 2. Set a seed for reproducible results
clear;
rng(1)

%% 3. Set the number of simulations 
N_sim = 1000;

%% 4. Set the sample size
N_obs = 9000;

%% 5. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2; 0.5];
N_par = 2;

%% 6. Generate data for the independent variable
x_0 = ones(N_obs,1);
x_1 = unifrnd(-1,1,N_obs,1);
X = [x_0 x_1];

%% 7. Create an empty matrix for storing the simulated OLS coefficient estimates 
B_hat_sim = NaN(N_par,N_sim);
B_hat_SEE_sim = NaN(N_par,N_sim);

%% 8. Create a sampling distribution for the OLS estimator
for i = 1:N_sim 
    u = normrnd(0,1,N_obs,1);
    y = X*B_true+u;
    LSS = exercisefunctionlss(y,X);
    B_hat_sim(1,i) = LSS.B_hat(1,1);
    B_hat_sim(2,i) = LSS.B_hat(2,1);
    B_hat_SEE_sim(1,i) = LSS.B_hat_SEE(1,1);
    B_hat_SEE_sim(2,i) = LSS.B_hat_SEE(2,1);
end 

%% 9. Plot the sampling distribution of the OLS estimator of the coefficient of the independent variable  
histogram(B_hat_sim(2,:),50)
hold on
line([mean(B_hat_sim(2,:)) mean(B_hat_sim(2,:))],ylim,'Color','red')
hold off 
title('Figure 1. Sampling distribution of the OLS estimator')
legend('Sampling distribution of B\_hat\_1 based on Monte Carlo sim','B\_hat\_1\_sim\_mean')
ylabel('Frequency')
xlabel('B\_hat\_1')

%% 10. Plot the sampling distribution of the OLS estimator of the coefficient of the independent variable as a density
ksdensity(B_hat_sim(2,:))
hold on
line([mean(B_hat_sim(2,:)) mean(B_hat_sim(2,:))],ylim,'Color','red')
hold off 
title('Figure 2. Sampling distribution of the OLS estimator')
legend('Sampling distribution of B\_hat\_1 based on Monte Carlo sim','B\_hat\_1\_sim\_mean')
ylabel('Density')
xlabel('B\_hat\_1')

%% 11. Standard error of a statistic is the standard deviation of its sampling distribution
std(B_hat_sim(2,:))
LSS.B_hat_SEE(2,1)

%% 12. Plot the sampling distribution of the standard error estimator  
ksdensity(B_hat_SEE_sim(2,:))
hold on
line([mean(B_hat_SEE_sim(2,:)) mean(B_hat_SEE_sim(2,:))],ylim,'Color','red')
hold off
title('Figure 3: Sampling distribution of the estimator of the standard error of the OLS estimator')
legend('Sampling distribution of the standard error estimator of B\_hat\_1 based on Monte Carlo sim','B\_hat\_1\_SEE\_sim\_mean')
ylabel('Frequency')
xlabel('B\_hat\_1\_SEE') 

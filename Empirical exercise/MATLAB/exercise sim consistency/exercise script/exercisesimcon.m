% Empirical exercise - Sampling distribution of the OLS estimator and sample size

%% 1. Set a seed for reproducible results
clear;
rng(1)

%% 2. Set the number of simulations 
N_sim = 1000;

% 3. Set the sample size
N_obs = [1000 10000 100000];
N_obs_j = size(N_obs,2);

%% 4. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2; 0.5];
N_par = 1;

%% 5. Create an empty matrix for storing the simulated OLS coefficient estimates 
B_hat_sim_x_1 = NaN(N_sim,N_par);
B_hat_sim_x_1_j = NaN(N_sim,N_obs_j);

%% 6. Create sampling distributions for the OLS coefficient estimates using different sample sizes
for j = 1:N_obs_j
    for i = 1:N_sim 
        u = normrnd(0,1,N_obs(1,j),1);
        x_0 = ones(N_obs(1,j),1);
        x_1 = unifrnd(-1,1,N_obs(1,j),1);
        X = [x_0 x_1];
        y = X*B_true+u;
        LSS = exercisefunction(y,X);
        B_hat_sim_x_1(i,1) = LSS.B_hat(2,1);
    end
    B_hat_sim_x_1_j(:,j) = B_hat_sim_x_1(:,1);
end

%% 7. Plot the sampling distributions of the OLS coefficient estimate at different sample sizes
ksdensity(B_hat_sim_x_1_j(:,1))
hold on
ksdensity(B_hat_sim_x_1_j(:,2))
hold on
ksdensity(B_hat_sim_x_1_j(:,3))
title('Sampling distribution of the OLS estimator and sample size')
legend('N\_obs = 1,000','N\_obs = 10,000','N\_obs = 100,000')
ylabel('Frequency')
xlabel('B\_hat\_x\_1') 

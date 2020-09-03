% Empirical exercise - Violation of the zero conditional mean assumption due to omitting a variable

%% 1. Aim of the exercise
% Omitting an independent variable from the regression equation can violate
% the zero conditional mean assumption. We study the implications of 
% violating this assumption for the sampling distribution of the OLS 
% estimator using simulation.

%% 2. Set a seed for reproducible results
clear;
rng(1)

%% 3. Set the number of simulations 
N_sim = 1000;

%% 4. Set the sample size
N_obs = 1000;

%% 5. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2 0.5 0.75]';

%% 6. Create the constant term
x_0 = ones(N_obs,1);

%% 7. Create a vector of covariances between two independent variables
covariance_par = [0:0.1:0.9 0.99];
covariance_par_j = size(covariance_par,2);

%% 8. Create an empty matrix to store the simulated OLS coefficient estimates
B_hat_x_1_sim = NaN(N_sim,covariance_par_j);

%% 9. Define input arguments for the multivariate normal random number generator 
MU = [0 0]; % Mean vector.
cases = N_obs;

%% 10. Create sampling distributions for the OLS coefficent estimates under different correlation levels between the included and omitted independent variables  
for j = 1:covariance_par_j
    for i = 1:N_sim
        SIGMA = reshape([1 covariance_par(:,j) covariance_par(:,j) 1],2,2); % The covariance matrix.
        x_1_x_2_correlated = mvnrnd(MU,SIGMA,cases); % Type 'doc mvnrnd' in the command prompt.
        x_1 = x_1_x_2_correlated(:,1);
        x_2 = x_1_x_2_correlated(:,2);
        u = normrnd(0,1,N_obs,1); % Generating numbers from the standard normal distribution.
        X_with_x_2 = [x_0 x_1 x_2];
        y = X_with_x_2*B_true+u;
        X_without_x_2 = [x_0 x_1]; % Omit x_2 in the regression.
        LSS = exercisefunctionlss(y,X_without_x_2); 
        B_hat_x_1_sim(i,j) = LSS.B_hat(2,1); 
    end
end

%% 11. Plot the sampling distributions of the OLS coefficient estimates of the included independent variable under different correlation levels between the included and omitted independent variables  
ksdensity(B_hat_x_1_sim(:,1))
hold on 
ksdensity(B_hat_x_1_sim(:,11))
hold on
line([mean(B_hat_x_1_sim(:,1)) mean(B_hat_x_1_sim(:,1))],ylim,'Color','black')
hold on
line([mean(B_hat_x_1_sim(:,11)) mean(B_hat_x_1_sim(:,11))],ylim,'Color','black')
title('The Effect of Omitting a Variable on the Distribution of the OLS estimator')
legend('Correlation between x\_1 and x\_2 is 0','Correlation between x\_1 and x\_2 is almost perfect','B\_hat\_x\_1\_sim\_mean')
ylabel('Density')
xlabel('B\_hat\_x\_1') 

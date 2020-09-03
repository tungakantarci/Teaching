% Empirical exercise - Violation of the zero conditional mean assumption due to model misspecification 

%% 1. Aim of the exercise
% Model misspecification can violate the zero conditional mean assumption. 
% Here we visualise how this could happen.

%% 2. Set a seed for reproducible results
clear;
rng(1)

%% 3. Set the sample size
N_obs = 250;

%% 4. Set true value for the coefficient of the independent variable
B_true = 1.5;

%% 5. Simulate the independent variable, the error, and the dependent variable
x_0 = ones(N_obs,1);
x_1 = random('Uniform',0,2,[N_obs,1]); % Generate random values from the uniform distribution with lower and upper endpoints 0 and 2. Type 'doc prob.normaldistribution.random' in the command prompt to learn about the 'random' function.  
u = random('Normal',0,1,[N_obs,1]); % Generate random values from the normal distribution with mean 0 and standard deviation 1. 
y = x_0+exp(x_1*B_true)+u; % Assumed true regression model. 

%% 6. Plot the scatter diagram and the OLS fitted line
scatter(x_1,y,'filled','black')
hold on
set(lsline,'color','blue','LineWidth',2)
hold off
title('Error is probably with Nonzero Conditional Mean and Zero Unconditional Mean')
legend('Scatter plot','OLS fitted line');

%% 7. Calculate the mean of the residuals oconditional and unconditional on the independent variable
X = [x_0 x_1];
B_hat = inv(X'*X)*X'*y; % We act here as if we have estimated a linear model.
u_hat = y-X*B_hat;
mean(u_hat) % Overall mean of the residuals. 
mean(u_hat(x_1 > 1 & x_1 < 1.2)) % Mean of the residuals when x_1 > 1 & x_1 < 1.2.

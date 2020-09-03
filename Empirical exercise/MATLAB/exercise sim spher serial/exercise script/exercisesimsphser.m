% Empirical exercise - Violation of the homoskedasticity assumption with serial correlation

%% 1. Aim of the exercise
% To understand the implications of violating the spherical errors
% assumption with serial correlation for the sampling distribution of the 
% OLS estimator using simulation. 

%% 2. Set a seed for reproducible results
clear;
rng(1)

%% 3. Set the number of simulations 
N_sim = 1000;

%% 4. Set the sample size
N_obs = 50;

%% 5. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2 0.5]';
N_par = 3;

%% 6. Generate data for the systematic component of the regression model
x_0 = ones(N_obs,1);
x_1 = unifrnd(-1,1,N_obs,1);

%% 7. Create an empty matrix for storing the simulated OLS coefficient estimates 
B_hat_x_1_sim = NaN(N_sim,N_par);

%% 8. Create the sampling distribution of the OLS estimator
for i = 1:N_sim 
    model = arima('Constant',0,'AR',0.00,'MA',0,'Distribution','Gaussian','Variance',1); 
    u = simulate(model,N_obs); 
    X = [x_0 x_1];
    y = X*B_true+u;
    LSS = exercisefunctionlss(y,X);
    B_hat_x_1_sim(i,1) = LSS.B_hat(2,1);
    model = arima('Constant',0,'AR',0.85,'MA',0,'Distribution','Gaussian','Variance',1); 
    u_ar = simulate(model,N_obs); 
    X = [x_0 x_1];
    y_ar = X*B_true+u_ar;
    LSS = exercisefunctionlss(y_ar,X);
    B_hat_x_1_sim(i,2) = LSS.B_hat(2,1);
    y_ar_lag = lagmatrix(y_ar,1); % Estimate a model with lagged dependent variable included as a regressor.
    X = [x_0 x_1 y_ar_lag];
    LSS = exercisefunctionlss(y_ar(2:N_obs,:),X(2:N_obs,:)); % Exclude the first row of X since this row includes a missing observation for the lagged dependent variable.
    B_hat_x_1_sim(i,3) = LSS.B_hat(2,1);
end

%% 9. Plot serially correlated and normal errors
plot(u)
hold on 
plot(u_ar)
title('Fig 1. Errors that are serially correlated and normal')
legend('Errors are normal','Errors are serially correlated')
hold off

%% 10. Plot the sampling distribution of the OLS estimator when errors are serially correlated and when they are not
ksdensity(B_hat_x_1_sim(:,1))
hold on
ksdensity(B_hat_x_1_sim(:,2))
title('Fig 2. Sampling distribution of the OLS estimator')
legend('Errors are normal','Errors are serially correlated')
ylabel('Kernel smoothed density')
xlabel('B\_hat\_x\_1\_sim') 
hold off

%% 11. Plot the sampling distribution of the OLS estimator when lagged dependent is included in the model and when it is not included 
ksdensity(B_hat_x_1_sim(:,2))
hold on
ksdensity(B_hat_x_1_sim(:,3))
line([mean(B_hat_x_1_sim(:,2)) mean(B_hat_x_1_sim(:,2))],ylim,'Color','blue')
line([mean(B_hat_x_1_sim(:,3)) mean(B_hat_x_1_sim(:,3))],ylim,'Color','red')
title('Fig 3. Sampling distribution of the OLS estimator')
legend('Lagged dependent not included','Lagged dependent included','Mean of B\_hat\_x\_1\_sim when lagged dependent not included','Mean of B\_hat\_x\_1\_sim when lagged dependent included')
ylabel('Kernel smoothed density')
xlabel('B\_hat\_x\_1\_sim') 

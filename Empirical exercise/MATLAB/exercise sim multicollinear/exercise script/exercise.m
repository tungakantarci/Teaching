% Empirical exercise - Implication of multicollinearity for the OLS estimator  

% 1. Set a seed for reproducible results
clear;
rng(1)

% 2. Set the number of simulations 
N_sim = 1000;

% 3. Set the sample size
N_obs = 1000;

% 4. Set true values for the coefficients of the intercept and the independent variable
B_true = [0.2; 0.5; 0.75];

% 5. Create the constant term
x_0 = ones(N_obs,1);

% 6. Create a vector of covariances between two independent variables
covariance_par = [0:0.1:0.9 0.99];
covariance_par_j = size(covariance_par,2);

% 7. Create empty matrices to store the simulated OLS coefficient estimates, standard errors, standard deviation of the simulated OLS coefficient estimates 
N_par = 1;
B_hat_x_1_sim = NaN(N_sim,N_par);
B_hat_x_1_sim_j = NaN(N_sim,covariance_par_j);
B_hat_x_1_SE_sim = NaN(N_sim,N_par); 
B_hat_x_1_SE_sim_j = NaN(N_sim,covariance_par_j); 
B_hat_x_1_sim_j_SD = NaN(covariance_par_j,N_par); 

% 8. Define input arguments for the multivariate normal random number generator 
MU = [0 0]; % Mean vector 
cases = N_obs;

% 9. Create sampling distributions for the OLS coefficient estimates under different correlation levels between the independent variables
for j = 1:covariance_par_j
    SIGMA = reshape([1 covariance_par(:,j) covariance_par(:,j) 1],2,2); % Covariance matrix
    x_1_x_2_correlated = mvnrnd(MU,SIGMA,cases); % Type 'doc mvnrnd' in the command prompt
    x_1 = x_1_x_2_correlated(:,1);
    x_2 = x_1_x_2_correlated(:,2);
    for i = 1:N_sim
        u = normrnd(0,1,N_obs,1);
        X = [x_0 x_1 x_2];
        y = X*B_true+u;
        LSS = exercisefunctionlss(y,X);
        B_hat_x_1_sim(i,1) = LSS.B_hat(2,1);
        B_hat_x_1_SE_sim(i,1) = LSS.B_hat_SEE(2,1); 
    end
    B_hat_x_1_sim_j(:,j) = B_hat_x_1_sim(:,1);
    B_hat_x_1_sim_j_SD(j,:) = std(B_hat_x_1_sim_j(:,j));
    B_hat_x_1_SE_sim_j(:,j) = B_hat_x_1_SE_sim(:,1); 
end

% 10. Plot the sampling distributions of the OLS coefficient estimates at different correlation levels between the independent variables
ksdensity(B_hat_x_1_sim_j(:,1))
hold on 
ksdensity(B_hat_x_1_sim_j(:,10))
hold on
line([mean(B_hat_x_1_sim_j(:,1)) mean(B_hat_x_1_sim_j(:,1))],ylim,'Color','black')
hold on
line([mean(B_hat_x_1_sim_j(:,10)) mean(B_hat_x_1_sim_j(:,11))],ylim,'Color','black')
hold off 
title('Figure 1: The Effect of Multicollinearity on the Sampling Distribution of the OLS estimator')
legend('No correlation','Almost perfect correlation','B\_hat\_x\_1\_sim\_mean')
ylabel('Density')
xlabel('B\_hat\_x\_1') 

% 11. Plot the standard deviation of the sampling distribution of the OLS coefficient estimates against different correlation levels between the independent variables
plot(covariance_par,B_hat_x_1_sim_j_SD)
title('Standard Deviation of the Simulated OLS Estimates at Different Correlation Levels Between the Independent Variables')
ylabel('S.D. of B\_hat\_x\_1')
xlabel('Correlation Between the Indepdent Variables') 

% 12. Plot the sampling distributions of the standard error estimates of the OLS coefficient estimates at different correlation levels between the independent variables
ksdensity(B_hat_x_1_SE_sim_j(:,1))
hold on 
ksdensity(B_hat_x_1_SE_sim_j(:,11))
title('The Effect of Multicollinearity on the Estimator of the Standard Error of the OLS Estimator')
legend('No correlation','Almost perfect correlation')
ylabel('Density')
xlabel('B\_hat\_x\_1\_SE') 

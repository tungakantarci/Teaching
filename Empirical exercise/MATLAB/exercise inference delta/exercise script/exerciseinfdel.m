% Empirical exercise - Inference - Delta method

%% 1. Aim of the exercise 
% To learn to carry out hypothesis testing on the nonlinear function of 
% a population coefficient. 

%% 2. Load the data 
clear;
% load 'M:\exercise.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise inference delta/exercise mat file/exercise.mat';
clearvars -except testscr avginc; 

%% 3. Create the systematic component of the regression equation 
y = log(testscr);
N_obs = size(y,1);
x_0 = ones(N_obs,1);
X = [x_0 avginc]; 

%% 4. Estimate the coefficients and the variance-covariance matrix of them
LSS = exercisefunction(y,X);
B_hat_x_1 = LSS.B_hat(2,1);
B_hat_x_1_VE = LSS.B_hat_VCE(2,2); % Variance estimate of B_hat_avginc.

%% 5. Obtain the derivative of the nonlinear function of the population coefficient of the independent variable 
DC_in_x_1 = 5; % Amount of the discrete chnage in x_1. 
B_x_1 = sym('B_x_1'); % Define B_x_1 as a symbolic expression so that DE_of_x_1 can be differentiated with respect to B_x_1.
DE_of_x_1 = exp(B_x_1*DC_in_x_1)-1; % Discrete effect of x_1 evaluated at B_x_1.
G = DE_of_x_1; % Nonlinear function to be differentiated.
diff(G) % Differentiate G.
diff_G_hat = DC_in_x_1*exp(B_hat_x_1*DC_in_x_1); % diff(G) evaluated at B_hat_x_1.

%% 6. Apply the Delta method
DE_of_x_1_VE = diff_G_hat*B_hat_x_1_VE*diff_G_hat; % Delta method gives the variance estimate of the discerete effect of x_1.
DE_of_x_1_SEE = sqrt(DE_of_x_1_VE); % Standard error estimate. 

%% 7. Hypothesis test on the nonlinear function of the population coefficient of the independent variable 
DE_of_x_1_hat = exp(B_hat_x_1*DC_in_x_1)-1; % Discrete effect of x_1 evaluated at B_hat_x_1.
t = DE_of_x_1_hat/DE_of_x_1_SEE;
t_df = N_obs-size(X,2); 
t_critical = tinv(0.975,t_df); % Two-sided test.
p = tcdf(t,t_df,'upper')*2;
p_critical = 0.05;

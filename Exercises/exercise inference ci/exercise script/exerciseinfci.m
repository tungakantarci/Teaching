% Empirical exercise - Inference - Confidence interval

%% 1. Aim of the exercise
% To learn calculating a CI, and more importantly, interpreting it. 

%% 2. Empirical exercise on CI

% 2.1. Load the data 
clear;
% load 'M:\exercise.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise fwl/exercise mat/exercisefwl.mat';
clearvars -except testscr str el_pct; 

% 2.2. Create the systematic component of the regression equation 
y = testscr;
N_obs = size(y,1);
x_0 = ones(N_obs,1);
X = [x_0 str el_pct];

% 2.3. Obtain the OLS coefficient estimate and the standard error estimate of it
LSS = exercisefunctionlss(y,X);
B_hat_k = LSS.B_hat(2,1); % k = str.
B_hat_k_SEE = LSS.B_hat_SEE(2,1);

% 2.4. Carry out a t test on the population coefficient
t = B_hat_k/B_hat_k_SEE;
t_df = N_obs-size(X,2); 
t_c = tinv(0.975,t_df); % Two-tailed test. 

% 2.5. Construct the CI for the population coefficient
CI_lower_bound_k = B_hat_k-t_c*B_hat_k_SEE;
CI_upper_bound_k = B_hat_k+t_c*B_hat_k_SEE;

%% 3. Simulation exercise on CI

% 3.1. Set the number of simulations
clear;
N_sim = 1000; % What do you expect will happen if you increase this number?

% 3.2. Set the sample size
N_obs = 1000;

% 3.3. Generate data for the independent variable
x_1 = unifrnd(-1,1,N_obs,1);
X = x_1;

% 3.4. Set the true value of the population coefficient of interest
B_true_k = 0.5; % k = x_1.
N_par = 1;

% 3.5. Create an empty matrix for storing coefficient estimates from repeated sampling 
B_hat_k_sim = NaN(N_sim,N_par);  
B_hat_k_SEE_sim = NaN(N_sim,N_par);

% 3.6. Create a sampling distribution for the OLS coefficient estimate
for i = 1:N_sim 
    u = normrnd(0,1,N_obs,1);
    y = X*B_true_k+u;
    LSS = exercisefunctionlss(y,X);
    B_hat_k_sim(i,1) = LSS.B_hat(1,1);
    B_hat_k_SEE_sim(i,1) = LSS.B_hat_SEE(1,1);
end 

% 3.7. Calculate the critical t value
t_df = N_obs-size(X,2);
t_c = tinv(0.975,t_df); 

% 3.8. CI for the population coefficient when we have one sample from the population
CI_lower_bound_k_one_sample = B_hat_k_sim(1,1)-t_c*B_hat_k_SEE_sim(1,1);
CI_upper_bound_k_one_sample = B_hat_k_sim(1,1)+t_c*B_hat_k_SEE_sim(1,1);

% 3.9. Calculate the fraction of the time the population coefficient falls into the random intervals constructed using repeated samples
RI_lower_bound_k_repeated_sample = B_hat_k_sim-t_c*B_hat_k_SEE_sim;
RI_upper_bound_k_repeated_sample = B_hat_k_sim+t_c*B_hat_k_SEE_sim;
B_true_within_interval_dummy = B_true_k > RI_lower_bound_k_repeated_sample & ...
                               B_true_k < RI_upper_bound_k_repeated_sample;
Fraction_B_true_within_intervals = mean(B_true_within_interval_dummy); % The fraction is equal to (aprox.) 0.95. Are you surprised?

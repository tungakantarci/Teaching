% Empirical exercise - The maximum likelihood estimator and the probit model

%% 1. Aim of the exercise
% To understand using the maximum likelihood method to estimate the probit 
% model.

%% 2. Set seed
clear;
rng(1)

%% 3. Define the number of observations
N_obs = 500;    

%% 4. Simulate data 
x_0 = ones(N_obs,1);
x_1 = random('normal',0,1,N_obs,1);
x_2 = random('normal',0,1,N_obs,1);
x_3 = random('normal',0,1,N_obs,1);
X = [x_0 x_1 x_2 x_3];
mu = 0; 
sigma = 1;
e = random('normal',mu,sigma,N_obs,1); 
B_true = [1 2 3 4]'; 
% Latent model
y_star = X*B_true+e;
% Bivariate indicator
y = y_star > 0;

%% 5. Estimate the probit model
B_ig = [1 1 1 1]';
B_hat = fminunc(@(B_true)exercisemlprofunction(y,X,B_true),B_ig);

%% 6. Load empirical data
clear;
% load 'M:\exercisemlpro.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise ml probit/exercise mat/exercisemlpro.mat';

%% 7. Define the dependent variable and the matrix of regressors
y = deny;
N_obs = length(y);
x_0 = ones(N_obs,1);
X = [x_0 black piratio];

%% 8. Estimate the probit model
B_ig = [1 1 1]';
B_hat = fminunc(@(B_true)exercisemlprofunction(y,X,B_true),B_ig);

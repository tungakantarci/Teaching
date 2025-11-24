% Empirical exercise - The multinomial logit model

% The code in this file is based on Adams et al. (2015) but adjusted. Possible errors are those of the author. 

%% 1. Clear the memory and set a seed
clear;
clc;
rng(1)

%% 2. Generate X and define the number of choice alternatives
Beta_true = [0.1,0.1;0.9,0.9]; % N_k x N_j-1. The rows are for N_k coefficients. The columns are for N_j-1 choice alternatives. Which column is for which alternative?
N_i = 1000;
x_0 = ones(N_i,1);
x_1 = randn(N_i,1);
X = [x_0,x_1]; % N x K.
N_j = 3; % Assumed number of choice alternatives.

%% 3. Simulate y
y = exemnlfunsimout(Beta_true,X,N_j);

%% 4. Estimate the paramaters
options = optimset('Algorithm','sqp','Display','iter');
Beta_ig = [1,1;1,1]; % ig stands for initial guess. N_k x N_j-1.
lb = [-5,-5;-5,-5]; % N_k x N_j-1.
ub = [5,5;5,5];
Obj = @(Beta_true)exemnlfunlik(Beta_true,y,X,N_j);
[Beta_hat,sumloglik,exitflag] = fmincon(Obj,Beta_ig,[],[],[],[],lb,ub,[],options);

Beta_hat

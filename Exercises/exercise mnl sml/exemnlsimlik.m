% Empirical exercise - The multinomial logit model estimated by simulation

%% 1. Clear the memory and set a seed
clear;
clc;

%% 2. Generate X and define the number of choice alternatives
Beta_true = [0.1,0.1;0.9,0.9]; % N_k x N_j-1. 
N_i = 1000;
x_0 = ones(N_i,1);
x_1 = randn(N_i,1);
X = [x_0,x_1]; % N_i x N_k.
N_j = 3; % Assumed number of choice alternatives.
% Consider Beta_true. The rows are for N_k coefficients. The columns are
% for N_j-1 choice alternatives. Which column is for which alternative?

%% 3. Simulate y
y = exemnlfunsimout(Beta_true,X,N_j);

%% 4. Estimating by Simulation
Beta_hat_ig = [1,1;1,1];
lb = [-5,-5;-5,-5]; % N_k x N_j-1.
ub = [5,5;5,5];
options = optimset('Algorithm','sqp','DiffMinChange',1e-2,'Display','iter');
Obj = @(Beta_true)exemnlfunsimlik(Beta_true,y,X);
[Beta_hat,sumloglik,exitflag] = fmincon(Obj,Beta_hat_ig,[],[],[],[],lb,ub,[],options);

Beta_hat

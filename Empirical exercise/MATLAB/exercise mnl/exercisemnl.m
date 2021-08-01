% Empirical exercise - The multinomial logit model

%% 1. Clear the memory and set a seed
clear;
clc;
rng(1)

%% 2. Generate X and define the number of choice alternatives
N = 1000;
x_0 = ones(N,1);
x_1 = randn(N,1);
X = [x_0,x_1]; % N x K.
J = 3; % Assumed number of choice alternatives. Deleted: J = size(Beta,1)/K+1.

%% 3. Simulate y
Beta = [0.5,0.5;0.1,0.1]'; % K x J-1. The rows are for K coefficients. The columns are for J-1 choice alternatives. Which column is for which alternative?
y = exercisemnlsimout(Beta,X,J);

%% 4. Estimate the paramaters
options = optimset('Algorithm','sqp','Display','iter');
Beta_ig = [0,0;0,0]'; % ig stands for initial guess.
lb = [-1,-1;-1,-1];
ub = [1,1;1,1];
[Beta_hat,sumloglik,exitflag] = fmincon(@(parameters)exercisemnlloglik(parameters,y,X,J),Beta_ig,[],[],[],[],lb,ub,[],options);

% The code is based on Adams et al. (2015) but adjusted. Errors are those of the author. 


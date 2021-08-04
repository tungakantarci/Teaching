% Empirical exercise - Multinomial logit model

%% 1. Clear the memory, set the seed, and generate X
clear;
clc;

rng(1)

N = 1000;
Beta = [0.5,0.5]';
income = randn(N,1);
X = [ones(N,1),income];

%% 2. Simulate y
y = SimulateMNLogit(X,Beta);

%% 3. Estimate the paramaters
options = optimset('Algorithm','sqp','Display','iter');
Beta_init = [0;0];
lb = [-10;-10];
ub = [10;10];
[EstBetaML,LL,exitflag] = fmincon(@(parameters)MNLogitLL(parameters,y,X),Beta_init,[],[],[],[],lb,ub,[],options);

EstBetaML






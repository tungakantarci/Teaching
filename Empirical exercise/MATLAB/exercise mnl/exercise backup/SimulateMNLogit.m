function y = SimulateMNLogit(X,Beta)
%% Define parameters
N = size(X,1);
K = size(X,2);
J = size(Beta,1)/K+1; 

Beta = reshape(Beta,K,J-1); % K x J-1.

%% Simulate values for epsilon
epsilon = -log(-log(rand(N,J))); % N x J.

%% Simulate the utility for two options
Beta_augmented = [Beta,zeros(K,1)]; % K x J.
utility = X * Beta_augmented + epsilon; % X is N x K. Beta_augmented is K x J. X * Beta_augmented is N x J.

%% Simulate the choice for each individual

[junk,y] = max(utility,[],2);

%% GraphSimulatedData(utility,y)

return
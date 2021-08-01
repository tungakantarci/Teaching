% Empirical exercise - Simulating the outcome variable in the multinomial logit model

function y = exercisemnlsimout(Beta,X,J)
%% Define N and K
N = size(X,1);
K = size(X,2);

%% Create matrix of coefficients for each choice alternative
Beta_augmented = [Beta,zeros(K,1)]; % K x J. Here "augmented" means that the Beta matrix is augmented with a column for the choice alternative chosen as the base category and set to 0 for identification.

%% Assume values for the utility error
epsilon = -log(-log(rand(N,J))); % N x J. If variable v has the standard uniform distribution, -ln(-ln(v)) has the type I extreme value distribution.

%% Simulate the utility for choice alternatives
utility = X*Beta_augmented+epsilon; % X is N x K. Beta_augmented is K x J. epsilon is N x J. utility is N x J.

%% Simulate the choice of each individual
[~,y] = max(utility,[],2);

%% GraphSimulatedData(utility,y)
% Consider the code in Adams et al. (2015).

end
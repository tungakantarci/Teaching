% Empirical exercise - Simulating the outcome variable in the multinomial logit model

function y = exemnlfunsimout(Beta_true,X,N_j)
%% Define N_i and N_k
N_i = size(X,1);
N_k = size(X,2);

%% Create matrix of coefficients for each choice alternative
Beta_true_augmented = [Beta_true,zeros(N_k,1)]; % N_k x N_j.
% Here "augmented" means that the Beta matrix is augmented with a column
% for the choice alternative chosen as the base category and set to 0 for
% identification.

%% Assume values for the utility error
epsilon = -log(-log(rand(N_i,N_j))); % N_i x N_j. 
% If variable v has the standard uniform distribution, -ln(-ln(v)) has the
% type I extreme value distribution.

%% Simulate the utility for choice alternatives
utility = X * Beta_true_augmented + epsilon; % N_i x N_j.
% X is N_i x N_k. Beta_augmented is N_k x N_j. epsilon is N_i x N_j.
% utility is N_i x N_j.

%% Simulate the choice of each individual
[~,y] = max(utility,[],2); % N_i x 1.

end


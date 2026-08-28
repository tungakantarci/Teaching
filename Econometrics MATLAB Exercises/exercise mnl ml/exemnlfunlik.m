% Empirical exercise - The maximum likelihood objective function for the multinomial logit model

function sumloglik = exemnlfunlik(Beta_true,y,X,N_j)
%% Define parameters
N_i = size(X,1);

%% Define the exponential function
expxb = exp(X*Beta_true); % X is N_i x N_k. Beta_true is N_k x J-1. N_i x N_j-1.
expxb_augmented = [expxb,ones(N_i,1)]; % N_ x N_j.
% Consider "indicator". It creates a matrix with J columns where the first
% column indicates if the first alternative is chosen, the second indicates
% if the second alternative is chosen, etc. In "expxb_augmented" the choice
% alternative that is chosen as the base can be specified with a column of
% ones. Here the third alternative is chosen as the base and therefore the
% third column is specified as a column of ones. If the second alternative
% would have been chosen as the base, we could specify it as
% [expxb(:,1),ones(N,1),expxb(:,2)]. Consequently, "loglik" accounts for
% the probability of choosing the base alternative that takes a different
% form than the probabilities of choosing other alternatives.

%% Define a matrix of choices made and not made for each individual
indicator = NaN(N_i,N_j); % N_i x N_j. 

for count = 1:N_j
    indicator(:,count) = (y == count); % Assign a value of 1 if j is chosen and 0 otherwise in the N_i x N_j matrix. 
end
% Alternative refers to 1, 2 and 3 chosen as the base.

%% Create the log-likelihoods and the sum of the log-likelihoods
loglik = log(sum(expxb_augmented.*indicator,2)./sum(expxb_augmented,2)); % The log-likelihood for i.  
sumloglik = -sum(loglik); % The sum of the log-likelihoods over i is the objective function.
% Consider loglik. Study how the likelihood of choosing alternative j is
% coded. In principle the log-likelihood for i is the sum of the indicator
% function for alternative j times the log-likelhood of alternative j where
% the sum is over j. This is coded in a particular way here. Considered is
% the log of the sum of the indicator function for alternative j times the
% numerator of the probility of choosing alternative j where the sum is
% over j. This is then divided by the denomiator of the probability of
% choosing alternative j which is the same across all alternatives. The sum
% function is summing along the column dimension, due to 2.

end
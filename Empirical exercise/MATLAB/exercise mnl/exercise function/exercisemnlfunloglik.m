% Empirical exercise - The maximum likelihood objective function for the multinomial logit model

function sumloglik = exercisemnlfunloglik(Beta_true,y,X,J)
%% Define parameters
N = size(X,1);

%% Define the exponential function
expxb = exp(X*Beta_true); % X is N x K. Beta is K x J-1. N x J-1.
expxb_augmented = [expxb,ones(N,1)]; % N x J. The last column is for the choice alternative that is chosen as the base. It is 1 because exp of 0 is 1.  

%% Define a matrix of choices made and not made for each individual
MyIndex = NaN(N,J); % N x J. 

for count = 1:J
    MyIndex(:,count) = (y == count); % Assign a value of 1 if j is chosen and 0 otherwise in the N x J matrix. 
end

%% Create the log-likelihoods and the sum of the log-likelihoods
loglik = log(sum(expxb_augmented.*MyIndex,2)./sum(expxb_augmented,2)); % The log-likelihood for i. Study how the likelihood of choosing alternative j is coded. The sum is summing along the column dimension. 
sumloglik = -sum(loglik); % The sum of the log-likelihoods over i is the objective function.

end
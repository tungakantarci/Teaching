% Empirical exercise - Simulating choice probabilities in the multinomial logit model

function sumloglik = exemnlfunsimlik(Beta_true,y,X)
%% Set seed
rng(1);

%% Define N_i, N_j and N_s
N_i = size(y,1);
N_j = max(y);
N_s = 1000; % Number of simulations. 

%% Generate simulated series of outcomes for each individual
y_simulated = NaN(N_i,N_s); % N_i x N_s. For each i, simulate y N_s times.

for count = 1:N_s
    y_simulated(:,count) = exemnlfunsimout(Beta_true,X,N_j); 
end
% We are using same X when simulating y. Notice how the current function
% file nests the function file in this subsection used to simulate the
% outcome variable.

%% Generate simulated probabilities
probability_simulated  = NaN(N_i,N_j); % N_i x N_j. 
indicator = NaN(N_i,N_j); % N_i x N_j. 

for count = 1:N_j
    probability_simulated(:,count) = mean(y_simulated == count,2);     
    indicator(:,count) = (y == count);
end
% Consider the "mean" function. Take the average of the indicator that
% alternative j is chosen a random number of times for each i in the
% y_simulated array. This gives the probability of choosing that
% alternative. Repeat this for all choice alternatives.

%% Create the simulated log-likelihoods and the sum of the log-likelihoods
loglik = sum(indicator .* log(probability_simulated),2);
sumloglik = -sum(loglik);
% The idea is to find the parameter values that maximize the simulated
% probability from simulations. In other words, we find the simulated data
% that is closest to the real data and the reference for "closest" is the
% choice probabilities that get maximized with respect to the parameters.
% Here we do simulated maximum likelihood pretending that the choice
% probabilities do not have analytic expressions so that we simulate them.
% We simulate them using the model multiple times to obtain sample
% probabilities that approximate the probabilities that do not have
% analyctical expressions. We present that the choice probabilities do not
% have analytical expressions. In fact considered here is the standard
% multinomial logit model and the probabilities have analytical
% expressions. See the exercise on multinomial logit model.

return
% Empirical exercise - The maximum likelihood objective function for the linear regression model

function [Obj,Gradient_of_Obj] = exercisemllrmfunction(y,X,T_true,N_obs,N_par)  
% Parameters
B_true = T_true(1:end-1); % N_par_coefficients x 1. 
sigma = T_true(end); % 1 X 1. Also referred to as the square root of the mean squared error.
mu = 0;
% The likelihood function
likelihood_N_obs = normpdf(y-X*B_true,mu,sigma); % N_obs x 1. normpdf(y-X*B_true,mu,sigma) returns the pdf of the normal distribution with mean mu and standard deviation sigma, evaluated at the values in y-X*B_true. Note that we assume that the error follows the normal distribution.
% The loglikelihood function
loglikelihood_N_obs = log(likelihood_N_obs); % N_obs x 1. The vector of of the loglikelihood contributions of all entities in the data.
% The objective function
Obj = -sum(loglikelihood_N_obs); % 1 x 1. sum(loglikelihood_N_obs) returns the sum of the elements of loglikelihood.
% The gradient of the objective function 
Gradient_of_Obj = NaN(N_par,1); % N_par x 1. The gradient is also referred to as the "score".
Gradient_of_Obj(1:end-1) = -(1/sigma^2)*X'*(y-X*B_true); % N_par_coefficients x 1. The gradient with respect to vector B_true. 
Gradient_of_Obj(end) = (N_obs/sigma)-(1/sigma^3)*(y-X*B_true)'*(y-X*B_true); % 1 x 1. The gradient with respect to the scalar sigma.
end

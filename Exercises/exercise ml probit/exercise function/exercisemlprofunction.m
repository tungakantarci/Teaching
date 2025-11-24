% Empirical exercise - The maximum likelihood objective function for the probit model

function Obj = exercisemlprofunction(y,X,B_true)  
d = 2*y-1; % If y = 1, d = 1. If y = 0, d = -1.  
% The likelihood function
likelihood = normcdf(d.*(X*B_true)); % P(y = 1) = F(X*B_true), and P(y = 0) = 1-F(X*B_true) = F(-X*B_true). 
% The loglikelihood function
loglikelihood_N_obs = log(likelihood);
% The objective function
Obj = -sum(loglikelihood_N_obs); % The minus sign is added so that the objective function is maximised by the fminunc function. 
end
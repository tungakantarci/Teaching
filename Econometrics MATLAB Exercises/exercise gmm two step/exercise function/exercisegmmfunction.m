% Empirical exercise - The GMM objective function and the gradient of it

function [Obj,GradObj] = exercisegmmfunction(y,X,Z,B_true,W_hat,N_obs,N_par) 
e = y-exp(X*B_true); % N_obs x 1. X is N_obs x N_par. B_true is N_par x 1. Error vector. 
m_bar = (1/N_obs)*Z'*e; % N_mom x 1. Z' is N_mom x N_obs. e is N_obs x 1. Sample moment vector.
Obj = m_bar'*W_hat*m_bar; % 1 x 1. Objective function. GMM estimator is obtained by minimizing this function.
G_bar = -(1/N_obs)*Z'*(X.*repmat(exp(X*B_true),[1 N_par])); % N_mom x N_par. Derivative of the N_mom x 1 sample moment vector m_bar w.r.t. the N_par x 1 parameter vector B_true.
GradObj = 2*G_bar'*W_hat*m_bar; % N_par x 1. The derivative of the 1 x 1 objective function Obj w.r.t. the N_par x 1 paramater vector B_hat. The first-order conditions for the GMM estimator.
end

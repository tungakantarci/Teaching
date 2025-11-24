% Empirical exercise - Function - Between group statistics

function BGS = exerciserefunbgs(y,X,NT,T,P_D) 
% Column dimension of the systematic component of the regression equation
BGS.K            = size(X,2);
% Estimates, predictions, residuals 
BGS.B_hat        = inv(X'*P_D*X)*(X'*P_D*y); % The between-group estimator.
BGS.y_hat        = P_D*X*BGS.B_hat;
BGS.u_hat        = P_D*y-BGS.y_hat; 
% Standard error of the regression
BGS.sigma_hat_sq = 1/(NT-BGS.K*T)*BGS.u_hat'*BGS.u_hat;  
end
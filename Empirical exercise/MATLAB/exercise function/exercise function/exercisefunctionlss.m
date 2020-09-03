% Empirical exercise - Function - Least squares statistics

function LSS = exercisefunctionlss(y,X)  
%% Number of observations and column dimension of X
LSS.N                 = length(y);
LSS.K                 = size(X,2); 
%% Coefficient estimates, predictions, residuals
LSS.B_hat             = inv(X'*X)*X'*y; % Or (X'*X)\X'*y.
LSS.y_hat             = X*LSS.B_hat;
LSS.u_hat             = y-LSS.y_hat;
%% Residual sum of squares
LSS.RSS               = LSS.u_hat'*LSS.u_hat; 
%% The estimator of the variance of the regression error
LSS.sigma_hat_squared = LSS.RSS/(LSS.N-LSS.K); % It is also called the "mean squared error".
LSS.sigma_hat         = sqrt(LSS.sigma_hat_squared); % This is an estimator of the standard deviation of the regression error. It is called the standard error of the regression. It is also referred to as the "root mean squred error".
%% The variance-covariance estimator of the OLS estimator 
LSS.B_hat_VCE         = LSS.sigma_hat_squared.*inv(X'*X); % The variance-covariance estimator of the OLS estimator.
LSS.B_hat_SEE         = sqrt(diag(LSS.B_hat_VCE));
end

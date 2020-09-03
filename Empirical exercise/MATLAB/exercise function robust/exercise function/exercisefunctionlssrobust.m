% Empirical exercise - Function - Least squares statistics - Robust

function LSS = exercisefunctionlssrobust(y,X)  
%% Number of observations and column dimension of X
LSS.N                 = length(y);
LSS.K                 = size(X,2); 
%% Coefficient estimates, predictions, residuals 
LSS.B_hat             = inv(X'*X)*(X'*y); % Or (X'*X)\(X'*y).
LSS.y_hat             = X*LSS.B_hat;
LSS.u_hat             = y-LSS.y_hat;
%% Total, explained, and residual sum of squares
LSS.TSS               = y'*y;
LSS.ESS               = LSS.y_hat'*LSS.y_hat;
LSS.RSS               = LSS.u_hat'*LSS.u_hat;
%% Model fit 
LSS.R2_uc             = 1-LSS.RSS/LSS.TSS;
LSS.Mi                = eye(LSS.N)-ones(LSS.N)./LSS.N;
LSS.TSS_c             = y'*LSS.Mi*y;
LSS.R2_c              = 1-LSS.RSS/LSS.TSS_c; 	
%% The estimator of the variance of the regression error
LSS.sigma_hat_squared = LSS.RSS/(LSS.N-LSS.K); % It is also called the "mean squared error".
LSS.sigma_hat         = sqrt(LSS.sigma_hat_squared); % This is an estimator of the standard deviation of the regression error. It is called the standard error of the regression. It is also referred to as the "root mean squred error".
%% The variance-covariance estimator of the OLS estimator 
LSS.B_hat_VCE         = inv(X'*X)*X'* ...
                        (1/(LSS.N-LSS.K)*LSS.u_hat'*LSS.u_hat.*eye(LSS.N))* ...
                        X*inv(X'*X); % In principle just (1/(LSS.N-LSS.K))*LSS.u_hat'*LSS.u_hat.*inv(X'*X). The second term is the RSS. The first two terms together is the sigma hat squared. inv(X'*X)*X'*X is redundant but added so that this estimator can be compared to the robust estimator below to see how they differ. 
LSS.B_hat_SEE	      = sqrt(diag(LSS.B_hat_VCE));
%% The variance-covariance estimator of the OLS estimator robust to heteroskedasticity
LSS.B_hat_VCE_robust  = inv(X'*X)*X'* ... 
                        (LSS.u_hat.*LSS.u_hat.*eye(LSS.N))* ... % Note the dot product .* here.
                        X*inv(X'*X)* ...
                        LSS.N/(LSS.N-LSS.K); % This last term is only a degrees of freedom adjustment.
LSS.B_hat_SEE_robust  = sqrt(diag(LSS.B_hat_VCE_robust));
%% Inference          
LSS.t                 = LSS.B_hat./LSS.B_hat_SEE;
LSS.t_df              = LSS.N-LSS.K;
LSS.p                 = tcdf(abs(LSS.t),LSS.t_df,'upper')*2;
%% Inference robust to heteroskedasticity
LSS.t_robust          = LSS.B_hat./LSS.B_hat_SEE_robust;
LSS.p_robust          = tcdf(abs(LSS.t_robust),LSS.t_df,'upper')*2;
end 
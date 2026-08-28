% MATLAB Workshop - Function File - Least Squares Statistics

function LSS = MWFunctionLSS(y,X)  
% Number of observations and column dimension of X
LSS.N             = length(y);
LSS.K             = size(X,2); 
% OLS estimates, predictions, residuals 
LSS.B_hat_OLS     = (X'*X)\(X'*y);
LSS.y_hat         = X*LSS.B_hat_OLS;
LSS.u_hat         = y-LSS.y_hat;
% Analysis of variance
LSS.ess           = LSS.y_hat'*LSS.y_hat;
LSS.tss           = y'*y;
LSS.rss           = LSS.u_hat'*LSS.u_hat;
LSS.R2_uc         = LSS.ess/LSS.tss;
LSS.Mi            = eye(LSS.N)-ones(LSS.N)./LSS.N;
LSS.tss_c         = y'*LSS.Mi*y;
LSS.R2_c          = 1-LSS.rss/LSS.tss_c; 	
% Inference
LSS.B_hat_OLS_VCE = 1/(LSS.N-LSS.K)*((X'*X)\X'*(LSS.u_hat'*LSS.u_hat)*X)/(X'*X);
LSS.B_hat_OLS_SEE = sqrt(diag(LSS.B_hat_OLS_VCE));
LSS.t             = LSS.B_hat_OLS./LSS.B_hat_OLS_SEE;
LSS.p             = (1-cdf(makedist('Normal'),abs(LSS.t)))*2;
end





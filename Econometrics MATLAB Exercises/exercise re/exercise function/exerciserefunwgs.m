% Empirical exercise - Function - Within group statistics or Fixed effects statistics

function WGS = exerciserefunwgs(y,X,NT,N,P_D,M_D)
% Systematic component of the regression equation
WGS.Z            = X(:,max(X ~= P_D*X,[],1)); % Select variables that are time-variant.
% Column dimension of the systematic component of the regression equation
WGS.K            = size(WGS.Z,2);
% Estimates, predictions, residuals 
WGS.B_hat        = inv(WGS.Z'*M_D*WGS.Z)*(WGS.Z'*M_D*y); % The within-group or fixed effects estimator.
WGS.y_hat        = M_D*WGS.Z*WGS.B_hat;
WGS.u_hat        = M_D*y-WGS.y_hat; 
% Standard error of the regression
WGS.sigma_hat_sq = 1/(NT-N-WGS.K)*WGS.u_hat'*WGS.u_hat;
end
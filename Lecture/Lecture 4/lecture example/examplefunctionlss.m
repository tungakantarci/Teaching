% FGLS regression example - Function lss

function lss = examplefunctionlss(y,X)  
% Number of observations and column dimension of X 
lss.N                = length(y);
lss.K                = size(X,2); 
% Estimates, predictions, residuals 
lss.B_hat            = (X'*X)\(X'*y);
lss.y_hat            = X*lss.B_hat;
lss.u_hat            = y-lss.y_hat;
end

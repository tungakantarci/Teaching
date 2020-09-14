# R Workshop - Function File - Least Squares Statistics

RWFunctionLSS = function(y,X) 
{
# Number of observations and column dimension of X
N         = nrow(y)
K         = ncol(X)
# OLS estimates, predictions, residuals 
B_hat     = solve(t(X)%*%X)%*%t(X)%*%y
y_hat     = X%*%B_hat
u_hat     = y-y_hat
# Analysis of variance
ess       = t(y_hat)%*%y_hat
tss       = t(y)%*%y
rss       = t(u_hat)%*%u_hat
R2_uc     = ess/tss
Mi        = diag(N)-rep(1,N)/N
tss_c     = t(y)%*%Mi%*%y
R2_c      = 1-rss*solve(tss_c)
# Inference
B_hat_var = 1/(N-K)*(solve(t(X)%*%X)%*%t(X))%*%(drop(t(u_hat)%*%u_hat)*X%*%solve(t(X)%*%X))
B_hat_se  = sqrt(diag(B_hat_var))
t         = B_hat/B_hat_se
p         = (1-pnorm(abs(t)))*2
return(list(N,K,B_hat,y_hat,u_hat,ess,tss,rss,R2_uc,Mi,tss_c,R2_c,B_hat_var,B_hat_se,t,p))
}

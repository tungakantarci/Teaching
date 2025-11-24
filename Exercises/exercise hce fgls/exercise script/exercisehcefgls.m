% Empirical exercise - The HCE, White test, FGLS estimator

%% 1. Aim of the exercise
% Understanding the heteroscedasticity-consistent estimator, the tests of 
% heteroskedasticity, and the feasible generalised least squares estimator. 

%% 2. Load the data
clear;
% load 'M:\exercisehcefgls.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical Exercise/MATLAB/exercise hce fgls/exercise mat/exercisehcefgls.mat';
clearvars aid

%% 3. Exploratory graphical analysis
scatter(dur,unaid,'filled','black') % Repeat the plot with 'ncb', 'rank', 'year'.
hold on
set(lsline,'color','blue','LineWidth',2)
hold off
title('Fig 1. Scatter plot of the dep. var. against an ind. var. overlaid with the least squres line')
legend('Scatter Plot','Fitted Line');

%% 4. Create the systematic component of the regression equation and estimate the model
y = unaid;
N = length(y);
x_0 = ones(N,1); 
X = [x_0 dur ncb rank year];
LSS = exercisefunctionlssrobust(y,X);
u_hat = LSS.u_hat;

%% 5. Obtain the OLS coefficient estimates
B_hat = LSS.B_hat;

%% 6. Obtain the standard error estimates of the OLS coefficient estimates 
B_hat_SEE = LSS.B_hat_SEE;
% B_hat_VCE =               1/(LSS.N-LSS.K)*LSS.u_hat'*LSS.u_hat.*          inv(X'*X); % Variance-covariance estimator in standard form.
% B_hat_VCE = inv(X'*X)*X'*(1/(LSS.N-LSS.K)*LSS.u_hat'*LSS.u_hat.*eye(N))*X*inv(X'*X); % Variance-covariance estimator in alternative form.

%% 7. Obtain the standard error estimates of the OLS coefficient estimates robust to heteroskedasticity 
B_hat_SEE_robust = LSS.B_hat_SEE_robust;
% B_hat_VCE        = inv(X'*X)*X'*(1/(LSS.N-LSS.K)*LSS.u_hat'*LSS.u_hat.*eye(N))*X*inv(X'*X); % Variance-covariance estimator in alternative form.
% B_hat_VCE_robust = inv(X'*X)*X'*(                LSS.u_hat.*LSS.u_hat.*eye(N))*X*inv(X'*X); % Ignoring the degrees of freedom adjustment LSS.N/(LSS.N-LSS.K).
% DM =                             1/(LSS.N-LSS.K)*LSS.u_hat'*LSS.u_hat.*eye(N); % Diagonal matrix considered by the alternative form of the standard variance-covariance estimator where errors are assumed homoskedastic.
% DM_robust =                                      LSS.u_hat.*LSS.u_hat.*eye(N); % Diagonal matrix considered by the robust variance-covariance estimator where errors are allowed to be heteroskedastic.

%% 8. Test for heteroskedasticity of unknown form 
u_hat_sq = u_hat.^2;
R = [dur ncb rank year];
C = [dur.*ncb dur.*rank dur.*year ncb.*rank ncb.*year rank.*year];
S = [dur.*dur ncb.*ncb rank.*rank year.*year];
X = [x_0 R C S];
LSS_hu = exercisefunctionlssrobust(u_hat_sq,X);
LM = N*LSS_hu.R2_c;
df = LSS_hu.K-1;
p_hu = chi2cdf(LM,df,'upper');

%% 9. Test for heteroskedasticity of known form 
u_hat_sq_log = log(u_hat.^2);
X = [x_0 dur ncb rank year];
LSS_hk = exercisefunctionlssrobust(u_hat_sq_log,X);
LM = N*LSS_hk.R2_c;
df = LSS_hk.K-1;
p_hk = chi2cdf(LM,df,'upper');

%% 10. Obtain the estimated transformation matrix
Omega_hat = diag(exp(LSS_hk.y_hat)).*eye(N); % O is for Greek letter Omega. Use speye(N) instead of eye(N) for efficient calculation. See the MATLAB workshop.  
Omega_inverse_hat = eye(N)/Omega_hat; % Omega inverse hat. 
Psi_hat = chol(Omega_inverse_hat,'lower');  

%% 11. Obtain the FGLS coefficient estimates 
y_t = Psi_hat*y;
X_t = Psi_hat*X;
LSS_fgls = exercisefunctionlssrobust(y_t,X_t);
B_hat_fgls = LSS_fgls.B_hat;

%% 12. Obtain the standard error estimates of the FGLS coefficient estimates
B_hat_SEE_fgls = LSS_fgls.B_hat_SEE;
% LSS_g.B_hat_VCE
% 1/(LSS_fgls.N-LSS_fgls.K)*LSS_fgls.RSS*inv(X'*Psi_hat*Psi_hat'*X) % Variance-covariance estimator. See Davidson and McKinnon, page 259.
% X'*P*P'*X\eye(LSS_fgls.K) % Assumes that variance of the error is 1. 

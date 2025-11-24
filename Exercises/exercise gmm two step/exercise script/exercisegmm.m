% Empirical exercise - The MM estimator and the two-step GMM estimator

%% 1. Aim of the exercise
% To understand how to use the MM and the two-step GMM estimators.

%% 2. Load data
clear;
% load 'M:\exercisegmm.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical Exercise/MATLAB/exercise gmm two step/exercise mat/exercisegmm.mat'
clearvars -except hhninc age educ female married hsat;

%% 3. Produce descriptive statsitics
A = [hhninc/10000 age educ female ];
[R1,P1] = corrcoef(A);

%% 4. Create the systematic component of the regression and define the number of parameters and moments
y = hhninc/10000; 
N_obs = length(y); % Nimber of observations.
x_0 = ones(N_obs,1); 
X = [x_0 age educ female]; 
%Z = [x_0 age educ female]; % If Z = X, 'Step one of GMM' below is not GMM but MM. Mask the Z below if you unmask this Z.
Z = [x_0 age educ female married hsat];
N_par = size(X,2); % Number of parameters to be estimated. 
N_mom = size(Z,2); % Number of moments. 

%% 5. Step one of GMM
% Create the initial weighting matrix 
W_hat = inv(eye(N_mom)); % This is the same as eye(N_mom). Inverse is considered to make it clear that W_hat is weighing the moments. 
% Minimise the objective function using the initial weighting matrix 
B_ig = [1 1 1 1]'; 
options = optimset('GradObj','on','MaxFunEvals',15000,'MaxIter',15000,'Display','iter','TolFun',1e-10,'TolX',1e-10,'Algorithm','trust-region'); % Convergence seems to be achived at 27100.
[B_hat_so,Obj_so,exitflag_so,output_so,GradObj_so,hessian_so] = fminunc(@(B_true)exercisegmmfunction(y,X,Z,B_true,W_hat,N_obs,N_par),B_ig,options);

%% 6. Step two of GMM
% Create the optimal weighting matrix 
e = y-exp(X*B_hat_so); % Welcome B_hat_so to the second step of GMM. 
W_hat = inv((1/N_obs)*(e.*Z)'*(e.*Z)); % N_mom x N_mom. The sum of i elements in Phi_hat on p. 513 in Greene can be expressed in matrix form as stated here. 
% Minimise the objective function using the optimal weighting matrix 
B_ig = B_hat_so; 
options = optimset('GradObj','on','MaxFunEvals',1000,'MaxIter',1000,'Display', 'iter','TolFun',1e-10,'TolX',1e-10,'Algorithm','trust-region');
[B_hat_st,Obj_st,exitflag_st,output_st,GradObj_st,hessian_st] = fminunc(@(B_true)exercisegmmfunction(y,X,Z,B_true,W_hat,N_obs,N_par),B_ig,options);

%% 7. Estimate the variance-covariance matrix of the GMM estimates 
G_bar = -(1/N_obs)*Z'*(X.*repmat(exp(X*B_hat_st),[1 N_par])); 
B_hat_st_VCE = (1/N_obs)*inv(G_bar'*W_hat*G_bar); % If Z = X, update the W_hat in Section 6 using B_hat_so because the variance-covariance estimator of the MM estimator and that of the optimal GMM estimator are the same.
B_hat_st_SEE = sqrt(diag(B_hat_st_VCE));

%% 8. Hansen-Sargan test of overidentifying restrictions
e = y-exp(X*B_hat_st);
m_bar = (1/N_obs)*Z'*e; % Sample moments. Set Z = X. Calculate m_bar using e = y-exp(X*B_hat_so). Check the value of m_bar. Surprised?
J = N_obs*m_bar'*W_hat*m_bar;
J_df = N_mom-N_par; 
J_c_95 = chi2inv(0.95,J_df);
J_p = chi2cdf(J,J_df,'upper');

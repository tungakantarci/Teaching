% Empirical exercise - The maximum likelihood estimator and the linear regression model

%% 1. Aim of the exercise
% To understand how to use the ML estimator.

%% 2. Set seed
clear;
rng(1)

%% 3. Define the number of observations, number of all parameters in the model, number of coefficients
N_obs = 50;
N_par = 5; 
N_par_coefficients = 4;

%% 4. Simulate data 
x_0 = ones(N_obs,1);
x_1 = random('normal',0,1,N_obs,1); % Generate random numbers from the normal dis. with mean 0 and standard deviation 1. 
x_2 = random('normal',0,1,N_obs,1);
x_3 = random('normal',0,1,N_obs,1);
X = [x_0 x_1 x_2 x_3];
mu = 0; 
sigma = 0.5; % Also referred to as the square root of the mean squared error.
e = random('normal',mu,sigma,N_obs,1); % Generate random numbers from the normal dis. with mean mu and standard deviation sigma. 
B_true = [1 2 3 4]';
y = X*B_true+e;

%% 5. Obtain the ML estimates by maximising the maximum likelihood criterion function using the gradient computed analytically
T_ig = [1 1 1 1 1]'; % N_par x 1.  
options = optimset('GradObj','on','MaxFunEvals',1000,'Display','on','DerivativeCheck','off','Algorithm','trust-region');       
T_hat_a = fminunc(@(T_true)exercisemllrmfunction(y,X,T_true,N_obs,N_par),T_ig,options); % N_par x 1.

%% 6. Obtain the ML estimates by maximising the maximum likelihood criterion function using the gradient computed numerically 
T_ig = [1 1 1 1 1]';
options = optimset('GradObj','off','MaxFunEvals',1000,'Display','off','DerivativeCheck','off','Algorithm','quasi-newton');
T_hat_n = fminunc(@(T_true)exercisemllrmfunction(y,X,T_true,N_obs,N_par),T_ig,options);

%% 7. Alternative estimators of the variance-covariance matrix of the ML estimator
% Input for alternative estimators 
B_hat = T_hat_a(1:end-1);
sigma_hat = T_hat_a(end);
G = -(1/sigma_hat^2)*(y-X*B_hat).*-X; % N_obs x N_par_coefficients.  
Hessian_matrix_B_true = -(1/sigma_hat^2)*(X'*X); % N_par_coefficients x N_par_coefficients. The Hessian matrix is a square matrix. It contains the second derivative of the objective function with respect to the unknown paramaters of the model. That is, all the diagonal elements but the bottom right element are the second derivatives with respect to the elements of B_true. The bottom right element is the second derivate with respect to sigma squared. The off-diaogonal elements are the derivaites with respct to the elements of B_true and sigma squared. Here we consider part of the Hessian matrix that regard the second derivates with respect to the elements of B_true. 
Information_matrix_B_true = -Hessian_matrix_B_true; % N_par_coefficients x N_par_coefficients. Fisher's information matrix. The information matrix equality holds if Information matrix = - Hessian matrix.
% Alternative estimators 
B_hat_VCE_EH = inv(Information_matrix_B_true); % Empirical Hessian estimator. Derived under the information matrix equality.
B_hat_VCE_OPG = inv(G'*G); % Outer-product-of-the-gradient estimator. Derived under the information matrix equality.
B_hat_VCE_S = inv(Hessian_matrix_B_true)*(G'*G)*inv(Hessian_matrix_B_true); % "Sandwich” estimator. Derived if the information matrix equality does not hold. Compare with the estimator of the variance-covariance matrix of the OLS estimator that is robust to heteroskedasticity. They are the same. Are you surprised? 

%% 8. Inference
% t test
B_hat_SEE_S = sqrt(diag(B_hat_VCE_S));
t = B_hat./B_hat_SEE_S;
% Wald test
R = [0 1 0 0;0 0 1 0;0 0 0 1];
q = [0;0;0];
Wald = (R*B_hat-q)'*inv(R*B_hat_VCE_S*R')*(R*B_hat-q);
p = 1-chi2cdf(Wald,size(R,1));

%% 9. Obtain the OLS estimates and compare them with the ML estimates
LSS = exercisefunctionlssrobust(y,X);
% Compare the coefficient estimates
T_hat_a(1:end-1)
LSS.B_hat
% Compare the square root of the mean squared error estimates
T_hat_a(end)
LSS.sigma_hat % This is the square root of the mean squared error.
% Compare the estimated variance-covariance matrix of the ML and the OLS estimates
B_hat_VCE_S
LSS.B_hat_VCE_robust

%% 10. Bonus: search for global minimum
T_ig = [1 1 1 1 1]';
options = optimset('GradObj','on','MaxFunEvals',1000,'Display','on','DerivativeCheck','off');
Obj = @(T_true)exercisemllrmfunction(y,X,T_true);
problem = createOptimProblem('fmincon','objective',Obj,'x0',T_ig,'options',options);
gs = GlobalSearch('Display','iter');
T_hat_gs = run(gs,problem);

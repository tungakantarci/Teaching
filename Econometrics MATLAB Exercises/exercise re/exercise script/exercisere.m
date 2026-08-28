% Empirical exercise - The RE estimator as the FGLS estimator

%% 1. Aim of the exercise
% Understanding the random effects estimator as an application of the FGLS
% estimator.

%% 2. Load the data
clear;
% load 'M:\exercisere.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical Exercise/MATLAB/exercise re/exercise mat/exercisere.mat';
clearvars -except nr year wage union exper school black hisp mar hlth rur  

%% 3. Define the dependent variable
y = wage;

%% 4. Determine the number of units of observation, number of units of time, number of observations
uniq_ind = unique(nr);
uniq_tim = unique(year);
N = size(uniq_ind,1); % Unit of observation is an agent. There are 545 agents.
T = size(uniq_tim,1); % Unit of time is a year. There are 8 years of data for all agents in the data. Hence the panel is balanced.
NT = size(nr,1); % Number of observations. There are 4360 observations.

%% 5. The variance-covariance matrix of the error 
Omega = 0.11*kron(eye(N),ones(T,1)*ones(T,1)')+0.15*eye(NT); % Assume values for sigma squared mu and sigma squared nu. 

%% 6. Create a matrix containing dummy variables for panel units 
D = kron(eye(N),ones(T,1)); 

%% 7. Create projection matrices
I = eye(NT);
P_D = D*inv(D'*D)*D'; % Projection matrix for D. It can also be created using kron(eye(N),ones(T,T).*1/T). It is a block-diagonal matrix containing the within individual time average.
M_D = I-P_D;

%% 8. Create the systematic component of the regression equation
x_0 = ones(NT,1);
X = [x_0 union exper exper.*exper school black hisp mar hlth rur];  

%% 9. Obtain the estimated transformation matrix
BGS = exerciserefunbgs(y,X,NT,T,P_D);
WGS = exerciserefunwgs(y,X,NT,N,P_D,M_D);
sigma_hat_sq_bgs = BGS.sigma_hat_sq;
sigma_hat_sq_nu = WGS.sigma_hat_sq; % nu is the idiosyncratic component of the error. 
sigma_hat_sq_mu = sigma_hat_sq_bgs-sigma_hat_sq_nu/T; % mu is the individual component of the error.
Lambda_hat = 1-sqrt(sigma_hat_sq_nu/(sigma_hat_sq_nu+T*sigma_hat_sq_mu));  
Psi_hat = eye(NT)-Lambda_hat*P_D; % Below, Psi_hat is used to subtract from each observation of a variable (eye(N)) a fraction (Lambda) of the within individual time average of the observations of that variable (P_D).

%% 10. Obtain the RE coefficient estimates as the FGLS coefficient estimates
y_t = Psi_hat*y; % Transformed y. 
X_t = Psi_hat*X; % Transformed X.
B_hat_RE = inv(X_t'*X_t)*(X_t'*y_t);

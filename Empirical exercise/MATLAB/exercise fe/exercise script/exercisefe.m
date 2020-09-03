% Empirical exercise - The FE estimator as an application of the FWL theorem

%% 1. Aim of the exercise
% Learning to apply the FWL theorem, and to construct the fixed effects 
% estiamator that is widely used to estimate the paramaters of the fixed 
% effects panel data model.

%% 2. Load the data
clear;
% load 'M:\exercisefe.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise re/exercise mat/exercisere.mat'

%% 3. Drop variables and define the dependent variable
clearvars -except nr year wage exper union; 
y = log(wage);

%% 4. Determine the number of observations and individuals in the panel 
uniq = unique(nr);
N_ind = size(uniq,1);
N_obs = size(nr,1);

%% 5. Create a matrix containing dummy variables for panel units 
D = NaN(N_obs,N_ind);
for i = 1:N_ind
    D(:,i) = nr == uniq(i,1);
end

a = inv(D'*D);

%% 6. Create the systematic component of the LSDV model
Z = [exper exper.*exper union D];

%% 7. Estimate the LSDV model
B_hat_Z = (Z'*Z)\Z'*y;
B_hat_Z(1:3);

%% 8. Obtain the transformation matrix
X = [exper exper.*exper union]; % Add ones(N_obs,1) in X. Calculate B_hat_X. You will recieve an error. Is this surprising?
I = eye(N_obs);
P_D = D*inv(D'*D)*D' % Or, D*((D'*D)\D').
M_D = I-P_D;

%% 9. The FE model and the FWL theorem
M_D*y;
M_D*X;
B_hat_X = (X'*M_D*X)\X'*M_D*y;

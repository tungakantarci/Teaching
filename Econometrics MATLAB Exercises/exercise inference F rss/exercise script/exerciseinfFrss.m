% Empirical exercise - Inference - F test based on residual sum of squares

%% 1. Aim of the exercise
% Understanding the F test based on the residual sum of squares.

%% 2. Load the data 
clear;
% load 'M:\exerciseinferenceFrss.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise inference F rss/exercise mat file/exercise inference F rss.mat';
clearvars -except testscr str el_pct avginc; 

%% 3. Create the systematic component of the regression equation 
y = testscr;
N_obs = size(y,1);
x_0 = ones(N_obs,1);
X = [x_0 str el_pct];

%% 4. Obtain the relevant statistics to be used to construct the F test
LSS = exercisefunction(y,x_0);
RSS_restricted = LSS.RSS;
LSS = exercisefunction(y,X);
RSS_unrestricted = LSS.RSS;
F_df_restrictions = 2; % Test constraints degrees of freedom.
F_df_residual = N_obs-size(X,2); % Residual degrees of freedom.

%% 5. Hypothesis test on the significance of the model
F = ((RSS_restricted-RSS_unrestricted)/F_df_restrictions)/(RSS_unrestricted/F_df_residual);
F_critical_95 = finv(0.95,F_df_restrictions,F_df_residual); % One-sided test.
p = fcdf(F,F_df_restrictions,F_df_residual,'upper');

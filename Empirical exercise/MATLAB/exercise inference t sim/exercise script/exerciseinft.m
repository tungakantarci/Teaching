% Empirical exercise - Inference - Understanding the t test using the simulated t distribution

%% 1. Aim of the exercise
% Understanding the t test using the simulated t distribution. 

%% 2. Prepare the data and obtain the coefficient estimate of interest 

% 2.1. Load the data 
clear;
% load 'M:\exerciseinft.mat';
load '/Users/Tunga/Library/Mobile Documents/com~apple~CloudDocs/Academic/Teaching/Empirical exercise/MATLAB/exercise inference t sim/exercise mat/exerciseinft.mat';
clearvars -except lwage IQ exper educ age agesquared; 

% 2.2. Create the systematic component of the regression 
y = lwage;
N_obs = size(y,1);
x_0 = ones(N_obs,1);
X = [x_0 IQ exper educ];

% 2.3. Obtain the OLS coef. estimate of interest and the S.E. estimate of it
LSS = exercisefunctionlss(y,X);
B_hat_k = LSS.B_hat(2,1); % k = IQ. 
B_hat_k_SEE = LSS.B_hat_SEE(2,1); % Execute LSS.B_hat_SEE(2,1). To change the output display format you can use "format longG". 

%% 3. Determine the test statistic for the hypothesis test on the population coefficient

% 3.1. Hypothesised value of the true coefficient 
B_k_0 = 0.0075; % Typically this is 0 but not in this example. 

% 3.2. Determine the test statistic, state its distribution derived under the null hypothesis, and calculate it 
t = (B_hat_k-B_k_0)/B_hat_k_SEE; % t statistic has a t distribution under the null.  
t = round(t,2); % This is an adjustment to better visualise a plot later in the exercise.

% 3.3. Determine the degrees of freedom of the t distribution
t_df = N_obs-size(X,2);  

% 3.4. Calculate the p value corresponding to the t value 
p = (1-tcdf(abs(t),t_df))*2; % The test is two-tailed.

%% 4. Carry out the two-tailed t test using the "tabulated" t distribution

% 4.1. Calculate the critical t value ------ corresponding to a critical p value
t_c = tinv(0.025,t_df); % The test is two-tailed. Here critical p value refers to the significance level. Choose this as 0.05. Fail to reject the null since t > t_c. 
t_c = round(t_c,2); 

% 4.2. Calculate the critical p value corresponding to the critical t value 
p_c = (1-tcdf(abs(t_c),t_df))*2; % The test is two-tailed Fail to reject the null since p > p_c. 

%% 5. Carry out the two-tailed t test using the simulated t distribution

% Set the number of theoretical obs. for the data to be used to simulate the t distribution
N_obs_data_sim_t_dis = 100000; % What do you expect will happen if you increase this number? Check this after you complete the exercise.

% Generate a dataset of theoretical observations of a random var. with the distribution and deg. of freedom the test statistic would follow under the null hypothesis 
data_sim_t_dis = trnd(t_df,[N_obs_data_sim_t_dis,1]); % The random variable has a t distribution. Each time trnd is called, different random draws are taken from the t distribution. 

% 5.4. Plot the histogram of the t distribution
exerciseinftfundis(data_sim_t_dis);

% 5.5. Mark the t value 
exerciseinftfundist(data_sim_t_dis,t); 

% 5.6. Shade the areas where the random values are more extreme than the absolute value of the t value 
exerciseinftfundistp(data_sim_t_dis,t)

% 5.7. Calculate the shaded area associated with the t value which gives the simulated p value
t_extreme_value_dummy_t = abs(data_sim_t_dis) > abs(t);
p_sim = mean(t_extreme_value_dummy_t); % The fraction of the extreme values gives the probability area associated with the t value under the simulated t distribution. This gives the simulated p value! Compare p_sim with p! If you increase N_obs_sim_t_dis_data, p_sim gets closer to p. Why?

% 5.8. Mark the t value, mark the critical t value, shade the areas where the random values are more extreme than the absolute value of the t value, and shade the areas where the random values are more extreme than the absolute value of the critical t value. 
exerciseinftfundistptcpc(data_sim_t_dis,t,t_c)

% 5.9. Calculate the shaded area associated with the critical t value which gives the simulated critical p value
t_extreme_value_dummy_t_c = abs(data_sim_t_dis) > abs(t_c);
p_c_sim = mean(t_extreme_value_dummy_t_c); % The fraction of the extreme values gives the probability area associated with the critical t value under the simulated t distribution. This gives the simulated critical p value! Compare p_c_sim with p_c! If you increase N_obs_sim_t_dis_data, p_c_sim gets closer to p_c. Why?

%% 6. Exercise
exercise(data_sim_t_dis);

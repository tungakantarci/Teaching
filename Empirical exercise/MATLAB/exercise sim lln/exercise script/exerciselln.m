% Empirical exercise - Understanding the LLN using coin toss simulation

%% 1. Aim of the exercise
% Understanding the law of large numbers using coin toss simulation. 

%% 2. Convergence of the sample mean of coin tosses to the population mean

% 2.1. Clear the memory
clear;

% 2.2. Set the number of tosses
N_tosses = 15000; % What would happen if you increase this number? 

% 2.3. Create a sequence of tosses
sequence_of_tosses = randi([0,1],[N_tosses,1]); % The same sequence has to be used throughout the exercise. 

% 2.4. Create the sequence of sample means of cumulating tosses in the sequence of tosses
mean_sample = NaN(N_tosses,1); % Create an empty matrix for storing the sequence of sample means of cumulating tosses in the sequence of tosses
for i = 1:N_tosses
    mean_sample(i,1) = mean(sequence_of_tosses(1:i,1));
end

% 2.5. Define the population mean
mean_population = 0.5; 

% 2.6. Plot the sample mean and the population mean against the number of tosses
scatter(1:N_tosses,mean_sample,0.001,'Marker','.')
ylim([0 1]) % Set the range of y axis. 
hold on
line([0,N_tosses],[mean_population,mean_population],'Color','red') 
hold off
title('Fig. 1: Convergence of the sample mean to the population mean')
legend('Sample means of cumulating tosses','Population mean as the sample mean of cumulating tosses in the limit')
ylabel('Sample means of cumulating tosses') % Or, probability of heads if 1 represents heads. 
xlabel('Number of tosses')

% 2.7. Define the absolute difference and the tolerance parameter
abs_dif = abs(mean_sample-mean_population);
e = 0.01;

% 2.8. Create an indicator of whether the absolute difference is smaller than the tolerance parameter
abs_dif_smaller_than_e_dummy = abs_dif < e;

% 2.9. Plot the indicator against the number of tosses
scatter(1:N_tosses,abs_dif_smaller_than_e_dummy,0.001,'Marker','.')
ylim([-1 2]) 
title('Fig. 2: Cases where the sample mean is close to the population mean')
legend('1 if abs\_dif < e, 0 if abs\_dif > e')
ylabel('Whether the absolute difference is smaller than e') 
xlabel('Number of tosses')

%% 3. Convergence of the sample mean of coin tosses to the population mean in probability

% 3.1. Create an empty matrix for storing probabilities
prob_of_abs_dif_smaller_than_e = NaN(N_tosses,1);

% 3.2. Probability that the absolute difference is larger than the tolerance parameter in samples of cumulating tosses in the sequence of tosses
for i = 1:N_tosses
    prob_of_abs_dif_smaller_than_e(i,1) = mean(abs_dif_smaller_than_e_dummy(1:i,1)); 
end

% 3.3. Plot the probability that the absolute difference is larger than the tolerance parameter against the number of tosses
scatter(1:N_tosses,prob_of_abs_dif_smaller_than_e,0.001,'Marker','.')
ylim([0 1]) 
title('Fig. 3: Convergence of the sample mean to the pop. mean in probability')
ylabel('Probability of abs. dif. smaller than e') 
xlabel('Number of tosses')

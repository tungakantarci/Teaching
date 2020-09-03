% Empirical exercise - Inference - Function to simulate t distribution

function exerciseinftfundistp(data_sim_t_dis,t)
%% Set the number of bins for the histogram to be drawn
nbins = -5:0.01:5; % A number of bins is fixed here as otherwise MATLAB will use different bins in different histograms we will overlay later in the exercise.
%% Plot the histogram of the t distribution, mark the t value, and shade the areas where the random values are more extreme than the absolute value of the t value 
val_below_abs_t = data_sim_t_dis <= -abs(t);
val_above_abs_t = data_sim_t_dis >= abs(t);
val_between = data_sim_t_dis > -abs(t) & data_sim_t_dis < abs(t);
histogram(data_sim_t_dis(val_below_abs_t),nbins,'FaceColor','blue','EdgeAlpha',0.15); % The corresponding area is p_sim/2. See below.
hold on
histogram(data_sim_t_dis(val_above_abs_t),nbins,'FaceColor','blue','EdgeAlpha',0.15); % The corresponding area is p_sim/2. See below.
hold on
histogram(data_sim_t_dis(val_between),nbins,'FaceColor','white','EdgeAlpha',0.15);
hold on
line([t t],ylim,'Color','blue') 
hold off
title('Fig: Simulated t dis. with t value marked and prob. areas shaded')
legend('Values below -abs(t value)','Values above abs(t value)','Values between','t value')
ylabel('Frequency')
xlabel('t') 
end

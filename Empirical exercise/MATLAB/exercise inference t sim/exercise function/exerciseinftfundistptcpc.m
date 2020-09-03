% Empirical exercise - Inference - Function to simulate t distribution

function exerciseinftfundistptcpc(data_sim_t_dis,t,t_c)
%% Set the number of bins for the histogram to be drawn
nbins = -5:0.01:5; % A number of bins is fixed here as otherwise MATLAB will use different bins in different histograms we will overlay later in the exercise.
%% Plot the histogram of the t distribution, mark the t value, and shade the areas where the random values are more extreme than the absolute value of the t value 
val_below_abs_t_c = data_sim_t_dis <= -abs(t_c);
val_above_abs_t_c = data_sim_t_dis >= abs(t_c);

val_below_abs_t = data_sim_t_dis <= -abs(t);
val_above_abs_t = data_sim_t_dis >= abs(t);
val_between = data_sim_t_dis > -abs(t) & data_sim_t_dis < abs(t);

histogram(data_sim_t_dis(val_below_abs_t),nbins,'FaceColor','blue','EdgeAlpha',0.15); % Shade the area where the random values are more extreme than the absolute value of the t value.
hold on
histogram(data_sim_t_dis(val_below_abs_t_c),nbins,'FaceColor','red','EdgeAlpha',0.15); % Shade the area where the random values are more extreme than the absolute value of the critical t value.
hold on
histogram(data_sim_t_dis(val_above_abs_t),nbins,'FaceColor','blue','EdgeAlpha',0.15);
hold on
histogram(data_sim_t_dis(val_above_abs_t_c),nbins,'FaceColor','red','EdgeAlpha',0.15); % Fail to reject the null since p_sim > p_c. 
hold on
histogram(data_sim_t_dis(val_between),nbins,'FaceColor','white','EdgeAlpha',0.15);
hold on
line([t t],ylim,'Color','blue')
hold on
line([t_c t_c],ylim,'Color','red') % Mark the critical t value. Fail to reject the null since t > t_c.  
hold off
title('Fig. 4: Simulated t dis. with t and critical t values marked, prob. areas shaded')
legend('Values below -abs(t value)','Values below -abs(critical t value)','Values above abs(t value)','Values above abs(critical t value)','Values between','t value','critical t value')
ylabel('Frequency')
xlabel('t') 
end

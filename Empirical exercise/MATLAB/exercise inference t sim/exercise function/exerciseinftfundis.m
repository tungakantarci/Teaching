% Empirical exercise - Inference - Function to simulate t distribution

function exerciseinftfundis(data_sim_t_dis)
%% Set the number of bins for the histogram to be drawn
nbins = -5:0.01:5; % A number of bins is fixed here as otherwise MATLAB will use different bins in different histograms we will overlay later in the exercise.
%% Plot the histogram of the t distribution  
histogram(data_sim_t_dis,nbins,'FaceColor','white','EdgeAlpha',0.15);
title('Fig: Simulated t distribution')
legend('t distribution')
ylabel('Frequency')
xlabel('t')
end
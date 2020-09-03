% Empirical exercise - Inference - Function to simulate t distribution

function exerciseinftfundist(data_sim_t_dis,t)
%% Set the number of bins for the histogram to be drawn
nbins = -5:0.01:5; % A number of bins is fixed here as otherwise MATLAB will use different bins in different histograms we will overlay later in the exercise.
%% Plot the histogram of the t distribution and markt the t value 
histogram(data_sim_t_dis,nbins,'FaceColor','white','EdgeAlpha',0.15);
line([t t],ylim,'Color','blue') % Mark t value. Does this seem like a likely value to observe if in fact this is the true distribution?
title('Fig: Simulated t dis. with t value marked')
legend('t distribution','t value')
ylabel('Frequency')
xlabel('t') 
end

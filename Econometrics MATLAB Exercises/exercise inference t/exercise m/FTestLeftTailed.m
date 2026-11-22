function FTLT = FTestLeftTailed(nu1, nu2, alpha, fstat)
%FTESTLEFTTAILED Visualize the left-tailed F-test.
%   FTLT = FTestLeft(NU1, NU2, ALPHA, FSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. It calculates the
%   critical value corresponding to a left tailed F-test with NU1 and NU2
%   degrees of freedom at an ALPHA level of significance and plots the
%   related rejection region. A vertical line representing the manually
%   calculated F-test statistic valued FSTAT will be plotted, this input
%   argument is optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu1 <= 0)
    uiwait(warndlg(['The degrees of freedom of the first population' ...
        ' should be larger than zero.']));
    return
elseif (nu2 <= 0)
    uiwait(warndlg(['The degrees of freedom of the second population' ...
        ' should be larger than zero.']));
    return
elseif (mod(nu1, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of' ...
        ' freedom of the first population.']));
    return
elseif (mod(nu2, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of' ...
        ' freedom of the second population.']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and' ...
        ' one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the F-test statistic and make sure that
% the F-test statistic is nonnegative valued.
% -------------------------------------------------------------------------
if (nargin == 4)
    if (fstat < 0)
        uiwait(warndlg(['The test statistic cannot be negative valued,' ...
            ' please make sure that the test statistic is correctly' ...
            ' calculated.']));
        return
    end
    FTLT.Display = 1;
else
    FTLT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
FTLT.CV = icdf('F', alpha, nu1, nu2);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% large critical value. This has been done by setting the right end value
% of the interval to the value of the 99.99th percentile observation.
% -------------------------------------------------------------------------
FTLT.xmin = 0;
FTLT.xmax = icdf('F',0.9999,nu1,nu2);
FTLT.x = FTLT.xmin:0.01:FTLT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
FTLT.y = pdf('F',FTLT.x,nu1,nu2);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
FTLT.xleft = FTLT.xmin:0.001:FTLT.CV;
FTLT.yleft = pdf('F',FTLT.xleft,nu1,nu2);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the F-test statistic
% and calculate the p value. FTLT.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. FTLT.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. FTLT.scale scales the graph
% with respect to the monitor size of the user. xticks is used as it is
% necessary to show the exact critical value on the horizontal axis.
% -------------------------------------------------------------------------
FTLT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
FTLT.nodec = sprintf('%%.%df',0);
FTLT.variables = sprintf(['\\alpha = ',FTLT.alphadec,', \\nu_{1} = ', ...
    FTLT.nodec,', \\nu_{2} = ' FTLT.nodec],alpha,nu1,nu2);

FTLT.mp = get(0,'MonitorPositions');
FTLT.mwidth = FTLT.mp(1,3);
FTLT.mheight = FTLT.mp(1,4);
FTLT.scale = 0.8;

FTLT.gsize = FTLT.scale*FTLT.mheight;
FTLT.x0 = 0.5*(FTLT.mwidth - FTLT.gsize);
FTLT.y0 = 0.5*(FTLT.mheight - FTLT.gsize - 40);

figure
plot(FTLT.x,FTLT.y,'-black');
xticks(FTLT.CV);
title("F-distribution");
subtitle({FTLT.variables},'Interpreter','tex');
xlabel("F-value");
ylabel("Density");
FTLT.fig = gcf;
axis square
FTLT.fig.Position = [FTLT.x0,FTLT.y0,FTLT.gsize,FTLT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([FTLT.CV],'LineStyle',':','Color','#9a9afc','LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
FTLT.ar = area(FTLT.xleft,FTLT.yleft);
FTLT.ar.FaceColor = 'blue';
FTLT.ar.FaceAlpha = 0.15;
FTLT.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated F-test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the fourth argument (the value of the test
% statistic). In the case that there is no input for the fourth argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the fourth argument, if the F-test statistic is
% larger than the critical value. If this is the case, the null hypothesis
% cannot be rejected and a vertical light purple dotted line corresponding
% to the value of the F-test statistic and a light purple shaded area
% representing the p value will be added to the plot. Else, the null can be
% rejected and a purple vertical dotted line corresponding to the value of
% the test statistic and a dark purple shaded area displaying the p value
% will be plotted.
%
% Afterwards the subtitle will be updated and the code has finished 
% running.
% -------------------------------------------------------------------------
if (FTLT.Display == 1)
    if (fstat > FTLT.CV)
        xline(fstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        FTLT.tint = FTLT.CV:0.001:fstat;
        FTLT.ty = pdf('F',FTLT.tint,nu1,nu2);
        FTLT.tar = area(FTLT.tint,FTLT.ty);
        FTLT.tar.FaceColor = '#8a22b3';
        FTLT.tar.FaceAlpha = 0.04;
        FTLT.tar.EdgeColor = 'none';
    else
        xline(fstat, 'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        FTLT.tint = FTLT.xmin:0.001:fstat;
        FTLT.ty = pdf('F',FTLT.tint,nu1,nu2);
        FTLT.tar = area(FTLT.tint,FTLT.ty);
        FTLT.tar.FaceColor = '#8a22b3';
        FTLT.tar.FaceAlpha = 1;
        FTLT.tar.EdgeColor = 'none';
    end
    FTLT.pval = cdf('F',fstat,nu1,nu2);
    FTLT.empdec = sprintf('%%.%df',4);
    FTLT.pdec = sprintf('%%.%df',4);
    FTLT.tp = sprintf(['Test statistic = ',FTLT.empdec,',p value = ', ...
        FTLT.pdec],fstat,FTLT.pval);
    subtitle({FTLT.variables,FTLT.tp},'Interpreter','tex');
end
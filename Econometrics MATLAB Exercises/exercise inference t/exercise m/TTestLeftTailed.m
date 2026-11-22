function TTLT = TTestLeftTailed(nu, alpha, tstat)
%TTESTLEFTTAILED Visualize the left tailed Student's t-test.
%   TTLT = TTestLeft(NU, ALPHA, TSTAT) plots the theoretical student's
%   t-distribution with NU degrees of freedom. It calculates the critical
%   value corresponding to a left tailed t-test with NU degrees of freedom
%   at an ALPHA level of significance and plots the related rejection
%   region. A vertical line representing the manually calculated test
%   statistic valued TSTAT will be plotted, this input argument is
%   optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu <= 0)
    uiwait(warndlg('The degrees of freedom should be larger than zero.'));
    return
elseif (mod(nu, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of ' ...
        'freedom.']));
    return
elseif (alpha <= 0 || alpha > 0.5)
    uiwait(warndlg(['Please fill in a value of alpha larger than zero' ...
        ' and less than or equal to 0.5.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the test statistic and whether the input
% is valid.
% -------------------------------------------------------------------------
if (nargin == 3)
    TTLT.Display = 1;
    if (tstat > 0)
        uiwait(warndlg(['The test statistic is positive valued.' ...
            ' If this is intentional, please make use of the right' ...
            ' tailed test.']))
        return
    end
else 
    TTLT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
TTLT.CV = -icdf('T',1-alpha,nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% a large critical value. In most cases, the 0.01th percentile observation
% value for the left and and the 99.99th percentile observation value gives
% a good plot interval. When the degrees of freedom is very low (less than
% four), [min(TTLT.CV, -10), max(-TTLT.CV, 10)] results in an interval that
% allows the distribution to have visible tails.
% -------------------------------------------------------------------------
TTLT.xmin = min(TTLT.CV,max(-10,icdf('T',0.0001,nu)));
TTLT.xmax = max(-TTLT.CV,min(10,icdf('T',0.9999,nu)));
TTLT.x = TTLT.xmin:0.01:TTLT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
TTLT.y = pdf('T',TTLT.x,nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, since this area needs to be shown in
% the plot.
% -------------------------------------------------------------------------
TTLT.xleft = TTLT.xmin:0.001:TTLT.CV;
TTLT.yleft = pdf('T',TTLT.xleft,nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. TTLT.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. TTLT.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. TTLT.scale scales the graph
% with respect to the monitor size of the user. xticks is used as it is
% necessary to show the exact critical value on the horizontal axis.
% -------------------------------------------------------------------------
TTLT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
TTLT.nodec = sprintf('%%.%df',0);
TTLT.variables = sprintf(['\\alpha = ',TTLT.alphadec,', \\nu = ', ...
    TTLT.nodec],alpha,nu);

TTLT.mp = get(0,'MonitorPositions');
TTLT.mwidth = TTLT.mp(1,3);
TTLT.mheight = TTLT.mp(1,4);
TTLT.scale = 0.8;

TTLT.gsize = TTLT.scale*TTLT.mheight;
TTLT.x0 = 0.5*(TTLT.mwidth - TTLT.gsize);
TTLT.y0 = 0.5*(TTLT.mheight - TTLT.gsize - 40);

figure
plot(TTLT.x,TTLT.y,'-black');

% Without this if else statement we would get xtick([0 0]) as 
% min(0, TTLT.CV) = max(0, TTLT.CV) when TTLT.CV = 0.
if TTLT.CV == 0
    xticks(0);
else
    xticks([min(TTLT.CV,0) max(TTLT.CV,0)]);
end

title("t-distribution");
subtitle({TTLT.variables},'Interpreter','tex');
xlabel("t-value");
ylabel("Density");
TTLT.fig = gcf;
axis square
TTLT.fig.Position = [TTLT.x0,TTLT.y0,TTLT.gsize,TTLT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([TTLT.CV],'LineStyle',':','Color','#9a9afc','LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
TTLT.ar = area(TTLT.xleft,TTLT.yleft);
TTLT.ar.FaceColor = 'blue';
TTLT.ar.FaceAlpha = 0.15;
TTLT.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the test statistic is larger
% than the critical value. If this is the case, the null hypothesis cannot
% be rejected and a vertical light purple dotted line corresponding to the
% value of the test statistic and a light purple shaded area representing
% the p value will be added to the plot. Else, the null can be rejected and
% a purple vertical dotted line corresponding to the value of the test
% statistic and a dark purple shaded area displaying the p value will be
% plotted. The line will always be plotted, the corresponding area will
% only be shaded if it is contained in the interval of the plot.
%
% Afterwards the subtitle will be updated and the code has finished
% running.
% -------------------------------------------------------------------------
if (TTLT.Display == 1)
    if (tstat > TTLT.CV)
        xline(tstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        TTLT.tint = TTLT.CV:0.001:tstat;
        TTLT.ty = pdf('T',TTLT.tint, nu);
        TTLT.tar = area(TTLT.tint,TTLT.ty);
        TTLT.tar.FaceColor = '#8a22b3';
        TTLT.tar.FaceAlpha = 0.04;
        TTLT.tar.EdgeColor = 'none';
    else
        xline(tstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        if (tstat > TTLT.xmin)
            TTLT.tint = TTLT.xmin:0.001:tstat;
            TTLT.ty = pdf('T',TTLT.tint, nu);
            TTLT.tar = area(TTLT.tint,TTLT.ty);
            TTLT.tar.FaceColor = '#8a22b3';
            TTLT.tar.FaceAlpha = 1;
            TTLT.tar.EdgeColor = 'none';
        end
    end
    TTLT.pval = cdf('T',tstat,nu);
    TTLT.empdec = sprintf('%%.%df',4);
    TTLT.pdec = sprintf('%%.%df',4);
    TTLT.tp = sprintf(['Test statistic = ',TTLT.empdec,', p value = ', ...
        TTLT.pdec],tstat,TTLT.pval);
    subtitle({TTLT.variables,TTLT.tp},'Interpreter','tex');
end

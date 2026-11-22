function TTRT = TTestRightTailed(nu, alpha, tstat)
%TTESTRIGHTTAILED Visualize the right-tailed Student's t-test.
%   TTRT = TTestRight(NU, ALPHA, TSTAT) plots the theoretical student's
%   t-distribution with NU degrees of freedom. It calculates the critical
%   value corresponding to a right tailed t-test with NU degrees of freedom
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
    TTRT.Display = 1;
    if (tstat < 0)
        uiwait(warndlg(['The test statistic is negative valued.' ...
            ' If this is intentional, please make use of the left' ...
            ' tailed test.']))
        return
    end
else 
    TTRT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
TTRT.CV = icdf('T',1-alpha,nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% a large critical value. In most cases, the 0.01th percentile observation
% value for the left and and the 99.99th percentile observation value gives
% a good plot interval. When the degrees of freedom is very low (less than
% four), [min(-TTRT.CV, -10), max(TTRT.CV, 10)] results in an interval that
% allows the distribution to have visible tails.
% -------------------------------------------------------------------------
TTRT.xmin = min(-TTRT.CV,max(-10,icdf('T',0.0001,nu)));
TTRT.xmax = max(TTRT.CV, min(10,icdf('T',0.9999,nu)));
TTRT.x = TTRT.xmin:0.01:TTRT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
TTRT.y = pdf('T',TTRT.x,nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot
% -------------------------------------------------------------------------
TTRT.xright = TTRT.CV:0.001:TTRT.xmax;
TTRT.yright = pdf('T',TTRT.xright,nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. TTRT.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. TTRT.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. TTRT.scale scales the graph
% with respect to the monitor size of the user. xticks is used as it is
% necessary to show the exact critical value on the horizontal axis.
% -------------------------------------------------------------------------
TTRT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
TTRT.nodec = sprintf('%%.%df',0);
TTRT.variables = sprintf(['\\alpha = ',TTRT.alphadec,', \\nu = ', ...
    TTRT.nodec],alpha,nu);

TTRT.mp = get(0,'MonitorPositions');
TTRT.mwidth = TTRT.mp(1,3);
TTRT.mheight = TTRT.mp(1,4);
TTRT.scale = 0.8;

TTRT.gsize = TTRT.scale*TTRT.mheight;
TTRT.x0 = 0.5*(TTRT.mwidth - TTRT.gsize);
TTRT.y0 = 0.5*(TTRT.mheight - TTRT.gsize - 40);

figure
plot(TTRT.x,TTRT.y,'-black');

% Without this if else statement we would get xtick([0 0]) as 
% min(0, TTRT.CV) = max(0, TTRT.CV) when TTRT.CV = 0.
if TTRT.CV == 0 
    xticks(0);
else
    xticks([min(0,TTRT.CV) max(0,TTRT.CV)]);
end

title("t-distribution");
subtitle({TTRT.variables},'Interpreter','tex');
xlabel("t-value");
ylabel("Density");
TTRT.fig = gcf;
axis square
TTRT.fig.Position = [TTRT.x0,TTRT.y0,TTRT.gsize,TTRT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([TTRT.CV],'LineStyle',':','Color','#9a9afc','LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
TTRT.ar = area(TTRT.xright,TTRT.yright);
TTRT.ar.FaceColor = 'blue';
TTRT.ar.FaceAlpha = 0.15;
TTRT.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the test statistic is smaller
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
if (TTRT.Display == 1)
    if (tstat < TTRT.CV)
        xline(tstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        TTRT.tint = tstat:0.001:TTRT.CV;        
        TTRT.ty = pdf('T',TTRT.tint,nu);
        TTRT.tar = area(TTRT.tint,TTRT.ty);
        TTRT.tar.FaceColor = '#8a22b3';
        TTRT.tar.FaceAlpha = 0.04;
        TTRT.tar.EdgeColor = 'none';
    else
        xline(tstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        if (tstat < TTRT.xmax)
            TTRT.tint = tstat:0.001:TTRT.xmax;
            TTRT.ty = pdf('T',TTRT.tint,nu);
            TTRT.tar = area(TTRT.tint,TTRT.ty);
            TTRT.tar.FaceColor = '#8a22b3';
            TTRT.tar.FaceAlpha = 1;
            TTRT.tar.EdgeColor = 'none';
        end
    end
    TTRT.pval = 1-cdf('T',tstat,nu);
    TTRT.empdec = sprintf('%%.%df',4);
    TTRT.pdec = sprintf('%%.%df',4);
    TTRT.tp = sprintf(['Test statistic = ',TTRT.empdec,',p value = ', ...
        TTRT.pdec],tstat,TTRT.pval);
    subtitle({TTRT.variables,TTRT.tp},'Interpreter','tex');
end

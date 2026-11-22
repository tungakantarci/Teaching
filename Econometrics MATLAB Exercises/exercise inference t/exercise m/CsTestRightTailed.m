function CsTRT = CsTestRightTailed(nu, alpha, csstat)
%CSTESTRIGHTTAILED Visualize the right-tailed Chi-square test.
%   CSTR = CSTestRight(NU, ALPHA, CSSTAT) plots the theoretical Chi-square
%   distribution with NU degrees of freedom. It calculates the critical
%   value corresponding to a right tailed Chi-square test with NU degrees
%   of freedom at an ALPHA level of significance and plots the related
%   rejection region. A vertical line representing the manually calculated
%   Chi-square test statistic valued CSSTAT will be plotted, this input
%   argument is optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu <= 0)
    uiwait(warndlg(['The degrees of freedom should be larger than ' ...
        'zero.']));
    return
elseif (mod(nu, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of ' ...
        'freedom .']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and' ...
        ' one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the Chi-square test statistic and make
% sure that the Chi-square test statistic is nonnegative valued.
% -------------------------------------------------------------------------
if (nargin == 3)
    if (csstat < 0)
        uiwait(warndlg(['The test statistic cannot be negative valued,' ...
            ' please make sure that the test statistic is correctly' ...
            ' calculated.']));
        return
    end       
    CsTRT.Display = 1;
else
    CsTRT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
CsTRT.CV = icdf('Chisquare',1-alpha,nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having a large degrees of freedom can result in a large
% critical value. This has been done by setting the right end value of the
% interval to the value of the 99.99th percentile observation.
% -------------------------------------------------------------------------
CsTRT.xmin = 0;
CsTRT.xmax = icdf('Chisquare',0.9999,nu);
CsTRT.x = CsTRT.xmin:0.01:CsTRT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
CsTRT.y = pdf('Chisquare',CsTRT.x,nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
CsTRT.xright = CsTRT.CV:0.001:CsTRT.xmax;
CsTRT.yright = pdf('Chisquare',CsTRT.xright,nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the Chi-square test
% statistic and calculate the p value. CSTR.alphadec is used to determine
% the number of decimals for displaying alpha, which depends on the user
% and hence is dynamic. CSTR.nodec is used for the degrees of freedom,
% which don't have decimals. The code then asks for the size of the monitor
% of the user to calculate the size (in pixels) of the graph. CSTR.scale
% scales the graph with respect to the monitor size of the user. xticks is
% used as it is necessary to show the exact critical value on the
% horizontal axis.
% -------------------------------------------------------------------------
CsTRT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
CsTRT.nodec = sprintf('%%.%df',0);
CsTRT.variables = sprintf(['\\alpha = ',CsTRT.alphadec,', \\nu = ', ...
    CsTRT.nodec],alpha,nu);

CsTRT.mp = get(0,'MonitorPositions');
CsTRT.mwidth = CsTRT.mp(1,3);
CsTRT.mheight = CsTRT.mp(1,4);
CsTRT.scale = 0.8;

CsTRT.gsize = CsTRT.scale*CsTRT.mheight;
CsTRT.x0 = 0.5*(CsTRT.mwidth - CsTRT.gsize);
CsTRT.y0 = 0.5*(CsTRT.mheight - CsTRT.gsize - 40);

figure
plot(CsTRT.x,CsTRT.y,'-black');
xticks(CsTRT.CV);
title("Chi-square distribution")
subtitle({CsTRT.variables},'Interpreter','tex');
xlabel("Chi-square value");
ylabel("Density");
CsTRT.fig = gcf;
axis square
CsTRT.fig.Position = [CsTRT.x0,CsTRT.y0,CsTRT.gsize,CsTRT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([CsTRT.CV],'LineStyle',':','Color','#9a9afc','LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
CsTRT.ar = area(CsTRT.xright,CsTRT.yright);
CsTRT.ar.FaceColor = 'blue';
CsTRT.ar.FaceAlpha = 0.15;
CsTRT.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated Chi-square test
% statistic and compute the corresponding p value. This part of the code
% will only run when there is input for the third argument (the value of
% the test statistic). In the case that there is no input for the third
% argument, the p value will not be calculated and the function has
% finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the Chi-square test statistic
% is smaller than the critical value. If this is the case, the null
% hypothesis cannot be rejected and a vertical light purple dotted line
% corresponding to the value of the Chi-square test statistic and a light
% purple shaded area representing the p value will be added to the plot.
% Else, the null can be rejected and a purple vertical dotted line
% corresponding to the value of the test statistic and a dark purple shaded
% area displaying the p value will be plotted. The line will always be
% plotted, the corresponding area will only be shaded if it is contained in
% the interval of the plot.
%
% Afterwards the subtitle will be updated and the code has finished
% running.
% -------------------------------------------------------------------------
if (CsTRT.Display == 1)
    if (csstat < CsTRT.CV)
        xline(csstat, 'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        CsTRT.tint = csstat:0.001:CsTRT.CV;
        CsTRT.ty = pdf('Chisquare',CsTRT.tint,nu);
        CsTRT.tar = area(CsTRT.tint,CsTRT.ty);
        CsTRT.tar.FaceColor = '#8a22b3';
        CsTRT.tar.FaceAlpha = 0.04;
        CsTRT.tar.EdgeColor = 'none';
    else
        xline(csstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        if (csstat < CsTRT.xmax)
            CsTRT.tint = csstat:0.001:CsTRT.xmax;
            CsTRT.ty = pdf('Chisquare',CsTRT.tint,nu);
            CsTRT.tar = area(CsTRT.tint,CsTRT.ty);
            CsTRT.tar.FaceColor = '#8a22b3';
            CsTRT.tar.FaceAlpha = 1;
            CsTRT.tar.EdgeColor = 'none';
        end
    end
    CsTRT.pval = 1-cdf('Chisquare',csstat,nu);
    CsTRT.empdec = sprintf('%%.%df',4);
    CsTRT.pdec = sprintf('%%.%df',4);
    CsTRT.tp = sprintf(['Test statistic = ',CsTRT.empdec,',p value = ', ...
        CsTRT.pdec],csstat,CsTRT.pval);
    subtitle({CsTRT.variables,CsTRT.tp},'Interpreter','tex');
end

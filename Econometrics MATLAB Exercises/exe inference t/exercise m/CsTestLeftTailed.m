function CsTLT = CsTestLeftTailed(nu, alpha, csstat)
%CSTESTLEFTTAILED Visualize the left-tailed Chi-square test.
%   CsTLT = CSTestLeft(NU, ALPHA, CSSTAT) plots the theoretical Chi-square
%   distribution with NU degrees of freedom. It calculates the critical
%   value corresponding to a left tailed Chi-square test with NU degrees
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
    CsTLT.Display = 1;
else
    CsTLT.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
CsTLT.CV = icdf('Chisquare',alpha,nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having a large degrees of freedom can result in a large
% critical value. This has been done by setting the right end value of the
% interval to the value of the 99.99th percentile observation.
% -------------------------------------------------------------------------
CsTLT.xmin = 0;
CsTLT.xmax = icdf('Chisquare',0.9999,nu);
CsTLT.x = CsTLT.xmin:0.01:CsTLT.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
CsTLT.y = pdf('Chisquare',CsTLT.x,nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
CsTLT.xleft = CsTLT.xmin:0.001:CsTLT.CV;
CsTLT.yleft = pdf('Chisquare',CsTLT.xleft,nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the Chi-square test
% statistic and calculate the p value. CsTLT.alphadec is used to determine
% the number of decimals for displaying alpha, which depends on the user
% and hence is dynamic. CsTLT.nodec is used for the degrees of freedom,
% which don't have decimals. The code then asks for the size of the monitor
% of the user to calculate the size (in pixels) of the graph. CsTLT.scale
% scales the graph with respect to the monitor size of the user. xticks is
% used as it is necessary to show the exact critical value on the
% horizontal axis.
% -------------------------------------------------------------------------
CsTLT.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
CsTLT.nodec = sprintf('%%.%df',0);
CsTLT.variables = sprintf(['\\alpha = ',CsTLT.alphadec,',\\nu = ', ...
    CsTLT.nodec],alpha,nu);

CsTLT.mp = get(0,'MonitorPositions');
CsTLT.mwidth = CsTLT.mp(1,3);
CsTLT.mheight = CsTLT.mp(1,4);
CsTLT.scale = 0.8;

CsTLT.gsize = CsTLT.scale*CsTLT.mheight;
CsTLT.x0 = 0.5*(CsTLT.mwidth - CsTLT.gsize);
CsTLT.y0 = 0.5*(CsTLT.mheight - CsTLT.gsize - 40);

figure
plot(CsTLT.x,CsTLT.y,'-black');
xticks(CsTLT.CV);
title("Chi-square distribution");
subtitle({CsTLT.variables},'Interpreter','tex');
xlabel("Chi-square value");
ylabel("Density");
CsTLT.fig = gcf;
axis square
CsTLT.fig.Position = [CsTLT.x0,CsTLT.y0,CsTLT.gsize,CsTLT.gsize];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([CsTLT.CV], 'LineStyle',':','Color','#9a9afc','LineWidth',1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
CsTLT.ar = area(CsTLT.xleft,CsTLT.yleft);
CsTLT.ar.FaceColor = 'blue';
CsTLT.ar.FaceAlpha = 0.15;
CsTLT.ar.EdgeColor = 'none';

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
% is larger than the critical value. If this is the case, the null
% hypothesis cannot be rejected and a vertical light purple dotted line
% corresponding to the value of the Chi-square test statistic and a light
% purple shaded area representing the p value will be added to the plot.
% Else, the null can be rejected and a purple vertical dotted line
% corresponding to the value of the test statistic and a dark purple shaded
% area displaying the p value will be plotted.
%
% Afterwards the subtitle will be updated and the code has finished 
% running.
% -------------------------------------------------------------------------
if (CsTLT.Display == 1)
    if (csstat > CsTLT.CV)
        xline(csstat,'LineStyle',':','Color','#ae9ab5','LineWidth', ...
            1.4);
        CsTLT.tint = CsTLT.CV:0.001:csstat;
        CsTLT.ty = pdf('Chisquare',CsTLT.tint,nu);
        CsTLT.tar = area(CsTLT.tint,CsTLT.ty);
        CsTLT.tar.FaceColor = '#8a22b3';
        CsTLT.tar.FaceAlpha = 0.04;
        CsTLT.tar.EdgeColor = 'none';
    else
        xline(csstat,'LineStyle',':','Color','#8a22b3','LineWidth', ...
            1.4);
        CsTLT.tint = CsTLT.xmin:0.001:csstat;
        CsTLT.ty = pdf('Chisquare',CsTLT.tint, nu);
        CsTLT.tar = area(CsTLT.tint,CsTLT.ty);
        CsTLT.tar.FaceColor = '#8a22b3';
        CsTLT.tar.FaceAlpha = 1;
        CsTLT.tar.EdgeColor = 'none';
    end
    CsTLT.pval = cdf('Chisquare',csstat,nu);
    CsTLT.empdec = sprintf('%%.%df',4);
    CsTLT.pdec = sprintf('%%.%df',4);
    CsTLT.tp = sprintf(['Test statistic = ',CsTLT.empdec,',p value = ', ...
        CsTLT.pdec],csstat,CsTLT.pval);
    subtitle({CsTLT.variables,CsTLT.tp},'Interpreter','tex');
end

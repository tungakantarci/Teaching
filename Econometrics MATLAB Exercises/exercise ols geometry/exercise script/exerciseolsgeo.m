% Empirical exercise - The geometry of OLS

%% 1. Aim of the exercise
% To learn about the geometry of OLS.

%% 2. Clear the memory
clear

%% 3. Define variables as vectors in the 3D Euclidean space
t  = [0 0 0]'; % Define the origin and let this be the the 'tail' of all vectors.   
y  = [3 3 4]'; % The 'head' of the y vector. 
x1 = [3 1 1]'; 
x2 = [1 2 1]'; % There are two spaces: observation space and variable space. Here a variable is about a regressor. N is the dim. of the observation space. K is the dim. of the variable space. We have N = 3, K = 2. The variable space is a subspace of the observation space.

%% 4. Projection of y to the space S(x1,x2) and to the space orthogonal to S(x1,x2) 
N_obs = size(y,1);
I = eye(N_obs);
X  = [x1 x2];
P_X = X*inv(X'*X)*X';
M_X = I-P_X;
y_hat = P_X*y; % Or, X*inv(X'*X)*X'*y = X*B_hat. 
u_hat = M_X*y; % Or, y-y_hat.

%% 5. Plot the vectors in the 3D Euclidean space 
plot3([t(1) x1(1)],[t(2) x1(2)],[t(3) x1(3)],'cyan','LineWidth',1,'Marker','.','MarkerSize',15) % x1.
hold on
plot3([t(1) x2(1)],[t(2) x2(2)],[t(3) x2(3)],'magenta','LineWidth',1,'Marker','.','MarkerSize',15) % x2.
hold on
plot3([t(1) y(1)],[t(2) y(2)],[t(3) y(3)],'black','LineWidth',1,'Marker','.','MarkerSize',15) % y.
hold on
plot3([t(1) y_hat(1)],[t(2) y_hat(2)],[t(3) y_hat(3)],'blue','LineWidth',2) % y_hat.
hold on
plot3([y_hat(1) y(1)],[y_hat(2) y(2)],[y_hat(3) y(3)],'red','LineWidth',2) % u_hat. Connecting the head of the y_hat vector to the head of the y vector leads to that u_hat is orthogonal to y_hat. Why?    
hold on 
patch('xdata',[0 2.5 5],'ydata',[0 5 1.666],'zdata',[0 2.5 1.666],'FaceColor','blue','EdgeColor','none','FaceAlpha',0.05) % Space spanned by x1 and x2.
hold on
text(0.5,4,0,'S (x1,x2)','Color','blue')
hold on
text(2.5,4,3.5,'S^{\perp}(x1,x2)','Color','red')
grid on
axis([-1 5 -1 5 -1 5])
title('Fig. 1: The geometry of OLS')
xlabel('Obs. 1 in a vector in the x-coord.')
ylabel('Obs. 2 in a vector in the y-coord.')
zlabel('Obs. 3 in a vector in the z-coord.')
legend('x1','x2','y','y\_hat = P\_Xy = XB\_hat','u\_hat = M\_Xy','Space spanned by x1 and x2','Location','northeast')
view(50,15)

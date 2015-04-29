%% Basic Simulation Parameters
g = 32.2;
theta_0 = 0;
u_0 = 0;

X_u = -0.137;
X_w = 0.;
X_q = 0.;
X_d_T = 0.;
X_d_e = 0.;

Z_u = 0.;
Z_w = -0.137;
Z_q = 0.;
Z_d_T = 0.;
Z_d_e = 1.08;

M_u = 0.0136;
M_w = 0.;
M_wdot = 0.;
M_q = -0.0452;
M_d_T = 0.;
M_d_e = 1.0;

% Assumed to be zero
Z_wdot = 0;

%% Part 1 - Find the Eigenvalues
A = [[X_u, X_w, 0, -g*cos(theta_0), 0];
     [Z_u/(1-Z_wdot), Z_w/(1-Z_wdot), (Z_q + u_0)/(1-Z_wdot), -g*sin(theta_0)/(1-Z_wdot), 0];
     [M_u + (M_wdot * Z_u)/(1-Z_wdot), M_w + (M_wdot * Z_w)/(1-Z_wdot), M_q + (M_wdot*(Z_q+u_0))/(1-Z_wdot), -M_wdot*g*sin(theta_0)/(1-Z_wdot), 0];
     [0, 0, 1, 0, 0];
     [0, -1, 0, u_0, 0]];

B = [X_d_e;
     Z_d_e/(1-Z_wdot);
     M_wdot*Z_d_e/(1-Z_wdot) + M_d_e;
     0;
     0];

C = eye(5);

D = [0; 0; 0; 0; 0];

[v, d] = eig(A);

% disp('There are 3 modes of motion, they are:')
i1 = real(v(:, 1));
i2 = real(v(:, 2));
i5 = real(v(:, 5));

% disp(i1)
% initial(A, B, C, D, i1, 5)
% pause
% disp(i2)
% initial(A, B, C, D, i2, 50) % unstable
% pause
% disp(i5)
% initial(A, B, C, D, i5, 50)
% pause

%% Part 2 - Find Transfer Functions
[n, d] = ss2tf(A, B, C, D);
% disp('The transfer function for q is')
minreal(zpk(tf(n(3, :),d))) % q
% disp('The transfer function for \theta is')
minreal(zpk(tf(n(4, :),d))) % theta

%% Part 3 - Design controller
C0 = [0 0 1 1 0];
D0 = 0;

[num,den]=ss2tf(A,B,C0,D0);
plant = tf(num, den);
minreal(zpk(plant))

span=logspace(-2,2,1000);
bode(num,den, span)
pause

s = tf('s');
% comp = 40 * (s+1) / (s*(s+500));
comp = 40000 * (s+1) / (s*(s+500));

%% Part 4 - Simulink Simulation
sim('long',20)

% subplot(3,1,1)
plot(t,u, t,w,':', t,q,'-.')
legend('u', 'w', 'q')
pause
% subplot(3,1,2)
plot(t,h,'--')
legend('h')
pause
% subplot(3,1,3)
plot(t,theta,':', t,theta_c,'--')
legend('\theta', '\theta_c')
pause


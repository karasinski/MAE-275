%% Basic Simulation Parameters
g = 32.2;
theta_0 = 0;
u_0 = 0;

%% Longitudinal
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

A = [[X_u, X_w, 0, -g*cos(theta_0), 0];
     [Z_u/(1-Z_wdot), Z_w/(1-Z_wdot), (Z_q + u_0)/(1-Z_wdot), -g*sin(theta_0)/(1-Z_wdot), 0];
     [M_u + (M_wdot * Z_u)/(1-Z_wdot), M_w + (M_wdot * Z_w)/(1-Z_wdot), M_q + (M_wdot*(Z_q+u_0))/(1-Z_wdot), -M_wdot*g*sin(theta_0)/(1-Z_wdot), 0];
     [0, 0, 1, 0, 0];
     [0, -1, 0, u_0, 0]];

B = [0; 0; 0; 0; 0];

C = eye(5);

D = [0; 0; 0; 0; 0];

%% Find eigenvalues
[v, d] = eig(A);
i1 = real(v(:, 1));
i2 = real(v(:, 2));
i5 = real(v(:, 5));
initial(A, B, C, D, i1, 5)
pause
initial(A, B, C, D, i2, 50) % unstable
pause
initial(A, B, C, D, i5, 50)
pause

%% Find Transfer Functions
B = [X_d_e;
     Z_d_e/(1-Z_wdot);
     M_wdot*Z_d_e/(1-Z_wdot) + M_d_e;
     0;
     0];

C0 = [[0, 0, 1, 0, 0];
     [0, 0, 0, 1, 0]];
D0 = [0; 0];

[n, d] = ss2tf(A, B, C0, D0);
minreal(zpk(tf(n(1, :),d))) % q
minreal(zpk(tf(n(2, :),d))) % theta

%% Design controller
% First Loop
C1=[0 0 0 1 0];
D1=[0];

[num,den]=ss2tf(A,B,C1,D1);
minreal(zpk(tf(num,den)))

span=logspace(-2,2,1000);
bode(num,den, span)
grid on
pause

% Second Look
C2=[0 0 1 1 0];
D2=[0];

[num,den]=ss2tf(A,B,C2,D2);

rlocus(num,den)
pause

K=1.47; %determined from root locus
x0=[0 0 5*pi/180 0 0];
sim('long',20)

subplot(2,1,1)
plot(tout,u.signals.values,tout,w.signals.values,':')
legend('u','w')
subplot(2,1,2)
plot(tout,q.signals.values,tout,theta.signals.values,':',tout,1.47*(theta.signals.values+q.signals.values),'--')
legend('q','\theta','\delta_e')

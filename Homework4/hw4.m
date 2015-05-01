%% Basic Simulation Parameters
g = 32.2;
theta_0 = 0;
u_0 = 634;
h = 15000;

X_u = -0.01266;
X_w = -0.00588;
X_q = 0.;            % Assumed to be zero
X_d_T = 0.00414;
X_d_e = 0.;

Z_u = -0.1012;
Z_w = -0.818;
Z_wdot = -0.001616;
Z_q = 0.;            % Assumed to be zero
Z_d_T = 0.;
Z_d_e = -56.92;

M_u = -0.0004;
M_w = -0.02;
M_wdot = -0.000556;
M_q = -1.07;
M_d_T = 0.0001309;
M_d_e = -19.42;

%% Build A, B, C, D matrices
A = [[X_u, X_w, 0, -g*cos(theta_0)];
     [Z_u/(1-Z_wdot), Z_w/(1-Z_wdot), (Z_q + u_0)/(1-Z_wdot), -g*sin(theta_0)/(1-Z_wdot)];
     [M_u + (M_wdot * Z_u)/(1-Z_wdot), M_w + (M_wdot * Z_w)/(1-Z_wdot), M_q + (M_wdot*(Z_q+u_0))/(1-Z_wdot), -M_wdot*g*sin(theta_0)/(1-Z_wdot)];
     [0, 0, 1, 0]];

B = [-(X_u)                             -(X_w)                             X_d_e;
     -(Z_u/(1-Z_wdot))                  -(Z_w/(1-Z_wdot))                  Z_d_e/(1-Z_wdot);
     -(M_u + (M_wdot * Z_u)/(1-Z_wdot)) -(M_w + (M_wdot * Z_w)/(1-Z_wdot)) M_wdot*Z_d_e/(1-Z_wdot) + M_d_e;
      0                                  0                                 0];

C = [1 0     0 0;
     0 1/u_0 0 0;
     0 Z_w   0 0;
     0 0     0 1];

D = [0 0 0;
     0 0 0;
     0 0 Z_d_e;
     0 0 0];

sim('homework4', 15)

subplot(5,1,1)
plot(t,57.3 * theta)
ylabel('\theta')

subplot(5,1,2)
plot(t,57.3 * alpha)
ylabel('\alpha')

subplot(5,1,3)
plot(t,h)
ylabel('h')

subplot(5,1,4)
plot(t,u)
ylabel('u')

subplot(5,1,5)
plot(t,a_z)
ylabel('a_z')
xlabel('Time (s)')
pause

subplot(3,1,1)
plot(t, u_gust)
ylabel('u_{gust}')

subplot(3,1,2)
plot(t, w_gust)
ylabel('w_{gust}')

subplot(3,1,3)
plot(t,57.3 * delta_e)
ylabel('\delta_e')
xlabel('Time (s)')

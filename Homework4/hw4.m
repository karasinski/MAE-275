set(gca, 'LooseInset', get(gca, 'TightInset'));

%% Basic Simulation Parameters
g = 32.2;
theta_0 = 0;
u_0 = 634;
h_0 = 15000;

X_u = -0.01266;
X_w = -0.00588;
X_wdot = 0;          % Assumed to be zero
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
a = 1 / (1 - Z_wdot);
A = [ X_u + a * X_wdot * Z_u   X_w + a * X_wdot * Z_w   X_q + a * X_wdot * (u_0 + Z_q)   -g * (cos(theta_0) + a * X_wdot * sin(theta_0)) 0;
                     a * Z_u                  a * Z_w                  a * (u_0 + Z_q)                           -a * (g * sin(theta_0)) 0;
      M_u + a * M_wdot * Z_u   M_w + a * M_wdot * Z_w   M_q + a * M_wdot * (u_0 + Z_q)                    -a * M_wdot * g * sin(theta_0) 0;
                           0                        0                                1                                                 0 0;
                           0                       -1                                0                                               u_0 0];

B = [ -(X_u + a * X_wdot * Z_u)   -(X_w + a * X_wdot * Z_w)   -(X_q + a * X_wdot * (u_0 + Z_q))   a * X_wdot * Z_d_e + X_d_e;
                     -(a * Z_u)                  -(a * Z_w)                          -(a * Z_q)                    a * Z_d_e;
      -(M_u + a * M_wdot * Z_u)   -(M_w + a * M_wdot * Z_w)   -(M_q + a * M_wdot * (u_0 + Z_q))   a * M_wdot * Z_d_e + M_d_e;
                              0                           0                                   0                            0;
                              0                           0                                   0                            0];

C = [1              0        0 0 0;
     0              1/u_0    0 0 0;
     % a * Z_u        a * Z_w  0 0 0;
     0            Z_w/u_0        0 0 0;
     0              0        0 1 0;
     0              0        0 0 1];

D = [ 0               0              0 0;
      0               0              0 0;
     % -Z_u/(1-Z_wdot) -Z_w/(1-Z_wdot) 0 0;
      0               0              0 Z_d_e;
      0               0              0 0;
      0               0              0 0];

sim('homework4', 15)

fig1 = figure;
subplot(2,1,1)
plot(t,57.3 * theta)
ylabel('\theta (deg)')

subplot(2,1,2)
plot(t,57.3 * alpha)
ylabel('\alpha (deg)')
xlabel('Time (s)')
saveas(fig1, 'figures/output angles.pdf');
% pause

fig2 = figure;
subplot(3,1,1)
plot(t,h_0 + h)
ylabel('h (ft)')

subplot(3,1,2)
plot(t,u_0 + u)
ylabel('u (ft/s)')

subplot(3,1,3)
plot(t,a_z/g)
ylabel('a_z (g)')
xlabel('Time (s)')
saveas(fig2, 'figures/output x.pdf');
% pause

fig3 = figure;
subplot(2,1,1)
plot(t, u_gust, t, w_gust, '--', t, q_gust, '-.')
legend('u_{gust}', 'w_{gust}', 'q_{gust}')
ylabel('Turbulence Field (ft/s)')

subplot(2,1,2)
plot(t,57.3 * delta_e)
ylabel('\delta_e (deg)')
xlabel('Time (s)')
saveas(fig3, 'figures/input.pdf');

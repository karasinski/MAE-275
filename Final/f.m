%% Basic Simulation Parameters
g = 32.2;
theta_0 = 0;
u_0 = 218;
h_0 = 0;

X_u = -0.054534;
X_w =  0.064327;
X_wdot = 0;          % Assumed to be zero
X_q = 0.;            % Assumed to be zero

Z_u = -0.286953;
Z_wdot = 0;
Z_w = -0.528871;
Z_q = 0.;            % Assumed to be zero

M_u = -0.000165;
M_wdot = -0.000289;
M_w = -0.007964;
M_q = -0.327532;

X_d_e =   0.732836;
Z_d_e = -14.713536;
M_d_e =  -2.188878;

X_d_T =  0.001317;
Z_d_T = -0.000250;
M_d_T =  0.000004;

%% Build A, B, C, D matrices
a = 1 / (1 - Z_wdot);
A = [X_u + a * X_wdot * Z_u   X_w + a * X_wdot * Z_w   X_q + a * X_wdot * (u_0 + Z_q)   -g * (cos(theta_0) + a * X_wdot * sin(theta_0)) 0;
                    a * Z_u                  a * Z_w                  a * (u_0 + Z_q)                           -a * (g * sin(theta_0)) 0;
     M_u + a * M_wdot * Z_u   M_w + a * M_wdot * Z_w   M_q + a * M_wdot * (u_0 + Z_q)                    -a * M_wdot * g * sin(theta_0) 0;
                          0                        0                                1                                                 0 0;
                          0                       -1                                0                                               u_0 0];

B = [a * X_wdot * Z_d_e + X_d_e  a * X_wdot * Z_d_T + X_d_T  -(X_u + a * X_wdot * Z_u)  -(X_w + a * X_wdot * Z_w)  -(X_q + a * X_wdot * (u_0 + Z_q));
                      a * Z_d_e                   a * Z_d_T                 -(a * Z_u)                 -(a * Z_w)                         -(a * Z_q);
     a * M_wdot * Z_d_e + M_d_e  a * M_wdot * Z_d_T + M_d_T  -(M_u + a * M_wdot * Z_u)  -(M_w + a * M_wdot * Z_w)  -(M_q + a * M_wdot * (u_0 + Z_q));
                              0                           0                          0                          0                                  0;
                              0                           0                          0                          0                                  0];

C = [1 0 0 0 0;
     0 0 0 0 1;
     0 0 0 1 0];

D = [0 0 0 0 0;
     0 0 0 0 0;
     0 0 0 0 0];


[a, b, c, d] = linmod('controller1');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf1 = tf(num, den)
cont1 = tf([-1.2052e+00 -9.9202e+00 -1.7752e+01], [1.0000e+00 5.3192e+00 0])

[a, b, c, d] = linmod('controller2');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf2 = tf(num, den)
cont2 = tf([7.8719e+01 4.3430e+01 4.0228e+00], [1.0000e+00 2.5000e-01 0])

[a, b, c, d] = linmod('Kp_theta_gain');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf3 = tf(num, den)
Kp_theta = 1.75

[a, b, c, d] = linmod('Kp_h_gain');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf4 = tf(num, den)
Kp_h = 0.00173

sim('final', 12)
subplot(211)
plot(t, u, t, h)
legend('u', 'h')
ylabel('ft (/s)')
subplot(212)
plot(t, 57.3 * theta)
ylabel('theta (degs)')
xlabel('Time (s)')


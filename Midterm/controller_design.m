g = 32.2;
theta_0 = 0;

u_0 = 246;
X_u = -0.0214;
X_w =  0.0957;
Z_u = -0.231;
Z_w = -0.634;
Z_wdot = 0;
M_u = -0.778e-5;
M_w = -0.00145;
X_d_T = 0.554e-4;
X_d_e = 0.45;
Z_d_T = -0.193e-5;
Z_d_e = -9.53;
Z_q = 0;
M_d_T = 0.144e-6;
M_d_e = -0.688;
M_wdot = -0.000884;
M_q = -0.610;

% Assumed to be zero
X_wdot = 0;
X_q = 0;

a = 1 / (1 - Z_wdot);
A = [X_u + a * X_wdot * Z_u   X_w + a * X_wdot * Z_w   X_q + a * X_wdot * (u_0 + Z_q)   -g * (cos(theta_0) + a * X_wdot * sin(theta_0))   0;
                    a * Z_u                  a * Z_w                  a * (u_0 + Z_q)                           -a * (g * sin(theta_0))   0;
     M_u + a * M_wdot * Z_u   M_w + a * M_wdot * Z_w   M_q + a * M_wdot * (u_0 + Z_q)                    -a * M_wdot * g * sin(theta_0)   0;
                          0                        0                                1                                                 0   0;
                          0                       -1                                0                                               u_0   0];

B = [a * X_wdot * Z_d_e + X_d_e   a * X_wdot * Z_d_T + X_d_T   -(X_u + a * X_wdot * Z_u);
                      a * Z_d_e                    a * Z_d_T                  -(a * Z_u);
     a * M_wdot * Z_d_e + M_d_e   a * M_wdot * Z_d_T + M_d_T   -(M_u + a * M_wdot * Z_u);
                              0                            0                           0;
                              0                            0                           0];

C = [1    0       0   0     0;
     0    1/u_0   0   0     0;
     0    0       0   0     1;
     0   -1       0   u_0   0;
     0    0       0   1     0];

D = [0   0   0;
     0   0   0;
     0   0   0;
     0   0   0;
     0   0   0];

s = tf('s');

fig0 = figure;
[a, b, c, d] = linmod('theta_dele');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf0 = tf(num,den);
zpk(tf0)
% sisotool('bode', tf0)
c0 = -260 * ((s+0.8)*(s+0.1)) / (s*(s+2)*(s+100));
sys0 = tf0 * c0;
margin(sys0)
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig0, 'figures/open_comp_theta.pdf');

fig0 = figure;
bode(sys0/(1 + sys0))
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig0, 'figures/close_comp_theta.pdf');


fig1 = figure;
[a, b, c, d] = linmod('u_delT');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf1 = tf(num,den);
zpk(tf1)
% sisotool('bode', tf0)
c1 = 30909 * ((s+0.1)) / (s*(s+5));
sys1 = tf1 * c1;
margin(sys1)
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/open_comp_u.pdf');

fig1 = figure;
bode(sys1/(1 + sys1))
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig1, 'figures/close_comp_u.pdf');

fig2 = figure;
[a, b, c, d] = linmod('hdot_dele');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf2 = tf(num,den);
zpk(tf2)
% sisotool('bode', tf0)
c2 = 0.00055 * (1) / (s);
sys2 = tf2 * c2;
margin(sys2)
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig2, 'figures/open_comp_hdot.pdf');

fig2 = figure;
bode(sys2/(1 + sys2))
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig2, 'figures/close_comp_hdot.pdf');

%% Simulation Parameters
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


%% Controller Design
[a, b, c, d] = linmod('controller1');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf1 = tf(num, den)
% cont1 = tf([-1.2052e+00 -9.9202e+00 -1.7752e+01], [1.0000e+00 5.3192e+00 0])
cont1 = -2 * (s^2 + 0.04*s + 0.04) * (s^2 + s + 1.25) / (s * (s + 0.1)^3)

fig1 = figure;
bode(tf1, tf1 * cont1, '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Open-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/openloop_gc1.pdf');

fig1 = figure;
bode(tf1/(1 + tf1), tf1 * cont1 / (1 + tf1 * cont1), '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Close-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig1, 'figures/closeloop_gc1.pdf');

[a, b, c, d] = linmod('controller2');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf2 = tf(num, den)
% cont2 = tf([7.8719e+01 4.3430e+01 4.0228e+00], [1.0000e+00 2.5000e-01 0])
cont2 = 335 * (s + 0.1) / (s * (s + 1.5))

fig1 = figure;
bode(tf2, tf2 * cont2, '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Open-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/openloop_gc2.pdf');

fig1 = figure;
bode(tf2/(1 + tf2), tf2 * cont2 / (1 + tf2 * cont2), '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Close-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig1, 'figures/closeloop_gc2.pdf');

[a, b, c, d] = linmod('Kp_theta_gain');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf3 = tf(num, den)
% Kp_theta = 1.75
Kp_theta = 2.04

fig1 = figure;
bode(tf3, tf3 * Kp_theta, '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Open-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig1, 'figures/openloop_Kp_theta.pdf');

[a, b, c, d] = linmod('Kp_h_gain');
[a, b, c, d] = minreal(a, b, c, d);
[num,den]=ss2tf(a, b, c, d);
tf4 = tf(num, den)
% Kp_h = 0.00212
Kp_h = 0.0024

fig1 = figure;
bode(tf4, tf4 * Kp_h, '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Open-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
pause
saveas(fig1, 'figures/openloop_Kp_h.pdf');


%% Case 1 (switches down)
pause

sim('final', 12)
% subplot(611)
fig1 = figure;
plot(t, 57.3 * de, 'LineWidth',2)
ylabel('deg')
legend('\delta_e')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/1_de.pdf');

% subplot(612)
fig1 = figure;
plot(t, dt, 'LineWidth',2)
ylabel('lbf')
legend('\delta_T')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/1_dt.pdf');

% subplot(613)
fig1 = figure;
plot(t, u, 'LineWidth',2)
legend('u')
ylabel('ft/s')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/1_u.pdf');

% subplot(614)
fig1 = figure;
plot(t, 57.3 * theta, 'LineWidth',2)
legend('\theta')
ylabel('deg')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/1_theta.pdf');

% subplot(615)
fig1 = figure;
plot(t, ug, t, wg, t, qg)
ylabel('ft/s')
legend('u_g', 'w_g', 'q_g', 'LineWidth',2)
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/1_gusts.pdf');

% subplot(616)
fig1 = figure;
plot(t, h, 'LineWidth',2)
legend('h')
ylabel('ft')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/1_h.pdf');
close all


% Case 2 (switches up)
pause

sim('final', 25)
% subplot(511)
fig1 = figure;
plot(t, 57.3 * de, 'LineWidth',2)
ylabel('deg')
legend('\delta_e')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/2_de.pdf');

% subplot(512)
fig1 = figure;
plot(t, dt, 'LineWidth',2)
ylabel('lbf')
legend('\delta_T')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/2_dt.pdf');

% subplot(513)
fig1 = figure;
plot(t, u, 'LineWidth',2)
legend('u')
ylabel('ft/s')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/2_u.pdf');

% subplot(514)
fig1 = figure;
plot(t, 57.3 * theta, 'LineWidth',2)
legend('\theta')
ylabel('deg')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/2_theta.pdf');

% subplot(515)
fig1 = figure;
plot(t, h, t, h_c, 'LineWidth',2)
legend('h', 'h_c')
ylabel('ft')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/2_h.pdf');
close all

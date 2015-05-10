clear all; close all;

%% Basic Simulation Parameters
g = 32.2;
theta_0 = 0;
u_0 = 468.2;
h_0 = 15000;

Y_v = -0.1008;
Y_beta = -47.2;
Y_d_a = 0;
Y_d_a_star = 0;
Y_d_r = 13.48;
Y_d_r_star = 0.0288;

L_beta = -2.68;
L_p = -1.233;
L_r = 0.391;
L_d_a = -1.62;
L_d_r = 0.374;

L_beta_prime = -2.71;
L_p_prime = -1.232;
L_r_prime = 0.397;
L_d_a_prime = -1.62;
L_d_r_prime = 0.392;
L_v_prime = L_beta_prime/u_0;

N_beta = 1.271;
N_p = -0.048;
N_r = -0.252;
N_d_a = -0.0365;
N_d_r = -0.86;

N_beta_prime = 1.301;
N_p_prime = -0.0346;
N_r_prime = -0.257;
N_d_a_prime = -0.01875;
N_d_r_prime = -0.864;
N_v_prime = N_beta_prime/u_0;

% Assumed to be zero
Y_p = 0;
Y_r = 0;

%% Build A, B, C, D matrices
A = [[      Y_v,       Y_p,    Y_r - u_0, g * cos(theta_0), 0];
     [L_v_prime, L_p_prime,    L_r_prime,                0, 0];
     [N_v_prime, N_p_prime,    N_r_prime,                0, 0];
     [        0,         1, tan(theta_0),                0, 0];
     [        0,         0, sec(theta_0),                0, 0]];

B = [Y_d_r       Y_d_a; 
     L_d_r_prime L_d_a_prime; 
     N_d_r_prime N_d_a_prime; 
     0 0;
     0 0];

C = [[1/u_0, 0, 0, 0, 0];   % beta
     [    0, 0, 1, 0, 0];   % r
     [    0, 0, 0, 1, 0];   % phi
     [    1, 0, 0, 0, 0];   % v
     [    0, 1, 0, 0, 0];   % p
     [    0, 0, 0, 0, 1]];  % psi

D = [0 0; 
     0 0; 
     0 0; 
     0 0; 
     0 0; 
     0 0;];

%% Design Controllers

% [a, b, c, d] = linmod('homework5');
% [a, b, c, d] = minreal(a, b, c, d);
% [num,den]=ss2tf(a, b, c, d);
% tf0 = tf(num,den);
% sisotool('bode', tf0);
% zpk(tf0)
% w=logspace(-3, 3, 6000);
% bode(tf0, w)

%% Load Controllers/Run Simulation
load('comps.mat')
sim('homework5', 50)

% subplot(2, 1, 1)
fig1 = figure;
plot(t,57.3 * delta_r, 'LineWidth',2)
ylabel('\delta_r (deg)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/delta_r.pdf');
% subplot(2, 1, 2)
fig1 = figure;
plot(t,57.3 * delta_a, 'LineWidth',2)
ylabel('\delta_a (deg)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/delta_a.pdf');
% pause

% subplot(3, 1, 1)
fig1 = figure;
plot(t,57.3 * r, 'LineWidth',2)
ylabel('r (deg/s)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/r.pdf');
% subplot(3, 1, 2)
fig1 = figure;
plot(t,57.3 * phi, t,57.3 * phi_c, '--', 'LineWidth',2)
ylabel('\phi (deg)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
legend('\phi', '\phi_c')
saveas(fig1, 'figures/phi.pdf');
% subplot(3, 1, 3)
fig1 = figure;
plot(t,57.3 * beta, 'LineWidth',2)
ylabel('\beta (deg)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/beta.pdf');

%% Draw a Circle
fig1 = figure;
sim('homework5', 267)
plot(X_dot, Y_dot)
axis('equal') 
xlabel('$$\dot{X}$$ (ft/s)', 'interpreter', 'latex')
ylabel('$$\dot{Y}$$ (ft/s)', 'interpreter', 'latex')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/circle.pdf');

%% SS Matrices from Assignment
% State variables v, p, r, phi, psi
A = [-8.29e-2    0       -6.6e2   3.22e1 0,
     -6.8939e-3 -1.7      1.72e-1 0      0,
      5.1212e-3 -6.54e-2 -8.93e-2 0      0,
      0          1        0       0      0,
      0          0        1       0      0];

% Controls aileron (delta_a) and rudder (delta_r)
B = [ 0      7.65,
     27.3    0.576,
      0.393 -1.36,
      0      0,
      0      0];

% Output variables roll-rate (p), and sideslip (beta)
C = [0     1 0 0 0,
     1/660 0 0 0 0];

D = [0 0,
     0 0];

%% Find coupling numerators
[n1, d] = ss2tf(A, B, C, D, 1);
[n2, d] = ss2tf(A, B, C, D, 2);

p11 = tf(n1(1, :), d);
p12 = tf(n2(1, :), d);
p21 = tf(n1(2, :), d);
p22 = tf(n2(2, :), d);

P = [p11 p12,
     p21 p22];

K = eye(2);
PE = P * K;
detPE = PE(1, 1) * PE(2, 2) - PE(1, 2) * PE(2, 1);
detPE = minreal(detPE);

tf1 = minreal(zpk(PE(1,1))); % p/v1
tf2 = minreal(zpk(PE(1,2))); % p/v2
tf3 = minreal(zpk(PE(2,1))); % beta/v1
tf4 = minreal(zpk(PE(2,2))); % beta/v2

PEI11 = PE(2, 2) / detPE;
PEI22 = PE(1, 1) / detPE;
PEI12 = PE(2, 1) / detPE;
PEI21 = PE(1, 2) / detPE;

Y1V1 = 1 / PEI11;
Y2V2 = 1 / PEI22;
Y1V2 = 1 / PEI12;
Y2V1 = 1 / PEI21;

minreal(zpk(Y1V1)); % p/v1    beta -> v2
minreal(zpk(Y2V2)); % beta/v2 p    -> v1
minreal(zpk(Y1V2)); % p/v2    beta -> v1
minreal(zpk(Y2V1)); % beta/v1 p    -> v2

%% Compensators
s = tf('s');
comp1 = 0.18 * (s + 2) / s;
comp2 = 3.72 * (s^2 + .2 * s + 3.5)/(.05 * s^2 + s);

%% Bode Plots
fig1 = figure;
bode(tf1, tf1 * comp1, '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Open-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/openloop_p.pdf');

fig2 = figure;
bode(tf1/(1 + tf1), tf1 * comp1 / (1 + tf1 * comp1), '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Closed-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig2, 'figures/closeloop_p.pdf');

fig3 = figure;
bode(Y2V2, Y2V2 * comp2, '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Open-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig3, 'figures/openloop_beta.pdf');

fig4 = figure;
bode(Y2V2/(1 + Y2V2), Y2V2 * comp2 / (1 + Y2V2 * comp2), '--')
h = legend('Uncompensated', 'Compensated');
set(h,'FontSize',14);
legend('location', 'SouthWest')
title('Closed-loop Bode')
xlim([.01 100])
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig4, 'figures/closeloop_beta.pdf');

%% Run Simulation
for i = 1:2
  sim('homework6')

  %% Plots
  fig5 = figure;
  plot(t, 57.3 * p, t, 57.3 * p_c, '--', 'LineWidth', 2)
  legend('p', 'p_c')
  ylabel('Value (degrees)')
  xlabel('Time (s)')
  set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
  set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
  saveas(fig5, strjoin({'figures/p'; num2str(i); '.pdf'}, ''));


  fig6 = figure;
  plot(t, 57.3 * beta, t, 57.3 * beta_c, '--', 'LineWidth', 2)
  legend('\beta', '\beta_c')
  ylabel('Value (degrees)')
  xlabel('Time (s)')
  set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
  set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
  saveas(fig6, strjoin({'figures/beta'; num2str(i); '.pdf'}, ''));

  fig7 = figure;
  plot(t, 57.3 * delta_a, t, 57.3 * delta_r, '--', 'LineWidth', 2)
  legend('\delta_a', '\delta_r')
  ylabel('Value (degrees)')
  xlabel('Time (s)')
  set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
  set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
  saveas(fig7, strjoin({'figures/inputs'; num2str(i); '.pdf'}, ''));

  pause
end

close all

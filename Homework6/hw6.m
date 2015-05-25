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

s = tf('s');

% Compensators
comp1 = 0.18 * (s + 2) / s;
comp2 = 3.72 * (s^2 + .2 * s + 3.5)/(.05 * s^2 + s);

%% Run Simulation
sim('homework6')

%% Plots
fig1 = figure;
plot(t, 57.3 * p, t, 57.3 * p_c, '--', 'LineWidth', 2)
legend('p', 'p_c')
ylabel('Value (degrees)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/p.pdf');

fig2 = figure;
plot(t, 57.3 * beta, t, 57.3 * beta_c, '--', 'LineWidth', 2)
legend('\beta', '\beta_c')
ylabel('Value (degrees)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/beta.pdf');

fig3 = figure;
plot(t, 57.3 * delta_a, t, 57.3 * delta_r)
legend('\delta_a', '\delta_r')
ylabel('Value (degrees)')
xlabel('Time (s)')
set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
saveas(fig1, 'figures/inputs.pdf');

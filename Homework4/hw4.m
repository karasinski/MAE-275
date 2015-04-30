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

M_u = -0.000407;
M_w = -0.02;
M_wdot = -0.000556;
M_q = -1.07;
M_d_T = 0.0001309;
M_d_e = -19.42;

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
% 
% [v, d] = eig(A);
% 
% % disp('There are 3 modes of motion, they are:')
% i1 = real(v(:, 1));
% i2 = real(v(:, 2));
% i5 = real(v(:, 5));
% 
% % disp(i1)
% % initial(A, B, C, D, i1, 5)
% % pause
% % disp(i2)
% % initial(A, B, C, D, i2, 50) % unstable
% % pause
% % disp(i5)
% % initial(A, B, C, D, i5, 50)
% % pause
% 
% %% Part 2 - Find Transfer Functions
% [n, d] = ss2tf(A, B, C, D);
% % disp('The transfer function for q is')
% minreal(zpk(tf(n(3, :),d))) % q
% % disp('The transfer function for \theta is')
% minreal(zpk(tf(n(4, :),d))) % theta
% 
% %% Part 3 - Design controller
% C0 = [0 0 1 1 0];
% D0 = 0;
% 
% [num,den]=ss2tf(A,B,C0,D0);
% plant = tf(num, den);
% minreal(zpk(plant))
% 
% span=logspace(-2,2,1000);
% bode(num,den, span)
% pause
% 
% s = tf('s');
% % comp = 40 * (s+1) / (s*(s+500));
% comp = 40000 * (s+1) / (s*(s+500));
% 
% %% Part 4 - Simulink Simulation
% sim('long',20)
% 
% % subplot(3,1,1)
% plot(t,u, t,w,':', t,q,'-.')
% legend('u', 'w', 'q')
% pause
% % subplot(3,1,2)
% plot(t,h,'--')
% legend('h')
% pause
% % subplot(3,1,3)
% plot(t,theta,':', t,theta_c,'--')
% legend('\theta', '\theta_c')
% pause

%%

A = [-0.01266 -0.00588 0 -32.2; -0.10184 -0.81668 632.97 0; -3.438e-4 -0.019546 -1.4219 0; 0 0 1 0]
B = [0.01266 0.00588 0 0; 0.10184 0.81668 0 -56.828; 3.438e-4 0.01954 1.4219 -19.452; 0 0 0 0]
C = [1 0 0 0; 0 0.001577 0 0; 0 -0.818 0 0; 0 0 0 1]
D = [0 0 0 0; 0 0 0 0; 0 0 0 -56.92; 0 0 0 0]

sim('homework4', 15)
subplot(5,1,1)
plot(t,theta)
ylabel('\theta')
subplot(5,1,2)
plot(t,alpha)
ylabel('\alpha')
subplot(5,1,3)
plot(t,u)
ylabel('u')
subplot(5,1,4)
plot(t,a_z)
ylabel('a_z')
subplot(5,1,5)
plot(t,delta_e)
xlabel('Time (s)')
ylabel('\delta_e')


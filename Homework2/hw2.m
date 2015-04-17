% longitudinal
h = 20000
M = 0.638

g = 32.2
theta_0 = 0
u_0 = 660

X_u = -0.0097
X_w = 0.0016
X_d_e = 0

Z_u = -0.0955
Z_wdot = 0
Z_w = -1.43
Z_d_e = -69.8

M_u = 0
M_wdot = -0.0013
M_w = -0.0235
M_q = -1.92
M_d_e = -26.1

% Assuming this is zero
Z_q = 0

A = [[X_u, X_w, 0, -g*cos(theta_0), 0],
     [Z_u/(1-Z_wdot), Z_w/(1-Z_wdot), (Z_q + u_0)/(1-Z_wdot), -g*sin(theta_0)/(1-Z_wdot), 0],
     [M_u + (M_wdot * Z_u)/(1-Z_wdot), M_w + (M_wdot * Z_w)/(1-Z_wdot), M_q + (M_wdot*(Z_q+u_0))/(1-Z_wdot), -M_wdot*g*sin(theta_0)/(1-Z_wdot), 0],
     [0, 0, 1, 0, 0],
     [0, -1, 0, u_0, 0]]

B = [[0],
     [0],
     [0],
     [0],
     [0]]

C = [[1, 0, 0, 0, 0],
     [0, 1/u_0, 0, 0, 0],
     [0, 0, 1, 0, 0],
     [0, 0, 0, 1, 0],
     [0, 0, 0, 0, 1]]

D = [0; 0; 0; 0; 0]

[v,d]=eig(A)
i2=real(v(:,2))
i4=real(v(:,4))
initial(A,B,C,D,i2,5)
pause
initial(A,B,C,D,i4,2000)
pause

% step response
B = 5/57.3 * ...
  [[X_d_e],
   [Z_d_e/(1-Z_wdot)],
   [M_wdot*Z_d_e/(1-Z_wdot) + M_d_e],
   [0],
   [0]]

C = [[0, 0, 1, 0, 0],
     [0, 0, 0, 0, 1]]

D = [0; 0]

long = ss(A, B, C, D)
step(long, 5)
pause
step(long, 1000)
pause

% lateral
Y_v = -0.0829
Y_d_a = 0

L_p_prime = -1.70
L_r_prime = 0.172
L_d_a_prime = 27.3

N_p_prime = -0.0654
N_r_prime = -0.0893
N_d_a_prime = 0.395

Y_p = 0
Y_r = 0
L_v_prime = 0
N_v_prime = 0

A = [[Y_v, Y_p, Y_r - u_0, g * cos(theta_0), 0],
     [L_v_prime, L_p_prime, L_r_prime, 0, 0],
     [N_v_prime, N_p_prime, N_r_prime, 0, 0],
     [0, 1, tan(theta_0), 0, 0],
     [0, 0, acos(theta_0), 0, 0]]

B = [[0],
     [0],
     [0],
     [0],
     [0]]

C = [[1/u_0, 0, 0, 0, 0],
     [0, 1, 0, 0, 0],
     [0, 0, 1, 0, 0],
     [0, 0, 0, 1, 0],
     [0, 0, 0, 0, 1]]

D = [0; 0; 0; 0; 0]

[v,d]=eig(A)
i1=real(v(:,1))
i2=real(v(:,2))
% i3=real(v(:,3))
i4=real(v(:,4))
i5=real(v(:,5))
initial(A,B,C,D,i1,100)
pause
initial(A,B,C,D,i2,100 )
pause
% initial(A,B,C,D,i3,5)
% pause
initial(A,B,C,D,i4,5)
pause
initial(A,B,C,D,i5,100)

% step response
B = 5/57.3 * ...
    [[Y_d_a],
     [L_d_a_prime],
     [N_d_a_prime],
     [0],
     [0]]

C = [[0, 0, 1, 0, 0],
     [0, 0, 0, 0, 1]]

D = [0; 0]

lat = ss(A, B, C, D)
step(lat, 100)

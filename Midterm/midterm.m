%x = [ u w q theta h]
%u = [ del_e del_T u_g]
%y = [ u alpha h hdot theta ]

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

for i = 1:2

	if i == 1
		airspeed=20;
		altituderate=20;
		ugstep=0;
	elseif i == 2
		airspeed=0;
		altituderate=0;
		ugstep=-20;
	end

	time=80;
	sim('midterm',time)
	dele=dele*57.3;
	theta=theta*57.3;
	fig1 = figure(2*i - 1)
	title('Control Inputs')
	subplot(2,1,1)
	plot(t,dele)
	ylabel('$\delta_e$ (degrees)','interpreter','latex')
	% xlabel('$t$ (s)','interpreter','latex')
	xlim([0 time])
	% ylim([-1.5 2.5])
	subplot(2,1,2)
	plot(t,delT)
	ylabel('$\delta_T$ (lbf)','interpreter','latex')
	xlabel('$t$ (s)','interpreter','latex')
	xlim([0 time])
	% ylim([-8e4 8e4])
	set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
	set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
	% saveas(fig1, 'figures/inputs' + num2str(2*i - 1) + '.pdf');
	saveas(fig1, strjoin({'figures/inputs'; num2str(2*i - 1); '.pdf'}, ''));

	fig2 = figure(2*i)
	title('Response Variables')
	subplot(2,2,1)
	plot(t,theta)
	ylabel('$\theta$ (degrees)','interpreter','latex')
	% xlabel('$t$ (s)','interpreter','latex')
	xlim([0 time])
	subplot(2,2,2)
	plot(t,h) 
	ylabel('$h$ (ft)','interpreter','latex')
	% xlabel('$t$ (s)','interpreter','latex')
	xlim([0 time])
	subplot(2,2,3)
	plot(t,u-u_g,t,uc) 
	ylabel('Velocity (ft/s)','interpreter','latex')
	h = legend('$u+u_g$', '$u_c$');
	set(h,'Interpreter','latex')
	xlabel('$t$ (s)','interpreter','latex')
	xlim([0 time])
	subplot(2,2,4)
	plot(t,hdot,t,hdotc)
	ylabel('Altitude Rate (ft/s)','interpreter','latex')
	h = legend('$\dot{h}$', '$\dot{h}_c$');
	set(h,'Interpreter','latex')
	xlabel('$t$ (s)','interpreter','latex')
	xlim([0 time])
	set(gcf, 'PaperPosition', [0 0 6.8493150684931505, 4.2331095119855817]); %Position plot at left hand corner with width 5 and height 5.
	set(gcf, 'PaperSize', [6.8493150684931505, 4.2331095119855817]); %Set the paper to have width 5 and height 5.
	saveas(fig2, strjoin({'figures/outputs'; num2str(2*i); '.pdf'}, ''));
end

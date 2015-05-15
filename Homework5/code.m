function [X_dot, Y_dot] = navigation(phi, v, psi)
%#codegen

theta = 0;
U = 468.2;
V = v;
W = 0;

X_dot = U * (cos(psi) * cos(theta)) + ...
        V * (cos(psi) * sin(theta) * sin(phi) - sin(psi) * cos(phi)) + ...
        W * (cos(psi) * sin(theta) * cos(phi) + sin(psi) * sin(phi));

Y_dot = U * (sin(psi) * cos(theta)) + ...
        V * (sin(psi) * sin(theta) * sin(phi) - cos(psi) * cos(phi)) + ...
        W * (sin(psi) * sin(theta) * cos(phi) + cos(psi) * sin(phi));

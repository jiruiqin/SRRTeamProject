%Carmona-Durrleman Model
x1 = 112.22;
x2 = 103.05;
sig1 = 0.1;
sig2 = 0.15;
q1 = 0.05;
q2 = 0.05;
r = 0.05;
T = 1;
K = -20;
rho = 1;
alpha = x2 * exp(-q2 * T);
beta = sig2 * sqrt(T);
gamma = x1 * exp(-q1 * T);
delta = sig1 * sqrt(T);
kappa = K * exp(-r * T);
phi = acos(rho);
sig = sqrt(beta^2 - 2 * rho * beta * delta + delta^2);

%syms theta;
%leftSide(theta) = (log((-beta * kappa * sin(theta + phi))/(gamma * (beta * sin(theta +...
 %   phi) - delta * sin(theta)))) / delta * cos(theta)) - delta * cos(theta) / 2;
%rightSide(theta) = (log((-delta * kappa * sin(theta))/(alpha * (beta * sin(theta +...
 %   phi) - delta * sin(theta)))) / beta * cos(theta + phi)) - beta *cos(theta + phi) / 2;
%psi = acos((delta - rho * beta) / sig);
%theta = psi + pi;
%d = log(alpha * beta * sin(theta + phi)/(gamma * delta * sin(theta)))/...
%(sig * cos(theta - psi) * sqrt(T)) - (0.5 * (beta * cos(theta + phi) +...
%delta * cos(theta)) * sqrt(T));
%d1 = d + (sig2 * cos(theta + phi) * sqrt(T));
%d2 = d + (sig1 * sin(theta) * sqrt(T));
%Nd1 = normcdf(d1, 0 ,1);
%Nd2 = normcdf(d2, 0, 1);
%Nd = normcdf(d, 0, 1);
%C = alpha * Nd1 - gamma * Nd2 - k * Nd;

eqaution = @(aplha, beta, gamma, delta, kappa, phi, theta) ((log((-beta * kappa * sin(theta + phi))/(gamma * (beta * sin(theta +...
    phi) - delta * sin(theta)))) / delta * cos(theta)) - delta * cos(theta) / 2) - ((log((-delta * kappa * sin(theta))/(alpha * (beta * sin(theta +...
    phi) - delta * sin(theta)))) / beta * cos(theta + phi)) - beta *cos(theta + phi) / 2) == 0;  %the equation is this equals 0
x0 = 0;  %guess for phi
thetaSol = @(alpha, beta, gamma, delta, kappa, phi) fsolve(@(theta) equation(aplha, beta, gamma, delta, kappa, phi, theta),x0); %solves equation==0 for phi, given gamma

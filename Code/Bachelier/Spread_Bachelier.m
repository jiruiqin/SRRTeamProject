clear; clc
% The Bachelier Model

% Inputs
F1 = 103.05;                % Forward price of commodity 1
W1 = -1;                     % Weight of commodity 1
F2 = 112.22;                % Forward price of commodity 2
W2 = 1;                    % Weight of commodity 2
K = [-20,-10,0,5,15,25];                      % Strike
T = 1;                      % Time to Expiry    
V1 = 0.15;                  % Black-Implied Vol for Asset 1
V2 = 0.10;                  % Black-Implied Vol for Asset 2
C12 = [-1,-0.5,0,0.3,0.8,1];                  % Correlation between the two assets
Rf = 0.05;                  % Risk-free rate

n = length(K);
% Function m(T)
m = (F2-F1)*exp(-Rf*T);
% Function s(T)^2
s_squared = zeros(1,n);
p = zeros(n,n);
for i = 1:n
    for j = 1:n
        s_squared(j) = exp(2*(-Rf)*T)*(F1^2*(exp(V1^2*T)-1)-2*F1*F2*(exp(C12(j)*V1*V2*T)-1)...
    +F2^2*(exp(V2^2*T)-1));    
t = timer('StartFcn',@(~,~)disp('timer started.'),'TimerFcn',@(~,~)disp(rand(1)));
start(t);
% Approximation price
p(i,j) = (m-K(i)*exp(-Rf*T))*normcdf((m-K(i)*exp(-Rf*T))/sqrt(s_squared(j)))...
    +sqrt(s_squared(j))*normpdf((m-K(i)*exp(-Rf*T))/sqrt(s_squared(j)));
    delete(t);
    end
end
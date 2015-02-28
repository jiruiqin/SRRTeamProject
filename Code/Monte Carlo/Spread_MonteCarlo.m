clear; clc

% input = xlsread('returns.xls');

% Testing spread option for pay of Max(F2-F1-K,0)
% F1 = 1.7;               % Forward price of commodity 1
% W1 = -1;                 % Weight of commodity 1
% F2 = 48.74;                % Forward price of commodity 2
% W2 = 1;                % Weight of commodity 2
% K = 47;                 % Strike
% T = 0.0754;                % Time to Expiry    
% V1 = 0.26261763;              % Black-Implied Vol for Asset 1
% V2 = 0.22387647;              % Black-Implied Vol for Asset 2
% C12 = 0.8547;              % Correlation between the two assets
% Rf = 0.015;              % Risk-free rate
% NumSim = 100000;         % Number of simulation paths

% Another test
F1 = 103.05;               % Forward price of commodity 1
W1 = -1;                 % Weight of commodity 1
F2 = 112.22;                % Forward price of commodity 2
W2 = 1;                % Weight of commodity 2
K = [-20,-10,0,5,15,25];                 % Strike
T = 1;                % Time to Expiry    
V1 = 0.15;              % Black-Implied Vol for Asset 1
V2 = 0.1;              % Black-Implied Vol for Asset 2
C12 = [-1,-0.5,0,0.3,0.8,1];              % Correlation between the two assets
Rf = 0.05;              % Risk-free rate
NumSim = 1000000;         % Number of simulation paths

% Generate two independent random numbers with N(0,1)
x = randn(NumSim,2);
F_T = zeros(NumSim,2);
y2 = zeros(NumSim,1);
n = length(K);
m = length(C12);
% payoff = zeros(NumSim,1);
% Generate two correlated random numbers with correlation C12
y1 = x(:,1);

for i = 1:n
    for j = 1:m
%     tic;
    F_T = zeros(NumSim,2);
    y2 = zeros(NumSim,1);
    y2 = C12(j)*x(:,1)+sqrt(1-C12(j)^2)*x(:,2);
    
% End prices
    F_T(:,1) = F1*exp((Rf-V1^2/2)*T+V1*y1);
    F_T(:,2) = F2*exp((Rf-V2^2/2)*T+V2*y2);
    % Calculate payoff
    payoff = max(W1*F_T(:,1)+W2*F_T(:,2)-K(i),0);
    SOPT(i,j) = mean(exp(-Rf*T)*payoff);
%     toc;
    end
end









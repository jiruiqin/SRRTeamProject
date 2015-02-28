clear;
F1_t = 103.05;  % Futures price of asset 1
F2_t = 112.22;  % Futures price of asset 2
corr = [-1 -0.5 0 0.3 0.8 1];   % Correlation between the two assets
sig1 = 0.15;    % Black-Implied Vol for asset 1
sig2 = 0.1; % Black-Implied Vol for asset 2
strike = [-20; -10; 0; 5; 15; 25]; % Strike price
div1 = 0;   % Dividend rate for asset 1
div2 = 0;   % Dividend rate for asset 2
rf = 0.05; % Risk-free rate
expiry = 1; % Time to maturity

PearsonResults = zeros(6,6);
for i = 1:6
    for j = 1:6
        % Start timer
        t = timer('StartFcn',@(~,~)disp('timer started.'),'TimerFcn',@(~,~)disp(rand(1)));
        start(t);
        % Calculate integral value
        int_result = integral(@(x)PIntegral(x, F1_t, F2_t, corr(j), sig1, sig2, strike(i), div1, div2, rf, expiry), 0, inf);
        % End timer
        delete(t);
        % Price of spread option using Pearson integration equation
        PearsonResults(i,j) = exp(-rf*expiry)*int_result;
    end
end

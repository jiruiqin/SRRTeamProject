% Pearson Linear approximation code used to optimize k and n constant
% values
clear;

% Results of the prices given correlation and strike prices derived from Monte Carlo Simulations 
MonteCarloSimulationResults = ... 
[30.3591234681517,	29.6333173744459,	28.9457991591494,	28.5900186947773,	28.2274700828567,	28.2021675355553;
22.6298253740727,	21.6025323081873,	20.5110970498238,	19.8397699521359,	18.8558406046284,	18.6927794520144;
15.9207608300292,	14.6444376407102,	13.1749176272476,	12.1613161330879,	10.1287946017418,	9.27361378509412;
13.0239306664996,	11.6710728113425,	10.0829253027528,	8.95211399613997,	6.44375174997857,	4.88753058589008;
8.23474707125884,	6.87033224408136,	5.27940448041638,	4.14575396006563,	1.62318067816189,	0.104699801557962;
4.78039602975345,	3.60994659399421,	2.32477154911141,	1.49279132259586,	0.159995897441164,	0];

F1_t = 103.05; % Futures price of asset 1
F2_t = 112.22; % Futures price of asset 2
corr = [-1 -0.5 0 0.3 0.8 1]; % Correlation between the two assets
sig1 = 0.15; % Black-Implied Vol for asset 1
sig2 = 0.1;% Black-Implied Vol for asset 2
strike = [-20; -10; 0; 5; 15; 25]; % Strike price
div1 = 0;   % Dividend rate for asset 1
div2 = 0;   % Dividend rate for asset 2
rf = 0.05; % Risk-free rate
expiry = 1; % Time to maturity
PearsonApproxResults = zeros(6,6); 
n_const = [32]; % list of n values to test 
n_const_size = length(n_const); % size of n values
k_const = [1.04]; % list of k value to test
k_const_size = length(k_const); % size of k values
errorResults = zeros(n_const_size, k_const_size);

for nv = 1 : n_const_size
    for kv = 1 : k_const_size
        % Evaluate constant values
        h = k_const(kv) * sig1 * sqrt(expiry) / (sqrt(n_const(nv)));
        e_m1 = F1_t * exp((rf - div1 - sig1 ^ 2 / 2) * expiry);
        slopes = zeros(1, 2 * n_const(nv));
        spotPrices = zeros(1, 2 * n_const(nv)+1);
        forwardPayoffs = zeros(1, 2 * n_const(nv)+1);

        for str = 1:6
            for cor = 1:6
                % Divide the area under the curve by increments and
                % calculate the predicted forward payoff values given the spot
                % prices
                for i = 0 : n_const(nv) * 2
                    if i < n_const(nv) 
                        spotPrices(i+1) = e_m1 / exp((n_const(nv) - i) * h);
                        forwardPayoffs(i+1) = FindForwardPayoff(spotPrices(i+1), F1_t, F2_t, corr(cor), sig1, sig2, strike(str), div1, div2, rf, expiry);
                    elseif i == n_const(nv) 
                        spotPrices(i+1) = e_m1 ;
                        forwardPayoffs(i+1) = FindForwardPayoff(spotPrices(i+1), F1_t, F2_t, corr(cor), sig1, sig2, strike(str), div1, div2, rf, expiry);
                    else
                        spotPrices(i+1) = e_m1 * exp((i - n_const(nv)) * h);
                        forwardPayoffs(i+1) = FindForwardPayoff(spotPrices(i+1), F1_t, F2_t, corr(cor), sig1, sig2, strike(str), div1, div2, rf, expiry);
                    end
                end 
                
                % Find the slope of the line between the forward payoffs   
                for i = 0 : n_const(nv) * 2-1
                    slopes(i+1) = (forwardPayoffs(i+2)-forwardPayoffs(i+1)) / (spotPrices(i+2)-spotPrices(i+1));
                end

                c_sum = 0;
                p_sum = 0;
                
                % Summation values used to calculate the call option price
                for k = 1 : n_const(nv) - 1
                    delta_j = slopes(1 + n_const(nv) + k);
                    delta_jsub1 = slopes(1 + n_const(nv) + k - 1);
                    delta_negjsub1 = slopes(1 + n_const(nv) - k - 1);
                    delta_negj = slopes(1 + n_const(nv) - k);
                    c_sum = c_sum + Getc(e_m1 * exp(k * h), F1_t, rf, div1, sig1, expiry) * (delta_j - delta_jsub1);
                    p_sum = p_sum + Getp(e_m1 / exp(k * h), F1_t, rf, div1, sig1, expiry) * (delta_negjsub1 - delta_negj);
                end
                % Find the call option price
                PearsonApproxResults(str, cor) = exp(-rf * expiry) * FindForwardPayoff(e_m1, F1_t, F2_t, corr(cor), sig1, sig2, strike(str), div1, div2, rf, expiry) + ...
                    Getc(e_m1, F1_t, rf, div1, sig1, expiry) * slopes(n_const(nv) + 1) + c_sum - ...
                    Getc(e_m1 * exp(n_const(nv) * h), F1_t, rf, div1, sig1, expiry) * slopes(n_const(nv) * 2) - ...
                    Getp(e_m1, F1_t, rf, div1, sig1, expiry) * slopes(n_const(nv)) - p_sum + ...
                    Getp(e_m1 / exp(n_const(nv) * h), F1_t, rf, div1, sig1, expiry) * slopes(1);
            end
        end
        % Find the sum of the square errors 
        errors = (PearsonApproxResults - MonteCarloSimulationResults);
        squares = sum(sum(errors .* errors));
        errorResults(nv, kv) = squares;
    end
end
% Generate surface graph of error values
surf(strike, corr, errors);

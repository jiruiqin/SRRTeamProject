clear;


Price1 = 112.22;    % $/barrel
Vol1 = 0.1;
Div1 = 0;

% Price, volatility, and dividend of WTI crude oil
Price2 = 103.05;     % $/barrel
Vol2 = 0.15;
Div2 = 0;

% Correlation of underlying prices
Corr = [-1 -0.5 0 0.3 0.8 1];
% Strike
Strike = [-20 -10 0 5 15 25];
KirkResults = zeros(6,6);
BJSResults = zeros(6,6);

for i = 1:6
    for j = 1:6
        % Option type
        OptSpec = 'call';

        % Settlement date
        Settle = '01-Jan-2013';

        % Maturity
        Maturity = '01-Jan-2014';

        % Risk free rate
        RiskFreeRate = 0.05;

        % Define RateSpec
        RateSpec = intenvset('ValuationDate', Settle, 'StartDates', Settle, ...
            'EndDates', Maturity, 'Rates', RiskFreeRate);

        % Define StockSpec for the two assets
        StockSpec1 = stockspec(Vol1, Price1, 'Continuous', Div1);
        StockSpec2 = stockspec(Vol2, Price2, 'Continuous', Div2);

        % Specify price and sensitivity outputs
        OutSpec = {'Price', 'Delta', 'Gamma'};

        % Kirk's approximation
        [PriceKirk, DeltaKirk, GammaKirk] = ...
            spreadsensbykirk(RateSpec, StockSpec1, StockSpec2, Settle, ...
            Maturity, OptSpec, Strike(i), Corr(j), 'OutSpec', OutSpec)
        % Bjerksund and Stensland model
        [PriceBJS, DeltaBJS, GammaBJS] = ...
            spreadsensbybjs(RateSpec, StockSpec1, StockSpec2, Settle, ...
            Maturity, OptSpec, Strike(i), Corr(j), 'OutSpec', OutSpec)
        KirkResults(i,j)=PriceKirk;
        BJSResults(i,j)=PriceBJS;
    end
end
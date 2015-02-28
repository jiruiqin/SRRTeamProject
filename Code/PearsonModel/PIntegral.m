% Find the integral of the Forward payoff multiplied by the forward payoff
% density value
function d = PIntegral(x, S1_t, S2_t, corr, sig1, sig2, strike, div1, div2, rf, expiry)
d = FindForwardPayoff(x, S1_t, S2_t, corr, sig1, sig2, strike, div1, div2, rf, expiry) .* FindPayoffDensity(x,S1_t,sig1,div1,rf,expiry);
end
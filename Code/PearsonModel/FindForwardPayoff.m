
function y =FindForwardPayoff(x, S1_t, S2_t, corr, sig1, sig2, strike, div1, div2, rf, expiry)

sig = sqrt(sig2 ^ 2 * (1 - corr ^ 2) * expiry);
m2 = log(S2_t) + (rf - div2 - sig2 ^ 2 / 2) * expiry;
m1 = log(S1_t) + (rf - div1 - sig1 ^ 2 / 2) * expiry;
A = (rf * (1 - corr * sig2 / sig1) - (div2 - div1 * corr * sig2 / sig1) + corr * sig2 * (sig1 - corr * sig2) / 2) * expiry;
    
y=exp(A) .* S2_t .* (x ./ S1_t).^ (corr .* sig2 ./ sig1) .* normcdf(((m2 + (corr .* sig2) .* (log(x) - m1) ./ sig1 + sig .^ 2) - log(max(x+strike,0))) ./ sig) - (x + strike) .* normcdf((m2 + (corr .* sig2) .* (log(x) - m1) ./ sig1 - log(max(x+strike,0))) ./ sig);
end
%Returns value for the call option given the known parameters
function y = Getc(price, F1_t, rf, div1, sig1, expiry)
    d1 = (log(F1_t / price) + (rf - div1 + sig1 ^ 2 / 2) * expiry) / (sig1 * sqrt(expiry));
    d2 = (log(F1_t / price) + (rf - div1 - sig1 ^ 2 / 2) * expiry) / (sig1 * sqrt(expiry));
    y = exp(-div1 * expiry) * F1_t * normcdf(d1) - price * exp(-rf * expiry) * normcdf(d2);
end
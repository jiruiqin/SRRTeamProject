% Function to find futures payoff density
function p = FindPayoffDensity(x,F1_t,sig1,div1,rf,expiry) 
m1 = log(F1_t) + (rf - div1 - sig1 ^ 2 / 2) * expiry;
p = exp(-((log(x) - m1) .^ 2) ./ (2 .* sig1 .^ 2 .* expiry)) ./ (sqrt(2 .* pi) .* sig1 .* sqrt(expiry) .* x);
end

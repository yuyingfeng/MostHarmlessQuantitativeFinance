function payoff = straddle_payoff(S,K)
payoff = european_opt_payoff('c',S, K)+...
    european_opt_payoff('p',S, K);
end

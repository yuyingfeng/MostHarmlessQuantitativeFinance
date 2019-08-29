function payoff = riskreversal_payoff(S,K1,K2)
payoff = european_opt_payoff('c',S, K2)-...
    european_opt_payoff('p',S, K1);
end

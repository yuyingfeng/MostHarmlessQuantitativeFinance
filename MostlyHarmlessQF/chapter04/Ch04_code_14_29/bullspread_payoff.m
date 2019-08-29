function payoff = bullspread_payoff(S,K1,K2)
typ='c';
payoff = european_opt_payoff(typ,S, K1)+...
    -european_opt_payoff(typ,S, K2);
end

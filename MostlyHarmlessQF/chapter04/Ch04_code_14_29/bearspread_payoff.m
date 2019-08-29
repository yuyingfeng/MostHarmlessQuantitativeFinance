function payoff = bearspread_payoff(S,K1,K2)
typ='p';
payoff = european_opt_payoff(typ,S, K2)+...
    -european_opt_payoff(typ,S, K1);
end

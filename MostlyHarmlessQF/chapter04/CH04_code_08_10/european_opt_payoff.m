function payoff = european_opt_payoff(typ,S, K)
%typ ="type" when "c"=call, "p=put"
    if typ=='c'
        payoff=(abs(S-K)+(S-K))/2;
    else
        payoff=(abs(K-S)+(K-S))/2;
    end
end

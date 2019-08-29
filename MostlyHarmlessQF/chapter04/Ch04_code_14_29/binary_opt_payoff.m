function payoff = binary_opt_payoff(typ,S, K, B )
%typ ="type" when "c"=call, "p=put"
    if typ=='c'
        payoff=B*(S>K);
    else
        payoff=B*(S<K);
    end
end

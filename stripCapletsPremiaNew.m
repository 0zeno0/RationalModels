function capletPremia = stripCapletsPremiaNew(numCaplets,strike,relevantDiscounts,relevantFwds,a_capMaturity,volaCap)

capletPremia = zeros(1,numCaplets);
delta = 0.25;

for j = 1: numCaplets
    
    knotTimes = (3:3:a_capMaturity*12)/12;
    result = 0
    for i = 1:length(knotTimes)
        fwd = relevantFwds(i);
        disc = relevantDiscounts(i);
        T = knotTimes(i);
        result = result + priceCaplet(volaCap,fwd,strike,T,0,delta,disc)
    end
    capletPremia(j) = result;
end

end


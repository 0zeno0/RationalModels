

function vol = impliedNormalVolatilityFzero(discount,strikeVec,maturity,capletPrices,delta)
T = maturity;
fwdRate = -0.3017/100;
t = 0;
len = length(strikeVec);
if len>1
for j = 1:len %implied vol per ogni singolo strike
    a_capletPrice = capletPrices(j);
    k = strikeVec(j);
    x0 = 0.004;
    vol(j) = fzero(@(param) (priceCaplet(param,fwdRate,k,T,t,delta,discount)-a_capletPrice),x0);  
end
else
    a_capletPrice = capletPrices
    k = strikeVec;
    x0 = 0.008;
    vol = fzero(@(param) (priceCaplet(param,fwdRate,k,T,t,delta,discount)-a_capletPrice),x0);
end

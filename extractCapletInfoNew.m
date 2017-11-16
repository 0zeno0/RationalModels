%The outputs are two Matrixes, one for the premia and one for the
%volatilities. Caplet Maturities on the rows and strikes on the columns.

function [capletPrices, volaCaplets] = extractCapletInfoNew(forwardVec,discountVec,deltaVec,strikeVec,capVolatilities,capMaturities)
len_strikes = length(strikeVec);
capAtmVola = capVolatilities(:,1);
lastMaturity = capMaturities(length(capMaturities));
timeVec = 1:4*lastMaturity;
len_Times = length(timeVec);
volaCaplets = zeros(len_Times,len_strikes);
capletPrices = zeros(len_Times,len_strikes);

for i = 1: len_strikes
   
    k = strikeVec(i);

for j = 1: len_Times
relevantCapIndex = 1;  
  if (sum(capMaturities == j/4)) %to consider not equally distant maturities--sum a boolean vec
      relevantCapIndex = relevantCapIndex + 1;
  end

nextCapVola = capAtmVola(relevantCapIndex);
discount = discountVec(j); %payment at T+1
fwdRate = forwardVec(j+1); %fwd [T,T+1]
delta = deltaVec(j+1);
maturity = timeVec(j)*3/12; 
if (j <= 4)
    volaCaplets(j,i) = nextCapVola;  
    capletPrices(j,i) = priceCaplet(nextCapVola,fwdRate,k,maturity,0,delta,discount);
else
  
    capMaturity = capMaturities(relevantCapIndex);
    relevantDiscounts = discountVec(1:j);
    relevantFwds = forwardVec(2:(j+1)); %recall the fwd is [T, T+1]
    capletsUpToNow = stripCapletsPremiaNew(j,k,relevantDiscounts,relevantFwds,capMaturity,nextCapVola);
    currentCapPrice = sum(capletsUpToNow);
    oldCapletsPrices = sum(capletPrices(:,i));
    diffCapletPrice = currentCapPrice - oldCapletsPrices;
    capletPrices(j,i) = diffCapletPrice
    volaCaplets(j,i) = impliedNormalVolatilityFzero(discount,k,maturity,diffCapletPrice,delta)    
end  
end
end
end




function modelprice = computeCapletPriceOneFactor(param,Pd0v,L0Theta,strikeVec,Tswpn,delta)
N =100;
w = 1;
a1 = param(1);
b1Theta = param(2);
b0v = param(3);
len = length(strikeVec);
for i = 1:len
K = strikeVec(i)
x1 = w *(b1Theta - K*b0v);
x2 = 0;
x0 = w * (L0Theta - K*Pd0v - x1 - x2);
if (x0 >=0)
    modelprice(i,1) = N*(x0+x1) %avoid problems with the logarithm
else
    
    q1 = (0.5*a1^2*Tswpn-log(-x0/x1))/(a1*sqrt(Tswpn))
    q2 = (-0.5*a1^2*Tswpn-log(-x0/x1))/(a1*sqrt(Tswpn))
    modelprice(i,1) = (x1*normcdf(q1)+x0*normcdf(q2))*N
    
end
end
end
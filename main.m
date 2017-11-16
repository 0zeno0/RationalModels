%%%%%%%%%% DATA LOADING %%%%%%%%%%%%%%%%%%%%%
discountVec = xlsread('data','3m','D2:D123');
forwardVec = xlsread('data','3m','E2:E1223');
deltaVec = xlsread('data','3m','A2:A123');
capVolatilities = xlsread('vcube_VolCap_v1','3M','C11:N25')/10000;
capMaturities = xlsread('vcube_VolCap_v1','3M','B11:B25');
spreadOverATM = xlsread('vcube_VolCap_v1','3M','D9:N9');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

capAtmVola = capVolatilities(:,1);
lastMaturity = capMaturities(length(capMaturities));
timeVec = 1:4*lastMaturity;
len_Times = length(timeVec);
strikeATM = -0.3017/100;
strikeVec = strikeATM + [0 spreadOverATM];
len_strikes = length(strikeVec);
capPrices = zeros(length(capMaturities),1);

%%% CAPLET STRIPPING %%%
[capletPremia, capletVola] = extractCapletInfoNew(forwardVec,discountVec,deltaVec,strikeVec,capVolatilities,capMaturities)

%%%% TO ADD: plot

%capletPremia and capletVola are two matrixes
%num_rows = matuirities & num_columns = strikes
%Therefore:
%Smile on the rows 
%Termstructure on the columns

%%%SMILE CALIBRATION -> Fix row + move buy columns
row = 1 % consider the first caplet maturity that is 0.25 years
smileParameters = zeros(len_Times,3);


for col = 1: len_strikes
    volVecSmile = capVolatilities(row,:);
    capletSmilePremia = capletPremia(row,:);
    maturity = timeVec(row)*3/12;
    discount = discountVec(row);
    fwdRate = discountVec(row+1);
    delta = deltaVec(row);
  
%CALIBRATION
options = optimoptions('fmincon');
options = optimoptions(options,'Algorithm', 'interior-point');
options = optimoptions(options,'Display', 'iter')
options = optimoptions(options,'MaxIter', 100000);
options = optimoptions(options,'PlotFcns', { @optimplotfval });
 
x0 = [0.01 0.1 0.05];
[output,resnorm,residual,exitflag,out] = lsqnonlin( @(param) capletSmilePremia' -...
computeCapletPriceOneFactor(param,discount,fwdRate,strikeVec,maturity,delta),x0,[0.005 0.05 0.01],[0.1 0.2 0.1],options)      
smileParameters(row,:)= param;

end



load Dataset_ETF_14_Feb05_Dec10.mat;

% IJR IJH	IJR	IYY	
[n, p] = size(SPY_dat);
SPY_dat.Prev_Adj_Close = [SPY_dat.Adj_Close(2:n);NaN];
SPY_dat.Rate = 100*(SPY_dat.Adj_Close - SPY_dat.Prev_Adj_Close)./SPY_dat.Prev_Adj_Close;

IJH_dat.Prev_Adj_Close = [IJH_dat.Adj_Close(2:n);NaN];
IJH_dat.Rate = 100*(IJH_dat.Adj_Close - IJH_dat.Prev_Adj_Close)./IJH_dat.Prev_Adj_Close;

IJR_dat.Prev_Adj_Close = [IJR_dat.Adj_Close(2:n);NaN];
IJR_dat.Rate = 100*(IJR_dat.Adj_Close - IJR_dat.Prev_Adj_Close)./IJR_dat.Prev_Adj_Close;

IYY_dat.Prev_Adj_Close = [IYY_dat.Adj_Close(2:n);NaN];
IYY_dat.Rate = 100*(IYY_dat.Adj_Close - IYY_dat.Prev_Adj_Close)./IYY_dat.Prev_Adj_Close;

% XLE	EWZ	EWJ	EWH	

% EEM	EZU	EFA	AGG	

% IAU	IYR



function Backtest()
    % Test the predictive power of the min-variance allocation
    % strategy. The parameter of this function is 
    % 1) The investment amount (i.e. the budbet B) 
    % 2) the minimum expected rate of return (r_min).
    % 3) k number of days used to estimate p_mean and sig 

    % Here the return/profit is not added to the capital (B). 
    % I.e. The combine B + return amount will NOT rollover to the next day 
    % I.e. We assume the investor invest the same capital B every day
    % The return of each day will be plotted vs. the time horizon

    load ROR14_Feb05_Dec10;  
    dayRateMat = ETF14.RateMat(2:end,:); 
    
    cvx_quiet(true);

    B = 10000;      % Budget (i.e. total investment amount)
    r_min = 0.02;   % Minimum expected return rate in percentage     
    k = 1000;       % end_index of the training set
    k2 = 1;         % begn index of the test set            

    B = input('Enter the budget (investment amount): '); 
    r_min = input('Enter Minimum expected return rate: '); 
    k  = input('Enter number of trading days from the begin of the dataset: '); 
    
    % A struct to store back test result
    BACK_TEST.budget = B;
    BACK_TEST.r_min = r_min;
    BACK_TEST.n_train_days = k;
    
    % n - number of assets in the portfolio
    % nrows - number of historical trading days in the dataset
    [nrows, n] = size(dayRateMat);

    % Actual return amount stored here
    R = zeros(nrows - k, n+3);

    while  k < nrows
        % get training data from dayRateMat matrix
        train_mat = dayRateMat(1:k,:);
        
        % mean/expected price change  
        p_mean = mean(train_mat)';

        % covariance nmatrix of the price change random vector
        sig = cov(dayRateMat);

        cvx_begin        
            variable x1(n) % x1 fractional of portfolio, the optimization variable 
            minimize (quad_form(x1,sig)) %minimize the return variance x'*sig*x
            dot(p_mean,x1) >= r_min;     % subject to minimum E(r) is 0.2% constraint
            ones(1,n)*x1 ==1;            % must use all 100% investment budget 
            x1 >= 0;                     % no short position
        cvx_end

        assert(sum(isnan(x1)) == 0, 'Error. Can not allocate portfolio for day %d with minimum expected return %f \n', k, r_min);
        
        % X exact amount of portfolo = fractional * Budget
        X = x1.*B;
        
        pre_price = get_price(ETF14, n, k);
        qty = X./pre_price;
        market_price = get_price(ETF14, n, k+1);
        
        % total amount in cash after selling the portfolio
        % i.e. the actual market value of the portfolio at the end of the
        % trading day
        Y = qty.*market_price;
        
        % Actual return
        ret = Y - X;
        R(k2,1:14) = ret';
        R(k2,15) = sum(ret);    % total return of the portfolio for day k
        R(k2,16) = dot(X,p_mean); % ESTIMATED return 
        R(k2,17) = sqrt(X'*sig*X);    % ESTIMATED std 
        
        k = k + 1;
        k2 = k2+1;        
    end
    
    R = dataset({R, 'SPY', 'IJH','IJR','IYY','XLE', 'EWZ','EWJ','EWH',...
    'EEM','EZU','EFA','AGG','IAU','IYR', 'TOTAL', 'ESTIMATED', 'STD'});
    
    BACK_TEST.Result = R;  %#ok<STRNU>
    
    fprintf('Daily return for each day \n');
    disp(R);

    y  = R.TOTAL;    
    fprintf('The total return in %d days is %10.4f \n', size(y,1), sum(y));
    
    x = 1:size(y,1);
    plot(x,y);
    
    save('BACK_TEST_RESULT1','-v7.3','BACK_TEST'); 
    
end

function price = get_price(ETF14 ,n, idx)
    price = zeros(n,1);
    price(1) = ETF14.SPY.Adj_Close(idx);
    price(2) = ETF14.IJH.Adj_Close(idx);
    price(3) = ETF14.IJR.Adj_Close(idx);
    price(4) = ETF14.IYY.Adj_Close(idx);
    price(5) = ETF14.XLE.Adj_Close(idx);
    price(6) = ETF14.EWZ.Adj_Close(idx);
    price(7) = ETF14.EWJ.Adj_Close(idx);
    price(8) = ETF14.EWH.Adj_Close(idx);
    price(9) = ETF14.EEM.Adj_Close(idx);
    price(10) = ETF14.EZU.Adj_Close(idx);
    price(11) = ETF14.EFA.Adj_Close(idx);
    price(12) = ETF14.AGG.Adj_Close(idx);
    price(13) = ETF14.IAU.Adj_Close(idx);
    price(14) = ETF14.IYR.Adj_Close(idx);
end

function Price = RandPrice( Price0,avg_r,sigma,N )
    Rate=normrnd(avg_r,sigma,N,1);
    Price=Price0*cumprod(Rate+1);
end
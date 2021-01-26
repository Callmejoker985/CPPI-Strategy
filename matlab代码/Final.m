%function [A,SumTradeFee,portFreez] = Final()

%设置参数：
    
    PortValue=100;
    TradeDayLong=250;
    TradeDayofYear=250;
    RisklessReturn=0.03;
    TradeFee=0.00025;
    price_now=330;
    price_last=129;
    sigma=0.0244;
%adjustCycle=1，5，10，20;
%Riskmulti=2，3，4，5，6;
%GuarantRatio=1.0，0.9;

    Mean=(price_now/price_last)^(1/TradeDayofYear)-1;
    Std=sigma/sqrt(TradeDayofYear);
    Price0=price_now;
    %Mean=1.2^(1/TradeDayofYear)-1;
    %Std=0.40/sqrt(TradeDayofYear);
    %Price0=100;
    Sdata=RandPrice(Price0,Mean,Std,TradeDayofYear);
    Sdata=[Price0;Sdata];
    a = [1 5 10 20];
    b = [2 3 4 5 6];
    c = [1.0 0.9];
    fid1 = fopen('C:\Users\PC\Desktop\于汇洋2018150801020第三次实验（cppi）\Result.txt','wt');
    fid2 = fopen('C:\Users\PC\Desktop\于汇洋2018150801020第三次实验（cppi）\Resulttoexcel.txt','wt');
    for o = 1:length(a)
        for p = 1:length(b)
            for q = 1:length(c)
                adjustCycle=a(o);
                Riskmulti=b(p);
                GuarantRatio=c(q);    
                A0 = 0;
                Alist = [];
                SumTradeFee0 = 0;
                portFreez0 = 0;
                for i = 1:1000
                    [A,SumTradeFee,portFreez] = CPPIStr( PortValue,Riskmulti,GuarantRatio,TradeDayLong,TradeDayofYear,adjustCycle,RisklessReturn,TradeFee,Sdata);
                    A0 = A0 + A(:,end);
                    %fprintf('AdjustCycle = %f:\n',A(:,end));
                    SumTradeFee0 = SumTradeFee0 + SumTradeFee;
                    portFreez0 = portFreez0 + portFreez;
                    Alist = [Alist,A0];
                    Alist_Ln = log(Alist);
                    A_r = diff(Alist_Ln);
                end
                Amean = A0 / 1000;
                Ratio_Cls = portFreez0 / 1000;
                Tradefeemean = SumTradeFee0 / 1000;
                sigma = std(A_r,1);
                standard = mean(A_r) / sigma;
                fprintf(fid1,'AdjustCycle = %d\tRiskmulti = %d\tGuarantRatio = %d\n',adjustCycle,Riskmulti,GuarantRatio);
                fprintf(fid1,'Amean = %d:\tRatio_Cls = %f:\tTradefeemean = %f:\tsigma = %f:standard:%f\n',Amean,Ratio_Cls,Tradefeemean,sigma,standard);
                fprintf(fid2,'%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f\n',adjustCycle,Riskmulti,GuarantRatio,Amean,Ratio_Cls,Tradefeemean,sigma,standard);
            end
        end
    end
    fclose(fid1);
    fclose(fid2);
    headers = {'adjustCycle','Riskmulti','GuarantRatio','Amean','Ratio_Cls','Tradefeemean','sigma','standard'};
    data = load('C:\Users\PC\Desktop\于汇洋2018150801020第三次实验（cppi）\Resulttoexcel.txt');
    xlswrite('C:\Users\PC\Desktop\于汇洋2018150801020第三次实验（cppi）\Result_headers.xls',headers);
    xlswrite('C:\Users\PC\Desktop\于汇洋2018150801020第三次实验（cppi）\Result_headers.xls',data,'A2:H41');

function [A,SumTradeFee,portFreez] = CPPIStr( PortValue,Riskmulti,GuarantRatio,TradeDayLong,TradeDayofYear,adjustCycle,RisklessReturn,TradeFee,Sdata,price_last,price_now,sigma)
    SumTradeFee=0;
    F=zeros(1,TradeDayLong+1);
    E=zeros(1,TradeDayLong+1);
    A=zeros(1,TradeDayLong+1);
    G=zeros(1,TradeDayLong+1);
    A(1)=PortValue;
    F(1)=GuarantRatio*PortValue*exp(-RisklessReturn*TradeDayLong/TradeDayofYear);
    E(1)=max(0,Riskmulti*(A(1)-F(1)));
    G(1)=A(1)-E(1);
    portFreez=0;
    for i=2:TradeDayLong+1
       E(i)=E(i-1)*(1+(Sdata(i)-Sdata(i-1))/(Sdata(i-1)));
       G(i)=G(i-1)*(1+RisklessReturn/TradeDayofYear);
       A(i)=E(i)+G(i);
       F(i)=GuarantRatio*PortValue*exp(-RisklessReturn*(TradeDayLong-i+1)/TradeDayofYear);
        if mod(i-1,adjustCycle)==0
           temp=E(i);
            E(i)=max(0,Riskmulti*(A(i)-F(i)));
            SumTradeFee=SumTradeFee+TradeFee*abs(E(i)-temp);
            G(i)=A(i)-E(i)-TradeFee*abs(E(i)-temp);
        end
        if E(i)==0
            A(i)=G(i);
            portFreez=1;
        end
    end
end
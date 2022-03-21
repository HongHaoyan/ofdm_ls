clear all
tu=128e-6;
tg=16e-6;
ts=tu+tg;
fd=132;
Dt_max=fix(1/(2*fd*ts));
for n=1:Dt_max
    SIR(n)=(1/2)*(1-sin(2*pi*fd*n*ts)/(2*pi*fd*n*ts))^(-1);
end
SIR_db=10*log10(SIR);
n=1:Dt_max;
Lp_Ld=1./n;

plot(n,SIR_db,'*')

%M=4;%16QAM调制方式时，调制进制数为4
%for i=1:Dt_max
     %bit_err_rate(i)=(1-(1+M*(1-sin(2*pi*fd*i*ts)/(2*pi*fd*i*ts)))^(-1/2))/2;
     %fd_t(i)=fd*i*ts;
     %end

%subplot(2,1,2)
%plot(n,Lp_Ld,'*')


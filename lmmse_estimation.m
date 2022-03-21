function output=lmmse_estimation(input,pilot_inter,pilot_sequence,pilot_num,trms,t_max,snr);
%trms为多经信道的平均延时，t_max为最大延时,此处所有的时间都是已经对采样间隔做了归一化后的结果
beta=17/9;
[N,NL]=size(input);
Rhh=zeros(N,N);
for k=1:N
    for l=1:N
        Rhh(k,l)=(1-exp((-1)*t_max*((1/trms)+j*2*pi*(k-l)/N)))./(trms*(1-exp((-1)*t_max/trms))*((1/trms)+j*2*pi*(k-l)/N));
    end
end
output=zeros(N,NL-pilot_num);
i=1;
count=0;
while i<=NL
    Hi=input(:,i)./pilot_sequence;
    Hlmmse=Rhh*inv(Rhh+(beta/snr)*eye(N))*Hi;
    count=count+1;
    if  count*pilot_inter<=(NL-pilot_num)
        for a=((count-1)*pilot_inter+1):count*pilot_inter
            output(:,a)=input(:,(i+a-(count-1)*pilot_inter))./Hlmmse;
        end
    else
        for a=((count-1)*pilot_inter+1):(NL-pilot_num)
            output(:,a)=input(:,(i+a-(count-1)*pilot_inter))./Hlmmse;
        end
    end
    i=i+pilot_inter+1;
  end
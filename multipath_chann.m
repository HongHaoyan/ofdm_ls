function output_sig=multipath_chann(input_sig,num,var_pow,delay,fd,t_interval,counter,count_begin)
%input_sig输入信号矩阵,加了cp后的信号，大小为NL×(子载波个数+cp长度lp)；
%num多径数;
%var_pow各径相对主径的平均功率,单位dB；
%delay各径延时,单位s；
%fd最大dopple频率；
%t_interval为离散信道抽样时间间隔，等于OFDM符号长度/(子载波个数+cp长度lp)；
%output_sig为经过多径信道的输出信号矢量
%counter各径间隔记录
%count_begin本次产生信道开始记录的初始位置

t_shift=floor(delay/t_interval);%归一化各径延时
%theta_shift=2*pi*fc*delay;
[nl,l]=size(input_sig);
output_sig=zeros(size(input_sig));

chann_l=nl*l;%信道采样点数，若一个调制符号采样一个信道点，则信道采样点数等于输入信号中的调制符号个数
selec_ray_chan=zeros(num,chann_l);%初始化频率选择性信道，径数＝num
pow_per_channel=10.^(var_pow/10);%各径功率线性化，从dB转变成线性
total_pow_allchan=sum(pow_per_channel);%各径功率之和
%以下for循环产生相互独立的num条rayleigh信道
for k=1:num
    atts=sqrt(pow_per_channel(k));
    selec_ray_chan(k,:)=atts*rayleighnew(chann_l,t_interval,fd,count_begin+k*counter)/sqrt(total_pow_allchan);
end
for k=1:l
    input_sig_serial(((k-1)*nl+1):k*nl)=input_sig(:,k).';%输入信号矩阵转变成串行序列
end
delay_sig=zeros(num,chann_l);%初始化延时后的送入各径的信号，每径所含符号数为chann_l
%以下for循环为各径的输入信号做延迟处理
for f=1:num
    if t_shift(f)~=0
        delay_sig(f,1:t_shift(f))=zeros(1,t_shift(f));
    end
    delay_sig(f,(t_shift(f)+1):chann_l)= input_sig_serial(1:(chann_l-t_shift(f)));
end
output_sig_serial=zeros(1,chann_l);%初始化输出信号串行序列
%得到各径叠加后的输出信号序列
for f=1:num
        output_sig_serial= output_sig_serial+selec_ray_chan(f,:).*delay_sig(f,:);
end
for k=1:l
    output_sig(:,k)=output_sig_serial(((k-1)*nl+1):k*nl).';%输出信号串行序列转变成与输入信号相同的矩阵形式，做为本函数输出
end
%注意，在本函数中没有为信号叠加白噪声
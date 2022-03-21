%频率选择性rayleigh信道测试
num=5;
%假设功率延迟谱服从负指数分布~exp(-t/trms),trms=(1/4)*cp时长；
%t在0~cp时长上均匀分布
%若cp时长为16e-6s，可以取5径延迟如下
delay=[0 2e-6 4e-6 8e-6 12e-6];
trms=4e-6;
var_pow=10*log10(exp(-delay/trms));

fd=132;
t_interval=1e-6;counter=200000;count_begin=0;
t_shift=floor(delay/t_interval);%归一化各径延时
%theta_shift=2*pi*fc*delay;

chann_l=100000;%信道采样点数，若一个调制符号采样一个信道点，则信道采样点数等于输入信号中的调制符号个数
selec_ray_chan=zeros(num,chann_l);%初始化频率选择性信道，径数＝num
pow_per_channel=10.^(var_pow/10);%各径功率线性化，从dB转变成线性
total_pow_allchan=sum(pow_per_channel);%各径功率之和
%以下for循环产生相互独立的num条rayleigh信道
for k=1:num
    atts=sqrt(pow_per_channel(k));
    selec_ray_chan(k,:)=atts*rayleighnew(chann_l,t_interval,fd,count_begin+k*counter)/sqrt(total_pow_allchan);
end
k=1:chann_l;
%plot(k,abs(selec_ray_chan(1,:)),'r',k,abs(selec_ray_chan(2,:)),'g',k,abs(selec_ray_chan(3,:)),'b',k,abs(selec_ray_chan(4,:)),'k',k,abs(selec_ray_chan(5,:)),'m');
figure(1)
plot(k,abs(selec_ray_chan(1,:)));
figure(2)
plot(k,abs(selec_ray_chan(2,:)));
figure(3)
plot(k,abs(selec_ray_chan(3,:)));
figure(4)
plot(k,abs(selec_ray_chan(4,:)));
figure(5)
plot(k,abs(selec_ray_chan(5,:)));
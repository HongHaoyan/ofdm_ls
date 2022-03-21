echo off; 
clear all; 
close all; 

 
fprintf('OFDM基于块状导频的信道估计算法仿真\n正在绘图，请稍后……\n'); 
format long 
%本次仿真载频为2GHz，带宽1MHz，子载波数128个，cp为16 
%子载波间隔为7.8125kHz 
%一个ofdm符号长度为128us，cp长度为16us 
%采用16QAM调制方式 
%最大doppler频率为132Hz 
%多径信道为5径，功率延迟谱服从负指数分布~exp(-t/trms),trms=(1/4)*cp时长，各径延迟取为delay=[0 2e-6 4e-6 8e-6 12e-6] 
pilot_inter=5;%导频符号间隔为10,可以调整，看不同导频间隔下的BER情况，和理论公式比较 
pilot_symbol_bit=[0 0 0 1];%导频为常数，对应星座点1+3*j 
cp_length=16;%cp长度为16 
SNR_dB=[0:4:32]; 
ls_err_ber=zeros(1,length(SNR_dB)); 
lmmse_err_ber=zeros(1,length(SNR_dB)); 
lr_lmmse_err_ber=zeros(1,length(SNR_dB)); 
for i=1:length(SNR_dB)%每个SNR点上仿真若干次 
    ls_error_bit=0; 
    lmmse_error_bit=0; 
    lr_lmmse_error_bit=0; 
    total_bit_num=0; 
loop_num=10; %共仿真10次 
for l=1:loop_num 
    ofdm_symbol_num=100;%每次仿真产生100个ofdm符号,则每次仿真共有100×128个星座映射符号；16QAM调制下，1个星座映射符号包含4个bit 
     
    bit_source=input_b(128,ofdm_symbol_num);%为每次仿真产生100个ofdm符号的比特个数，128为每个ofdm符号的子载波个数 
    [nbit,mbit]=size(bit_source); 
    total_bit_num=total_bit_num+nbit*mbit; 
     
    map_out=map_16qam(bit_source);%对一次仿真符号块进行16QAM映射 
     
    [insert_pilot_out,pilot_num,pilot_sequence]=insert_pilot(pilot_inter,pilot_symbol_bit,map_out);%按块状导频结构，对映射后的结果插入导频序列 
     
    ofdm_modulation_out=ifft(insert_pilot_out,128);%作128点逆FFT运算，完成ofdm调制 
     
    ofdm_cp_out=insert_cp(ofdm_modulation_out,cp_length);%插入循环前缀 ，行数变多了，列数没变
         
    %********************** 以下过程为ofdm符号通过频率选择性多径信道 ************************* 
    num=5; 
    %假设功率延迟谱服从负指数分布~exp(-t/trms),trms=(1/4)*cp时长； 
    %t在0~cp时长上均匀分布 
    %若cp时长为16e-6s，可以取5径延迟如下 
    delay=[0 2e-6 4e-6 8e-6 12e-6]; 
    trms=4e-6; 
    var_pow=10*log10(exp(-delay/trms)); 
    fd=132;%最大doppler频率为132Hz 
    t_interval=1e-6;%采样间隔为1us 
    counter=200000;%各径信道的采样点间隔，应该大于信道采样点数。由以上条件现在信道采样点数 
    count_begin=(l-1)*(5*counter);%每次仿真信道采样的开始位置 
    trms_1=trms/t_interval; 
    t_max=16e-6/t_interval; 
    %信道采样点数，每个调制符号采一个点 
    passchan_ofdm_symbol=multipath_chann(ofdm_cp_out,num,var_pow,delay,fd,t_interval,counter,count_begin); 
     
    %********************** 以上过程为ofdm符号通过频率选择性多径信道 ************************* 
     
     %********************** 以下过程为ofdm符号加高斯白噪声 ************************* 
    snr=10^(SNR_dB(i)/10); 
    [nnl,mml]=size(passchan_ofdm_symbol); 
    spow=0; 
    for k=1:nnl 
      for b=1:mml 
        spow=spow+real(passchan_ofdm_symbol(k,b))^2+imag(passchan_ofdm_symbol(k,b))^2; 
      end 
    end 
    spow1=spow/(nnl*mml);         
    sgma=sqrt(spow1/(2*snr));%sgma如何计算，与当前SNR和信号平均能量有关系 
    receive_ofdm_symbol=add_noise(sgma,passchan_ofdm_symbol);%加入随机高斯白噪声，receive_ofdm_symbol为最终接收机收到的ofdm符号块 ，为什么列数变为1了？
     
    %********************** 以上过程为ofdm符号加高斯白噪声 ************************* 
    cutcp_ofdm_symbol=cut_cp(receive_ofdm_symbol,cp_length);%去除循环前缀 
     
    ofdm_demodulation_out=fft(cutcp_ofdm_symbol,128);%作128点FFT运算，完成ofdm解调 
     
    %********************** 以下就是对接收ofdm信号进行信道估计和信号检测的过程************************ 
    ls_zf_detect_sig=ls_estimation(ofdm_demodulation_out,pilot_inter,pilot_sequence,pilot_num);%采用LS估计算法及迫零检测得到的接收信号 
    lmmse_zf_detect_sig=lmmse_estimation(ofdm_demodulation_out,pilot_inter,pilot_sequence,pilot_num,trms_1,t_max,snr);%采用LMMSE估计算法及迫零检测得到的接收信号 
    low_rank_lmmse_sig=lr_lmmse_estimation(ofdm_demodulation_out,pilot_inter,pilot_sequence,pilot_num,trms_1,t_max,snr,cp_length);%采用低秩LMMSE估计算法及迫零检测得到的接收信号 
    %********************** 以下就是对接收ofdm信号进行信道估计和信号检测的过程************************ 
     
    ls_receive_bit_sig=de_map(ls_zf_detect_sig);%16QAM解映射 
    lmmse_receive_bit_sig=de_map(lmmse_zf_detect_sig); 
    lr_lmmse_receive_bit_sig=de_map(low_rank_lmmse_sig); 
     
    %以下过程统计各种估计算法得到的接收信号中的错误比特数 
    ls_err_num=error_count(bit_source,ls_receive_bit_sig); 
    lmmse_err_num=error_count(bit_source,lmmse_receive_bit_sig); 
    lr_lmmse_err_num=error_count(bit_source,lr_lmmse_receive_bit_sig); 
     
    ls_error_bit=ls_error_bit+ls_err_num; 
    lmmse_error_bit=lmmse_error_bit+lmmse_err_num; 
    lr_lmmse_error_bit=lr_lmmse_error_bit+lr_lmmse_err_num; 
end 
%计算各种估计算法的误比特率 
 
ls_err_ber(i)=ls_error_bit/total_bit_num; 
lmmse_err_ber(i)=lmmse_error_bit/total_bit_num; 
lr_lmmse_err_ber(i)=lr_lmmse_error_bit/total_bit_num; 
 
end 
 
plot(SNR_dB,ls_err_ber,'-*b'); 
hold on 
plot(SNR_dB,lmmse_err_ber,'-oblack'); 
hold on; 
plot(SNR_dB,lr_lmmse_err_ber,'-vblack'); 
grid on; 
xlabel('信噪比SNR(dB)'); 
ylabel('误比特率(BER)'); 
%title('OFDM基于块状导频的信道估计算法仿真'); 
legend('LS信道估计','MMSE信道估计','LMMSE信道估计'); 
 
fprintf('绘图完成@！@\n') 
hold off; 
 

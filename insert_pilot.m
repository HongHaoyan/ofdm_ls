function [output,count,pilot_sequence]=insert_pilot(pilot_inter,pilot_symbol_bit,map_out_block) 
% pilot_inter为导频符号间隔，以ofdm符号个数的形式给出，为整数。间隔越大估计误差越大
% pilot_symbol_bit 采用常数导频符号，这里给出它的二进制形式
% map_out_block 映射后的一次仿真所包含的符号块
  pilot_symbol=qam16(pilot_symbol_bit);     %导频复符号
  [N,NL]=size(map_out_block);
  output=zeros(N,(NL+fix(NL/pilot_inter)));%这个有什么用？fix向0取整，列数变多了？？
  pilot_sequence=pilot_symbol*ones(N,1);
  
  count=0;%记录插入导频信号的次数
  i=1;
  while i<(NL+fix(NL/pilot_inter))%每隔pilot_inter个符号插入一个导频序列
      output(:,i)=pilot_sequence;
      count=count+1;
      if count*pilot_inter<=NL
      output(:,(i+1):(i+pilot_inter))=map_out_block(:,((count-1)*pilot_inter+1):count*pilot_inter);
  else
      output(:,(i+1):(i+pilot_inter+NL-count*pilot_inter))=map_out_block(:,((count-1)*pilot_inter+1):NL);
  end
      i=i+pilot_inter+1;
  end

          
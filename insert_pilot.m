function [output,count,pilot_sequence]=insert_pilot(pilot_inter,pilot_symbol_bit,map_out_block) 
% pilot_interΪ��Ƶ���ż������ofdm���Ÿ�������ʽ������Ϊ���������Խ��������Խ��
% pilot_symbol_bit ���ó�����Ƶ���ţ�����������Ķ�������ʽ
% map_out_block ӳ����һ�η����������ķ��ſ�
  pilot_symbol=qam16(pilot_symbol_bit);     %��Ƶ������
  [N,NL]=size(map_out_block);
  output=zeros(N,(NL+fix(NL/pilot_inter)));%�����ʲô�ã�fix��0ȡ������������ˣ���
  pilot_sequence=pilot_symbol*ones(N,1);
  
  count=0;%��¼���뵼Ƶ�źŵĴ���
  i=1;
  while i<(NL+fix(NL/pilot_inter))%ÿ��pilot_inter�����Ų���һ����Ƶ����
      output(:,i)=pilot_sequence;
      count=count+1;
      if count*pilot_inter<=NL
      output(:,(i+1):(i+pilot_inter))=map_out_block(:,((count-1)*pilot_inter+1):count*pilot_inter);
  else
      output(:,(i+1):(i+pilot_inter+NL-count*pilot_inter))=map_out_block(:,((count-1)*pilot_inter+1):NL);
  end
      i=i+pilot_inter+1;
  end

          
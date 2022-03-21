function output=ls_estimation(input,pilot_inter,pilot_sequence,pilot_num);
[N,NL]=size(input);
output=zeros(N,NL-pilot_num);
 i=1;
 count=0;
  while i<=NL
      Hi=input(:,i)./pilot_sequence;
      count=count+1;
      if  count*pilot_inter<=(NL-pilot_num)
      for j=((count-1)*pilot_inter+1):count*pilot_inter
      output(:,j)=input(:,(i+j-(count-1)*pilot_inter))./Hi;
  end
else
    for j=((count-1)*pilot_inter+1):(NL-pilot_num)
      output(:,j)=input(:,(i+j-(count-1)*pilot_inter))./Hi;
  end
end
      i=i+pilot_inter+1;
  end
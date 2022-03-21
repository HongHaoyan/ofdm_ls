function output=insert_cp(input,cp_length)%为ofdm符号块插入循环前缀，cp_length为循环前缀长度
         [m,n]=size(input);
         output=zeros(m+cp_length,n);
         %以下循环为各列插入循环前缀
         for j=1:n
             output(1:cp_length,j)=input((m-cp_length+1):m,j);
             output((cp_length+1):(m+cp_length),j)=input(:,j);
         end
         
             

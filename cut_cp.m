function output=cut_cp(input,cp_length)    %cp_length是循环前缀的长度
        [m,n]=size(input);
         output=zeros(m-cp_length,n);
         %以下循环为各列插入循环前缀
         for j=1:n
             output(1:(m-cp_length),j)=input((cp_length+1:m),j);
             
         end
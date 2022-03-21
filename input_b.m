 function x=input_b(N,NL)%N为一个ofdm符号中的子符号个数，NL为一次仿真所包含的ofdm符号数
    for i=1:NL    
         input_0=rand(1,4*N);    %输入的二进制数据序列
         for j=1:4*N
              if input_0(j)>0.5
                 input(j,i)=1;
               else 
                  input(j,i)=0;
              end
         end
     end
     x=input;
    
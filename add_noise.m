function output=add_noise(sgma,input)
         [n,nl]=size(input);
         for k=1:nl
            for m=1:n
                noise=normrnd(0,sgma)+normrnd(0,sgma)*sqrt(-1);              %噪声方差为sgma平方输入
                output(m,k)=input(m,k)+noise;
            end
         end
         
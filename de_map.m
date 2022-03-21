function output=de_map(input)
         [m,n]=size(input);
         output=zeros(4*m,n);
         for j=1:n
           for i=1:m
           y=de_qam16(input(i,j));
           for ic=1:4
               output(4*(i-1)+ic,j)=y(ic);
           end
       end
   end
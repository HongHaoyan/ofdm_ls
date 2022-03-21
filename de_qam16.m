function y=de_qam16(x)     %qam解调，X1是序列长度，K1就是2^K1qam
%  for n=1:4:16
%  x=1.4+sqrt(-1)*(-2.6);
   y=real(x);
   y1=imag(x);
  if         (y>=0)&(y<=2)     y=1;
       elseif (y>2)             y=3;
       elseif (y<-2)            y=-3;
       else                     y=-1;
   end
   if         (y1>=0)&(y1<=2)   y1=1;
       elseif (y1>2)            y1=3;
       elseif (y1<-2)           y1=-3;
       else                     y1=-1;
    end
    x=complex(y,y1);
    if        x==1+j      y=[0 0 0 0];
      elseif  x==1-j      y=[0 0 1 0];
      elseif  x==-1+j     y=[1 0 0 0];
      elseif  x==-1-j     y=[1 0 1 0];
      elseif  x==3+j      y=[0 1 0 0];
      elseif  x==1+3*j    y=[0 0 0 1];
      elseif  x==3-j      y=[0 1 1 0];
      elseif  x==1-3*j    y=[0 0 1 1];
      elseif  x==-1+3*j   y=[1 0 0 1];
      elseif  x==-3+j     y=[1 1 0 0];
      elseif  x==-3-j     y=[1 1 1 0];
      elseif  x==-1-3*j   y=[1 0 1 1];
      elseif  x==3+3*j    y=[0 1 0 1];
      elseif  x==-3+3*j   y=[1 1 0 1];
      elseif  x==-3-3*j   y=[1 1 1 1];
      elseif  x==3-3*j    y=[0 1 1 1];
    end


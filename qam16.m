function x=qam16(y)
  if y==[0 0 0 0] x=1+j;
  elseif y==[0 0 1 0] x=1-j;
  elseif y==[1 0 0 0] x=-1+j;
  elseif y==[1 0 1 0] x=-1-j;
  elseif y==[0 1 0 0] x=3+j;
  elseif y==[0 0 0 1] x=1+3*j;
  elseif y==[0 1 1 0] x=3-j;
  elseif y==[0 0 1 1] x=1-3*j;
  elseif y==[1 0 0 1] x=-1+3*j;
  elseif y==[1 1 0 0] x=-3+j;
  elseif y==[1 1 1 0] x=-3-j;
  elseif y==[1 0 1 1] x=-1-3*j;
  elseif y==[0 1 0 1] x=3+3*j;
  elseif y==[1 1 0 1] x=-3+3*j;
  elseif y==[1 1 1 1] x=-3-3*j;
  elseif y==[0 1 1 1] x=3-3*j;
  end
function ray_chann=rayleighnew(nsamp,tstp,fd,counter)

%****************** variables *************************
% idata  : input Ich data     
% qdata  : input Qch data     
% iout   : output Ich data
% qout   : output Qch data
% ramp   : Amplitude contaminated by fading
% rcos   : Cosine value contaminated by fading
% rsin   : Cosine value contaminated by fading
% nsamp  : Number of samples to be simulated       
% tstp   : Minimum time resolution                    
% fd     : maximum doppler frequency               
% no     : number of waves in order to generate fading   
% counter  : fading counter                          
% flat     : flat fading or not 
% (1->flat (only amplitude is fluctuated),0->nomal(phase and amplitude are fluctutated)    
%******************************************************
no=25;
if fd ~= 0.0  
    ac0 = sqrt(1.0 ./ (2.0.*(no + 1)));   % power normalized constant(ich)
    as0 = sqrt(1.0 ./ (2.0.*no));         % power normalized constant(qch)
    %ic0 = counter;                        % fading counter
 
    pai = 3.14159265;   
    wm = 2.0.*pai.*fd;
    n = 4.*no + 2;
    ts = tstp;
    wmts = wm.*ts;
    paino = pai./no;                        

    xc=zeros(1,nsamp);
    xs=zeros(1,nsamp);
    ic=[1:nsamp]+counter;

  for nn = 1: no
	  cwn = cos( cos(2.0.*pai.*nn./n).*ic.*wmts );
	  xc = xc + cos(paino.*nn).*cwn;
	  xs = xs + sin(paino.*nn).*cwn;
  end

  cwmt = sqrt(2.0).*cos(ic.*wmts);
  xc = (2.0.*xc + cwmt).*ac0;
  xs = 2.0.*xs.*as0;

  %ramp=sqrt(xc.^2+xs.^2);   
  %rcos=xc./ramp;
  %rsin=xs./ramp;
  ray_chann=xc+j*xs;

  

else  
 ray_chann=ones(1,nsamp);
end

% ************************end of file***********************************

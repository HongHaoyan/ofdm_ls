function output=lr_lmmse_estimation(input,pilot_inter,pilot_sequence,pilot_num,trms,t_max,snr,cp);
%trms为多经信道的平均延时，t_max为最大延时,此处所有的时间都是已经对采样间隔做了归一化后的结果
beta=17/9;
[N,NL]=size(input);
Rhh=zeros(N,N);
for k=1:N
    for l=1:N
        Rhh(k,l)=(1-exp((-1)*t_max*((1/trms)+j*2*pi*(k-l)/N)))./(trms*(1-exp((-1)*t_max/trms))*((1/trms)+j*2*pi*(k-l)/N));
    end
end
%以下过程是对Rhh矩阵进行特征值分解，并按特征值大小排队，选最大的16个特征值
[U,D]=eig(Rhh);%U为满秩酉阵，D是以特征值为主对角线的对角阵
dlamda=diag(D);%取D对角元素构成列向量
[dlamda_sort,IN]=sort(dlamda);%按升序排列各特征值，dlamda_sort为排序结果，IN为各元素在原向量中的位置索引
for k=1:N
    lamda_sort(k)=dlamda_sort(N-k+1);%按照降序排列各特征值
    IN_new(k)=IN(N-k+1);
end
%以下按照IN_new顺序排列U的各列
U_new=zeros(N,N);
for k=1:N
    U_new(:,k)=U(:,IN_new(k));
end
%以下只取前cp个特征值构成新的对角阵
delta=zeros(N,1);
for k=1:N
    if k<=cp
       delta(k)=lamda_sort(k)/(lamda_sort(k)+beta/snr);
    else
        delta(k)=0;
    end
end
D_new=diag(delta);
output=zeros(N,NL-pilot_num);
i=1;
count=0;
while i<=NL
    Hi=input(:,i)./pilot_sequence;
    Hlr=U_new*D_new*(U_new')*Hi;
    count=count+1;
    if  count*pilot_inter<=(NL-pilot_num)
        for a=((count-1)*pilot_inter+1):count*pilot_inter
            output(:,a)=input(:,(i+a-(count-1)*pilot_inter))./Hlr;
        end
    else
        for a=((count-1)*pilot_inter+1):(NL-pilot_num)
            output(:,a)=input(:,(i+a-(count-1)*pilot_inter))./Hlr;
        end
    end
    i=i+pilot_inter+1;
  end
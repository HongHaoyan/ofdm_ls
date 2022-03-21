function err_num=error_count(source,receive)
    err_num=0;    
    [m,n]=size(receive);
        for i=1:m
            for j=1:n
                if receive(i,j) ~=source(i,j)
                   err_num=err_num+1;
                end
            end
        end

function [ M ] = BuildProj( c )
    % function [ M ] = BuildProj( c )
    %  Build projectors for one variable with c values in n space
    
    m = size(c,2);   % no. values of C
    n = max(c{m});   % dim of H
    
    M = zeros(n,n,n);
    
    for j = 1:n
        Mj = zeros(n,n);
        Mj(j,j) = 1;
        M(j,:,:) = Mj;
    end
    
    C = zeros(m,n,n) ;
    for j = 1:m
        C(j,:,:) = sum(M(c{j},:,:),1);
    end
    M  = C;
    end
    
function [ M ] = BuildInComp( P,X,Inc)
    % function [ M ] = BuildInComp( P,X,Inc )
    
    %   |A> * |B>  compatible space
    %   na = dim of A
    %   nb = dim of B
    %   c = subspaces for measurements of c, row of cells
    
    %  m = size(c,2);   % no. values of C
    %  n = max(c{m});   % dim of H
    
    m = size(X,1);
    n = size(X,2);
    
    I2 = eye(2);
    
    H = BuildHam(P);
    
    U = expm(-1i*H);
    %  choose whether 1st or 2nd cubit
    U = (Inc==1).*kron(U,I2) + (Inc==2).*kron(I2,U); 
    
    C = zeros(m,n,n) ;
    for j = 1:m
       % C(j,:,:) = X(j,:,:);
        C(j,:,:) = U*squeeze(X(j,:,:))*U';
    end
    
    M = C;
    
    end
    
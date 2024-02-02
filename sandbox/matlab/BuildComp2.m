function [ MA, MB ] = BuildComp2( ca,cb )
    % function [ MA, MB ] = BuildComp2( ca,cb )
    
    %   |A> * |B>  compatible space
    %   na = dim of A
    %   nb = dim of B
    %   ca = subspaces for measurements of a, row of cells
    %   cb = subspaces for measurements of b  row of cells
    
    ma = size(ca,2);   % no. values of A
    mb = size(cb,2);   % no. values of B
    
    na = max(ca{ma});   % dim of A
    nb = max(cb{mb});   % dim of B
    nd = na*nb;         % dim of H
    
    MA = zeros(ma,nd,nd);
    MB = zeros(mb,nd,nd);
    
    Ia = eye(na);
    Ib = eye(nb);
    
    
    %%%%%%%%%%%%%%%%%%%%
    %  build A
    
     Ix = Ib;
    C = BuildProj(ca);
    
    for j = 1:ma
        Mj = squeeze(C(j,:,:));
        MA(j,:,:) = kron(Mj,Ix);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Build B
    
     Ix = Ia;
    C = BuildProj(cb);
    
    for j = 1:mb
        Mj = squeeze(C(j,:,:));
        MB(j,:,:) = kron(Ix,Mj);
    end
    
    
    end
    
function [ MA, MB, MC, MD ] = BuildComp4( ca,cb,cc,cd )
    % function [ MA, MB, MC, MD ] = BuildComp4( ca,cb,cc,cd )
    
    %   |A> * |B> * |C> * |D>  compatible space
    %   na = dim of A
    %   nb = dim of B
    %   nc = dim of C
    %   nd = dim of D
    %   ca = subspaces for measurements of a, row of cells
    %   cb = subspaces for measurements of b  row of cells
    %   cc = subspaces for measurements of c  row of cells
    %   cd = subspaces for measurements of d  row of cells
    
    ma = size(ca,2);   % no. values of A
    mb = size(cb,2);   % no. values of B
    mc = size(cc,2);   % no. values of C
    md = size(cd,2);   % no. values of D
    
    na = max(ca{ma});   % dim of A
    nb = max(cb{mb});   % dim of B
    nc = max(cc{mc});   % dim of C
    nd = max(cd{md});   % dim of D
    
    dim = na*nb*nc*nd;         % dim of H
    
    MA = zeros(dim,dim,dim);
    MB = MA; MC = MA; MD = MA;
    
    Ia = eye(na);
    Ib = eye(nb);
    Ic = eye(nc);
    Id = eye(nd);
    
    
    %%%%%%%%%%%%%%%%%%%%
    %  build A
    
     Ix = Ib; Iy = Ic; Iz = Id;
    
    C = BuildProj(ca);
    
    for j = 1:ma
        Mj = squeeze(C(j,:,:));
        M1 = kron(Mj,Ix);
        M2 = kron(M1,Iy);
        Mj = kron(M2,Iz);
        MA(j,:,:) = Mj; 
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Build B
    
     Ix = Ia; Iy = Ic; Iz = Id;
    
    C = BuildProj(cb);
    
    for j = 1:mb
        Mj = squeeze(C(j,:,:));
        M1 = kron(Ix,Mj);
        M2 = kron(M1,Iy);
        Mj = kron(M2,Iz);
        MB(j,:,:) = Mj;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Build C
    
     Ix = Ia; Iy = Ib; Iz = Id;
    
    C = BuildProj(cc);
    
    for j = 1:mc
        Mj = squeeze(C(j,:,:));
        M1 = kron(Ix,Iy);
        M2 = kron(M1,Mj);
        Mj = kron(M2,Iz);
        MC(j,:,:) = Mj;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Build D
    
     Ix = Ia; Iy = Ib; Iz = Ic;
    
    C = BuildProj(cd);
    
    for j = 1:md
        Mj = squeeze(C(j,:,:));
        M1 = kron(Ix,Iy);
        M2 = kron(M1,Iz);
        Mj = kron(M2,Mj);
        MD(j,:,:) = Mj;
    end
    
    end
    
function M = ProjQP(nv,Comp,Inc,~)
    %function M = ProjQP(nv,Comp,Inc,Hdim)
    % create projectors for quantum model
    
    
    na = nv(1);  % no. of values a
    nb = nv(2);  % no. of values b
    nc = nv(3);  % 2 
    nd = nv(4);  % 2
    
    ca = cell(1,na);
    for j=1:na
        ca{j} = j;
    end
    
    cb = cell(1,nb);
    for j=1:nb
        cb{j} = j;
    end
    
    cc = cell(1,nc);
    for j=1:nc
        cc{j} = j;
    end
    
    cd = cell(1,nd);
    for j=1:nd
        cd{j} = j;
    end
    
    cq = {ca,cb,cc,cd};
    
    M = cell(1,5);
    
    
    %                   1st H subspace 2nd H subspace
    [Mx,My] = BuildComp2(cq{Comp(1)},cq{Comp(2)});
    M(Comp) = {Mx, My};
    
    [Mx, My] = BuildComp2(cq{Inc(1)},cq{Inc(2)});
    M(Inc) = {Mx, My};
    M(5) = {1};
end    
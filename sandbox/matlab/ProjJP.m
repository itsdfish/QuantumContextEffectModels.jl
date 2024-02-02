function M = ProjJP(nv)
    % function M = ProjJP(nv)
    
    % Create Projectors
    na = nv(1);
    nb = nv(2);
    nc = nv(3);
    nd = nv(4);
    
    % create projectors for A,B,C,D assuming all are compatible for Joint Prob model
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
    
    [MA, MB, MC, MD] = BuildComp4(ca,cb,cc,cd);
    M = {MA,MB,MC,MD,1};    % last 1 is for one-way table

end
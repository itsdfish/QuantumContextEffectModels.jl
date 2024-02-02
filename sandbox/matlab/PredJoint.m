function [ Tbl ] = PredJoint( parm, M, Vars, nn )
    %  function [ Tbls ] = PredJoint( parm, M, Vars, nn) )
    % generate predictions from Joint P model
    
    Psy = parm;
    nt = size(Vars,2);
    Tbl = cell(1,nt);
    
    for j=1:nt
        
        rc = Vars{j};
        v = nn{j};
        T = real(TwoWayC(M{rc(1)},M{rc(2)},Psy,v(1),v(2)));   % 2 x 3
    %     if rc(3)==2
    %         T = T';
    %     end
        Tbl{j} = T;
    end
    
    end
    
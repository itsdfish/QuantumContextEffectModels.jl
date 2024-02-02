function  [Chi, Parm, Px] = quant2(Parm,M,Vars,nn,Comp,Inc,Py,Fy)
    % function [Chi, Parm, Px] = quant2(Parm,M,Vars,nn,Comp,Inc,Py,Fy)
    % four dim Hilbert space model
    % Parm contains parameters
    % M contains projectors
    % Vars is list of variables
    % nn is size of tables
    % Inc indicates incompatible var's
    % Py  contains relative frequency vector
    % Fy  contains raw frequency vector
    % Chi is Chi square diff quant vs saturated
    % Px contains predicted probabilities
    
    % model assumes
    % A=1 and H=2 incompatible
    % I=3 and U=4 incompatible
    
    % A and I compatible,
    % H and I compatible,
    % A and U compatible,
    % H and U compatible
    
    
    % Assign parameters
    
    np = size(Parm,2);
    
    if np == 12
        
        P = cell(1,4);
        P{3} = Parm(1,1:3);
        P{4} = Parm(1,3+(1:3));
        P{1} = Parm(1,2*3+(1:3));
        P{2} = Parm(1,((2*3)+3)+(1:3));
        
        Psy = exp([0 P{3}])';   % magnitudes
        phase = diag(exp(1i*[0 P{4} ]));  % phases
        Psy = phase*Psy;        % insert phases
        Psy = Psy./sqrt(Psy'*Psy);    % normalize
        
    else
        np = np/2;
        nt = size(Vars,2);
        loc = sum(reshape(cell2mat(Vars),2,nt)==Comp'*ones(1,nt));
        [x,loc] = max(loc);
        loc = (loc-1).*4;
        Psy = sqrt(Py(loc+[1 3 2 4]));  % put table 5 in YY YN NY NN order
        P = {Parm(1,1:np), Parm(1,np+(1:np)) };
        
    end
    
    nt = size(Vars,2);
    Px = [];
    
    
    ni = size(Inc,2);
    for j=1:ni
        Pi = (j==1).*P{1} + (j==2).*P{2};
        M{Inc(j)} = BuildInComp(Pi,M{Inc(j)},j);
    end
    
    
    for j=1:nt
        rc = Vars{j};
        v = nn{j};
        T = real(TwoWayQ(M{rc(1)},M{rc(2)},Psy,v(1),v(2)));  
        n = size(T,1).*size(T,2);
        px = reshape(T,n,1);
        Px = cat(1,Px,px) ;
    end
    
    eps = 10^-5;
    Px = eps + (1-2*eps)*Px;
    Py = eps + (1-2*eps)*Py;
    Chi2 = Fy'*log(Px) ;
    Chi1 = Fy'*log(Py) ;
    Chi = 2*(Chi1 - Chi2);
    
end    
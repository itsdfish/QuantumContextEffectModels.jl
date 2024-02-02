function  [Chi, Px] = JointP(parm, M, Vars, nn, Py, Fy)
    % function [Chi, Px] = JointP(parm, M, Vars, nn, Py, Fy)
    % test of joint probability model
    % parm = parameters of joint prob model
    % Py = vector of probabilities
    % Fy = vector of frequencies
    
    Psy = parm;
    nt = size(Vars,2);
    Px = [];
    
    for j=1:nt    
        rc = Vars{j};
        v = nn{j};
        T = real(TwoWayC(M{rc(1)},M{rc(2)},Psy,v(1),v(2)));
    %     if rc(3)==2
    %         T = T';
    %     end
        n = size(T,1).*size(T,2);
        px = reshape(T,n,1);
        Px = cat(1,Px,px) ;
    end
    
    eps = 10^-10;
    Px = eps + (1-2*eps)*Px;
    Py = eps + (1-2*eps)*Py;
    
    Chi2 = Fy'*log(Px) ;
    Chi1 = Fy'*log(Py) ;
    Chi = -2*(Chi2 - Chi1);
end
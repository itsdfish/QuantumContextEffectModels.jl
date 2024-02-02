function [ TAB ] = TwoWayC( A,B,Psy,na,nb)
    % function [ Tbl ] = TwoWayC( MA,MB, Psy,na,nb )
    % create two way contingency table from Q model
    
    nd = size(B,1);
    J = ones(nd,1);
    TAB = zeros(na,nb);
    for j = 1:na
        for k = 1:nb
            M1 = squeeze(A(j,:,:));
            M2 = squeeze(B(k,:,:));
            TAB(j,k) = J'*M2*M1*Psy;
        end
    end
    
end
    
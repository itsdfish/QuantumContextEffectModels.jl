function [ TAB ] = TwoWayQ( A,B,Psy,na,nb)
    % function [ Tbl ] = TwoWayQ( MA,MB, Psy,na,nb )
    % create two way contingency table from Q model
    
    TAB = zeros(na,nb);
    for j = 1:na
        for k = 1:nb
            M1 = squeeze(A(j,:,:));
            M2 = squeeze(B(k,:,:));
            TAB(j,k) = Psy'*M1*M2*M1*Psy;
        end
    end
    
    end
    
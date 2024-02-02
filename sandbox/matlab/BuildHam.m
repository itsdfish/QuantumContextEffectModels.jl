function [ H ] = BuildHam( P )
    % function [ H ] = BuildHam( P )
    % unitary transform from |A>*|B> -> |C>
    
    %%%%%%%%%%%%%%%%%%%
    % Hamiltonian
    
    np  = size(P,2);
    
    if np == 3
        p1 = exp(1i*P(1,3));
    else
        p1 = 1;
    end
    
    H = [P(1) P(2)*p1;   P(2)*conj(p1)  0] ;
    
    
    end
    
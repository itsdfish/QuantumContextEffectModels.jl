function [ Pr, Tr ] = Interpret( P )
    % function [ Pr Tr ] = Interpret( P )
    %  interpret parameters
    
    
    %      AyIy AyIn AnIy AnIn    Initial state
    Psi = exp([0 P(1,1:3)])';   % magnitudes
    Psi = Psi./sqrt(Psi'*Psi);    % normalize
    phase = diag(exp(1i*[0 P(1,4:6)]));  % phases
    Psi = phase*Psi;        % insert phases
    
    
    disp('abs(Psi) in AI basis')
    disp('     YY       YN         NY       NN')
    disp(abs(Psi)')
    
    % measurement operators
    S0 = eye(2);
    My = [1 0 ; 0 0];   % yes = pos
     
    % Build unitaries using matrix exponential
    p1 = exp(1i*P(1,11));
    p2 = exp(1i*P(1,12));
    Uha = [P(1,7) P(1,8)*p1;   P(1,8)*conj(p1)  0];  
    Uha = expm(-1i*Uha);    
    Uui = [P(1,9) P(1,10)*p2; P(1,10)*conj(p2)  0];  
    Uui = expm(-1i*Uui);
    
    Tr = [abs(Uha(1,1)).^2 abs(Uui(1,1)).^2 ];
    
    % question A   operates on first cubit
    PAp = Psi'*kron(My,S0)*Psi;
    
    % question H   rotated from A
    PHp = Uha*My*Uha'; PHp = Psi'*kron(PHp,S0)*Psi;
    
    % question I    % operates on second cubit
    PIp = Psi'*kron(S0,My)*Psi;  
    
    % question U   % rotated from I
    PUp = Uui*My*Uui'; PUp = Psi'*kron(S0,PUp)*Psi;
    
    Pr = real([    PAp     PHp    PIp    PUp]);
    
    disp('Unitary A pos to H pos')
    disp(Tr(1))
    disp('Unitary I pos to U pos')
    disp(Tr(2))
    
    disp('    PrA       PrH       PrI        PrU')
    disp(Pr)
    
    end
    
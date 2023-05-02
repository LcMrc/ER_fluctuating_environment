% This code was created by Loïc Marrec

% This code is based on a Gillespie algorithm. Please look at the
% supporting information of our paper for more details.

function T0list = Gillespie_deterministic(bF, dF, bH, dH, K, N0, tau, Nit)

    T0list = NaN(Nit, 1);
    
    for i = 1 : Nit
        
        N = N0;
        q = 1;
        t = 0;
        tswitch = tau;
        
        while N ~= 0
            
            if mod(q, 2) == 1
                
                b = bH;
                d = dH;
                
            else
                
                b = bF;
                d = dF;
                
            end
            
            Tb = b*(1-N/K)*N;
            Td = d*N;
            T = Tb+Td;
            t = t-log(rand)/T;
            
            if t >= tswitch
                
                t = tswitch;
                q = q+1;
                tswitch = tswitch+tau;
                
            else
                
                if rand < Tb/T
                    
                    N = N+1;
                    
                else
                    
                    N = N-1;
                    
                end
                
            end
            
        end
        
        T0list(i) = t;
        
    end
    
end
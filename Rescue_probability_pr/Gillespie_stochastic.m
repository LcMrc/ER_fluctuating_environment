% This code was created by Loïc Marrec

% This code is based on a Gillespie algorithm. Please look at the
% supporting information of our paper for more details.

function NMlist = Gillespie_stochastic(Nit, bWF, bWH, dWF, dWH, NW0, bMF, bMH, dMF, dMH, NM0, K, tau, mu, sigma)

    NMlist = NaN(1, Nit);

    for i = 1 : Nit

        % Initialization

        NW = NW0;              % Initialization of the number of A individuals
        NM = NM0;              % Initialization of the number of B individuals
        t = 0;                 % Initialization of time
        Tenv = normrnd(tau, sigma);
        while Tenv <= 0
            
            Tenv = normrnd(tau, sigma);
            
        end
        tswitch = Tenv;
        q = 1;
        cumul = zeros(5, 1);    % To build the sampling tower

        while NW ~= 0  
            
            if mod(q, 2) == 1
                
                bW = bWH;
                dW = dWH;
                bM = bMH;
                dM = dMH;
                
            else
                
                bW = bWF;
                dW = dWF;
                bM = bMF;
                dM = dMF;
                
            end
            
            % Compute the transition rates

            T_W_rep = bW*(1-(NW+NM)/K)*NW*(1-mu);   
            T_W_death = dW*NW;
            T_M_rep = bM*(1-(NW+NM)/K)*NM;
            T_M_death = dM*NM;
            T_mut = bW*(1-(NW+NM)/K)*NW*mu;  
            T = T_W_rep+T_W_death+T_M_rep+T_M_death+T_mut;

            % Compute tau and then the new time

            t = t-log(rand)/T;
            
            if t >= tswitch
                
                t = tswitch;
                q = q+1;
                Tenv = normrnd(tau, sigma);
                while Tenv <= 0

                    Tenv = normrnd(tau, sigma);

                end
                tswitch = tswitch+Tenv;
                
            else
            
                % Build a sampling tower

                ir2 = 1;
                r2 = rand;
                cumul(1) = T_W_rep;
                cumul(2) = T_W_rep+T_W_death;
                cumul(3) = T_W_rep+T_W_death+T_M_rep;
                cumul(4) = T_W_rep+T_W_death+T_M_rep+T_M_death;
                cumul(5) = T;

                % Determine which reaction occurs and compute the number of
                % individuals

                while cumul(ir2) < r2*T

                    ir2 = ir2+1;

                end

                if ir2 == 1

                    NW = NW+1;

                elseif ir2 == 2

                    NW = NW-1;

                elseif ir2 == 3

                    NM = NM+1;

                elseif ir2 == 4

                    NM = NM-1;
                    
                elseif ir2 == 5
                    
                    NM = NM+1;

                end
                
            end
            
        end

        NMlist(1, i) = NM;
        
     end
   
end
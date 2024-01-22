%**************************************************************************
% Calculate Beta coeficient for polarization Horizontal or Vertical 
% Parameters:
%       fc: Frequency in GHz
%       polarization: H: Horizontal or V: Vertical
% Results:
%       Beta: Beta attenuation value
%**************************************************************************

function Beta = Calculate_Beta(fc, polarization)

    polarization = upper(polarization);

    if (strcmp(polarization, 'H'))

        load Beta_H.mat;
        mk = 0.67849;
        ck = -1.95537;

        sumCoef = 0;
        for i=1:length(Beta_H.j)

            aj = Beta_H(Beta_H.j == i,:).aj;
            bj = Beta_H(Beta_H.j == i,:).bj;
            cj = Beta_H(Beta_H.j == i,:).cj;

            sumCoef = sumCoef + (aj * exp(-power((log10(fc)-bj)/cj,2)));

        end

        Beta = sumCoef + (mk*log10(fc)) + ck;

    elseif (strcmp(polarization, 'V'))
                
        load 'Beta_V.mat';
        mk = -0.053739;
        ck = 0.83433;     

        sumCoef = 0;
        for i=1:length(Beta_V.j)

            aj = Beta_V(Beta_V.j == i,:).aj;
            bj = Beta_V(Beta_V.j == i,:).bj;
            cj = Beta_V(Beta_V.j == i,:).cj;

            sumCoef = sumCoef + (aj * exp(-power((log10(fc)-bj)/cj,2)));

        end
        
        Beta = sumCoef + (mk*log10(fc)) + ck;      

    end

end
%**************************************************************************
% Calculate Gamma coeficient for polarization Horizontal or Vertical 
% Parameters:
%       fc: Frequency in GHz
%       polarization: H: Horizontal or V: Vertical
% Results:
%       Gamma: Gamma attenuation value
%**************************************************************************

function Gamma = Calculate_Gamma(fc, polarization)

    polarization = upper(polarization);

    if (strcmp(polarization, 'H'))

        load Gamma_H.mat;
        mk = -0.18961;
        ck = 0.71147;

        sumCoef = 0;
        for i=1:length(Gamma_H.j)

            aj = Gamma_H(Gamma_H.j == i,:).aj;
            bj = Gamma_H(Gamma_H.j == i,:).bj;
            cj = Gamma_H(Gamma_H.j == i,:).cj;

            sumCoef = sumCoef + (aj * exp(-power((log10(fc)-bj)/cj,2)));

        end

        sumCoef = sumCoef + (mk*log10(fc)) + ck;
        Gamma = 10 ^ sumCoef;

    elseif (strcmp(polarization, 'V'))
                
        load 'Gamma_V.mat';
        mk = -0.16398;
        ck = 0.63297;     

        sumCoef = 0;
        for i=1:length(Gamma_V.j)

            aj = Gamma_V(Gamma_V.j == i,:).aj;
            bj = Gamma_V(Gamma_V.j == i,:).bj;
            cj = Gamma_V(Gamma_V.j == i,:).cj;

            sumCoef = sumCoef + (aj * exp(-power((log10(fc)-bj)/cj,2)));

        end
        
        sumCoef = sumCoef + (mk*log10(fc)) + ck;
        Gamma = 10 ^ sumCoef;        

    end

end
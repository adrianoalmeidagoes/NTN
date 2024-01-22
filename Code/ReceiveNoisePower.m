
%**************************************************************************
% Calculate Received Noise Power in dBW  
% Parameters:
%       BandwidthInHz: Bandwidth in Hz
%       TemperatureInKelvin: Receiver temperature in Kelvin
%       FigureNoiseIndB: Receiver noise figure in dB
% Results:
%       N0: Noise Power in dBm
%**************************************************************************

function N0 = ReceiveNoisePower(BandwidthInHz, TemperatureInKelvin)

    k = physconst('Boltzmann');

    N0 = 10*log10(k*TemperatureInKelvin*BandwidthInHz);

end


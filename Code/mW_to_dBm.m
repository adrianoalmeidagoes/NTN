function P_dBm = mW_to_dBm(P_mW)
    % Convert power from milliwatts to dBm
    P_dBm = 10 * log10(P_mW);
end


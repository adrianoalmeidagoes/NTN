function P_mW = dBm_to_mW(P_dBm)
    % Convert power from dBm to milliwatts
    P_mW = 10.^(P_dBm / 10);
end

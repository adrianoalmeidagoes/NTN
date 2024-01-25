%**************************************************************************
% Calculate the Calculate the mean usage of a network with a max bandwidth
% Parameters:
%       numUsers: number of user to serve
%       maxBandwidth_Mbps: Max bandwith that can serve in that area
% Results:
%       R: Value of mean bit rate per user. 
%**************************************************************************



function [R_averageNetworkUsage] =  Calculate_MeanR (numUsers,maxBandwidth_Mbps)
% Number of simulation time periods
numTimePeriods = 24; % for example, 24 hours in a day

% Initialize total network usage
totalNetworkUsage = 0;

% Simulate network usage for each user
for user = 1:numUsers
    
    % Randomly assign bandwidth based on user profile (percentage of max bandwidth)
    bandwidthPercentage = rand(); % Random value between 0 and 1
    userBandwidth = maxBandwidth_Mbps * bandwidthPercentage;
    
    % Simulate usage for each time period
    for timePeriod = 1:numTimePeriods
        % Simulate random usage (adjust this based on your usage patterns)
        usage = rand() * userBandwidth; % Random value between 0 and user's bandwidth
        
        % Accumulate total network usage
        totalNetworkUsage = totalNetworkUsage + usage;
    end
end

% Calculate average network usage per user
R_averageNetworkUsage = totalNetworkUsage / (numUsers * numTimePeriods);


% Display the result
% fprintf('Average Network Usage per User: %.2f Mbps\n', R_averageNetworkUsage);

end
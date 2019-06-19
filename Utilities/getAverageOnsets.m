function [avgOnsets] = getAverageOnsets(onsets)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
sumOnsets = 0;
for i = 1:length(onsets)
    sumOnsets = sumOnsets + length(onsets{i});
    
end
avgOnsets = sumOnsets / length(onsets);
end


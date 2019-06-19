function [estimateValue, val] = diastolicAverageMin(signal, systolicIndex)
[~, index] = min(signal(systolicIndex:end));
val = index(1) + systolicIndex - 1;
%If min index is not first or last value
if val < length(signal) && val > 1
    estimateValue = (signal(val-1) + signal(val) + signal(val+1))/3;
%If min index is last value
elseif val > 1
    estimateValue = (signal(val-2) + signal(val-1) + signal(val)) /3;
%If min index is first value
elseif val == 1
    estimateValue = (signal(val) + signal(val+1) +signal(val+2)) /3;
end
end


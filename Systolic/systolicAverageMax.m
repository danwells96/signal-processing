function [estimateValue, val] = systolicAverageMax(signal)
%#codegen
[~, index] = max(signal);
val = index(1);
estimateValue = signal(val);
%If max index is not first or last value
if val < length(signal) && val > 1
    estimateValue = (signal(val-1) + signal(val) + signal(val+1))/3;
%If max index is last value
elseif val > 1
    estimateValue = (signal(val-2) + signal(val-1) + signal(val)) /3;
%If max index is first value
elseif val == 1
    estimateValue = (signal(val) + signal(val+1) +signal(val+2)) /3;
end
end


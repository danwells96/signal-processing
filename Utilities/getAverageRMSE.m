function [getAverageRMSE, s] = getAverageRMSE(errors, algorithm)
cumulative = 0;
cumulativeStd = 0;
for i = 1:size(errors, 2)
    values = 0;
    sum = 0;
    recordErrors = errors{i};
    for j = 1:size(recordErrors{algorithm})
        if isnan(recordErrors{algorithm}(j)) ~= 1
            sum = sum + recordErrors{algorithm}(j);
            values = values + 1;            
        end
    end
    cumulative = cumulative + (sum / values);
    cumulativeStd = cumulativeStd + getStd(recordErrors{algorithm});
end
getAverageRMSE = cumulative / (i);
s = cumulativeStd / i;
end
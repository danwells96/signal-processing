clear
clc

matFiles = dir('*.mat');

systolicErrors = {};
diastolicErrors = {};
meanErrors = {};
pressureChangeErrors = {};
dicroticNotchErrors = {};
dicroticPeakErrors = {};
heartRateErrors = {};
noisySignal = {};

onsets = {};

isBeatAbnormal = {};

% LPF
cutoff = 7;
[b, a] = butter(1, cutoff/(125/2), 'low');

none=0;
white=1;
pink=2;
red=3;

noiseType=white;
SNR = 10;

for i = 1:length(matFiles)
    
    load(matFiles(i).name);
    
    % Check if signal is clean
    if ~any(~isnan(signals{1}(:)))
        continue
    end
    
    signals{1}(isnan(signals{1})) = 0;
    
    S = signals{1};
    
    Ps = 10*log10(std(S).^2);
    Pn = Ps - SNR;
    Pn = 10^(Pn/10);
    sigma = sqrt(Pn);
        
    if noiseType == 1
        %Add Gaussian White Noise to signal
        
        L = length(S);
        whiteNoise = randn(L, 1);
        noisySignal = S + sigma*whiteNoise;
    elseif noiseType == 2 
        %Add Pink Noise to the signal
        fs = 125;
        T = 500;
        N = round(fs*T);
        t = (0:N-1)/fs;

        noisySignal = zeros(750000, 1);
        %Split data into 12 groups due to array size in generating noise
        for k = 0:11
            if k < 11
                noise = sigma*pinknoise(N, 1);
                noisySignal((k*N)+1:(k+1)*N, 1) = S((k*N)+1:(k+1)*N, 1) + noise;
            else
                noise = sigma*pinknoise(N, 1);
                noisySignal((k*N)+1:(k+1)*N, 1) = S((k*N)+1:end-1, 1) + noise;
            end
        end
    elseif noiseType == 3
        %Add Red (Brownian) Noise
        fs = 125;
        T = 500;
        N = round(fs*T);
        t = (0:N-1)/fs;
    
        noisySignal = zeros(750000, 1);
        for k = 0:11
            if k < 11
                noise = sigma*rednoise(N, 1);
                noisySignal((k*N)+1:(k+1)*N, 1) = S((k*N)+1:(k+1)*N, 1) + noise;
            else
                noise = sigma*rednoise(N, 1);
                noisySignal((k*N)+1:(k+1)*N, 1) = S((k*N)+1:end-1, 1) + noise;
            end
        end
    elseif noiseType == 0
        noisySignal = S;
    end
    
    % Filter signal
    filteredSignal = filter(b, a, noisySignal);
    
    % Detect beats
    for j = round(logspace(log10(1), log10(length(signals{1})-7500), 10))
        
        onsets{i} = wabp(filteredSignal(j:end));
        
        if ~isempty(onsets{i})
            break
        end
        
    end
    
    onsets{i} = onsets{i} + j - 1;
    
    % Extract features
    
    systolicEstimates = {};
    diastolicEstimates = {};
    meanEstimates = {};
    pressureChangeEstimates = {};
    dicroticNotchEstimates = {};
    dicroticPeakEstimates = {};
    heartRateEstimates = {};
    
    case1 = 0;
    case2 = 0;
    case3 = 0;
        
    for j = 1:length(onsets{i})-1
        
        signal = filteredSignal(onsets{i}(j):onsets{i}(j+1));
        
        % SYSTOLIC PRESSURE (index)
        
        % Max
        %systolicEstimates{1}(j) = systolicMax(signal);
        
        [systolicEstimates{2}(j), systolicEstimates{1}(j)] = systolicAverageMax(signal);
        
        % Inflexion + zero-point crossing
        %systolicEstimates{2}(j) = systolicInflexion(signal);
        
        % Find peaks
        %systolicEstimates{3}(j) = systolicFindPeaks(signal);
        
        % AMPD
        %systolicEstimates{4}(j) = systolicAMPD(signal);
        
        % DIASTOLIC PRESSURE (index)
        
        % Min
        %diastolicEstimates{1}(j) = diastolicMin(signal, systolicEstimates{1}(j));
        
        [diastolicEstimates{2}(j), diastolicEstimates{1}(j)] = diastolicAverageMin(signal, systolicEstimates{1}(j));
        
        % Waveform end
        %diastolicEstimates{2}(j) = length(signal);
        
        % MEAN PRESSURE
        
        % One third, two thirds
        %meanEstimates{1}(j) = meanOneThirdTwoThirds(signal(systolicEstimates{1}(j)), signal(diastolicEstimates{1}(j)));
        meanEstimates{1}(j) = meanOneThirdTwoThirds(systolicEstimates{2}(j), diastolicEstimates{2}(j));

        % Integral
        %meanEstimates{2}(j) = meanIntegral(signal, signals{6}(onsets{i}(j):onsets{i}(j+1)), diastolicEstimates{1}(j));
        
        % MAX DP/DT
        
        pressureChangeEstimates{1}(j) = (signal(systolicEstimates{1}(j)) - signal(1))/(systolicEstimates{1}(j)/signals{8});
        
        % DICROTIC NOTCH (index)
        
        % Maximum of difference between straight line between systole and
        % diastole and signal
        %dicroticNotchEstimates{1}(j) = notchStraightLineMax(signal, systolicEstimates{2}(j), diastolicEstimates{1}(j));
        
        % Inflexion + zero-point crossing after systole
        dicroticNotchEstimates{1}(j) = notchInflexion(signal, systolicEstimates{1}(j));
        
        % DICROTIC PEAK (index)
        
        % Minimum of difference between straight line between systole and
        % diastole and signal
        %dicroticPeakEstimates{1}(j) = peakStraightLineMin(signal, systolicEstimates{2}(j), diastolicEstimates{1}(j), dicroticNotchEstimates{1}(j));
        
        % Local maximum following dicrotic notch
        dicroticPeakEstimates{1}(j) = peakMax(signal, dicroticNotchEstimates{1}(j));
        
        % HEART RATE
        
        % Whole Signal
        heartRateEstimates{1}(j) = 60/(length(signal)/signals{8});
        
        % Signal Until Diastole
        %heartRateEstimates{2}(j) = 60/(diastolicEstimates{1}(j)/signals{8});
        
        % Restore values from indices
        systolicEstimates{1}(j) = signal(systolicEstimates{1}(j));
%         val = systolicEstimates{2}(j);
%         
%         if val < length(signal) && val > 1
%             systolicEstimates{2}(j) = (signal(val-1) + signal(val) + signal(val+1))/3;
%             case1 = case1 + 1;
%         elseif val > 1
%             systolicEstimates{2}(j) = (signal(val) + signal(val-1) + signal(val-2))/3;
%             case2 = case2 + 1;
%         elseif val == 1
%             systolicEstimates{2}(j) = (signal(val) + signal(val+1) + signal(val+2))/3;
%             case3 = case3 + 1;
%         end
        %systolicEstimates{2}(j) = signal(systolicEstimates{2}(j));
        %systolicEstimates{3}(j) = signal(systolicEstimates{3}(j));
        %systolicEstimates{4}(j) = signal(systolicEstimates{4}(j));
        diastolicEstimates{1}(j) = signal(diastolicEstimates{1}(j));
        %diastolicEstimates{2}(j) = signal(diastolicEstimates{2}(j));
        dicroticNotchEstimates{1}(j) = signal(dicroticNotchEstimates{1}(j));
        %dicroticNotchEstimates{2}(j) = signal(dicroticNotchEstimates{2}(j));
        dicroticPeakEstimates{1}(j) = signal(dicroticPeakEstimates{1}(j));
        %dicroticPeakEstimates{2}(j) = signal(dicroticPeakEstimates{2}(j));
        
    end
    
    % Average estimates over 60 second periods
    
    systolicAverageEstimates = {};
    diastolicAverageEstimates = {};
    meanAverageEstimates = {};
    pressureChangeAverageEstimates = {};
    dicroticNotchAverageEstimates = {};
    dicroticPeakAverageEstimates = {};
    heartRateAverageEstimates = {};
    
    for j = 1:size(systolicEstimates, 2)
        systolicAverageEstimates{j} = averageEstimates(systolicEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(diastolicEstimates, 2)
        diastolicAverageEstimates{j} = averageEstimates(diastolicEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(meanEstimates, 2)
        meanAverageEstimates{j} = averageEstimates(meanEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(pressureChangeEstimates, 2)
        pressureChangeAverageEstimates{j} = averageEstimates(pressureChangeEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(dicroticNotchEstimates, 2)
        dicroticNotchAverageEstimates{j} = averageEstimates(dicroticNotchEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(dicroticPeakEstimates, 2)
        dicroticPeakAverageEstimates{j} = averageEstimates(dicroticPeakEstimates{1, j}, signals{6}, onsets{i});
    end
    
    for j = 1:size(heartRateEstimates, 2)
        heartRateAverageEstimates{j} = averageEstimates(heartRateEstimates{1, j}, signals{6}, onsets{i});
    end
    
    % Compare estimates to ground truth
    
    for j = 1:size(systolicEstimates, 2)
        systolicErrors{i}{j} = getRMSE(systolicAverageEstimates{1,j}(:,1), signals{2}(2:end));
    end
    
    for j = 1:size(diastolicEstimates, 2)
        diastolicErrors{i}{j} = getRMSE(diastolicAverageEstimates{1,j}(:,1), signals{3}(2:end));
    end
    
    for j = 1:size(meanEstimates, 2)
        meanErrors{i}{j} = getRMSE(meanAverageEstimates{1,j}(:,1), signals{4}(2:end));
    end
    
    for j = 1:size(pressureChangeEstimates, 2)
        pressureChangeErrors{i}{j} = getRMSE(pressureChangeAverageEstimates{1,j}(:,1), (signals{2}(2:end) - signals{3}(1:end-1))/0.03);
    end
    
    for j = 1:size(dicroticNotchEstimates, 2)
        dicroticNotchErrors{i}{j} = getRMSE(dicroticNotchAverageEstimates{1,j}(:,1), diastolicAverageEstimates{1,1}(:,1));
    end
    
    for j = 1:size(dicroticPeakEstimates, 2)
        dicroticPeakErrors{i}{j} = getRMSE(dicroticPeakAverageEstimates{1,j}(:,1), systolicAverageEstimates{1,1}(:,1));
    end
    
    for j = 1:size(heartRateEstimates, 2)
        heartRateErrors{i}{j} = getRMSE(heartRateAverageEstimates{1,j}(:,1), signals{5}(2:end));
    end
    
    % Check if beat is abnormal
%     for j = 1:length(onsets{i})-1
%         if(j-1 > 0)
%             previousSystolicPressure = systolicEstimates{1,2}(j-1);
%             previousDiastolicPressure = diastolicEstimates{1,2}(j-1);
%             previousMeanPressure = meanEstimates{1,1}(j-1);
%         else
%             previousSystolicPressure = systolicEstimates{1,2}(1);
%             previousDiastolicPressure = diastolicEstimates{1,1}(1);
%             previousMeanPressure = meanEstimates{1,1}(1);
%         end
%         
%         isBeatAbnormal{i}(j) = abnormalityDetection(systolicEstimates{1,2}(j), previousSystolicPressure, ...
%             diastolicEstimates{1,1}(j), previousDiastolicPressure, ...
%             meanEstimates{1,1}(j), previousMeanPressure, ...
%             heartRateEstimates{1,1}(j), pressureChangeEstimates{1,1}(j), ...
%             dicroticNotchEstimates{1,2}(j), dicroticPeakEstimates{1,2}(j));
%     end
    
end
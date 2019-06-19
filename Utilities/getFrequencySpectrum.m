%function getFrequencySpectrum()

clear, clc

matFiles = dir('*.mat');
load(matFiles(37).name);

if ~any(~isnan(signals{1}(:)))
        return
end
    
signals{1}(isnan(signals{1})) = 0;
   %Old stuff 
Fs = 250;
T = 1/Fs;
L = length(signals{1}) - mod(length(signals{1}), 2);
t = (0:L-1)*T;
%ends

fs = 125;
T = 500;
N = round(fs*T);
t = (0:(N*12)-1)/fs;


S = signals{1};

whitenoise = randn(1, L);
whitefft = fft(whitenoise);
lw = length(whitenoise);
P2 = abs(whitefft/lw);
P1 = P2(1:lw/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(lw/2))/lw;
figure(10);
plot(f, P1);
title('fft white noise');
xlabel('Frequency (Hz)');
ylabel('|P(f)|');
%export_fig whitespectrum.png;



%Pink Noise generation
SNR = 1;
Ps = 10*log10(std(S).^2);
Pn = Ps - SNR;
Pn = 10^(Pn/10);
sigma = sqrt(Pn);

pnoise = sigma*pinknoise(1,N);
pinknoisefft = fft(pnoise);

lp = length(pnoise);
P2 = abs(pinknoisefft/lp);
P1 = P2(1:lp/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(lp/2))/lp;
figure(8);
plot(f, P1);
title('fft pink noise');
xlabel('Frequency (Hz)');
ylabel('|P(f)|');
%export_fig testpink.png;

noisyS = zeros(750000, 1);
for i = 0:11
    if i < 11
        noise = sigma*pinknoise(1, N);
        noiseReshaped = reshape(noise, [N, 1]);
        noisyS((i*N)+1:(i+1)*N) = S((i*N)+1:(i+1)*N) + noiseReshaped;
    else
        noise = sigma*pinknoise(1,N);
        noiseReshaped = reshape(noise, [N, 1]);
        noisyS((i*N)+1:(i+1)*N) = S((i*N)+1:end-1) + noiseReshaped;
    end
end

rnoise = sigma*rednoise(1, N);
rednoisefft = fft(rnoise);
lr = length(rnoise);
P2 = abs(rednoisefft/lr);
P1 = P2(1:lr/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(lr/2))/lr;
figure(9);
plot(f, P1);
title('fft brownian noise');
xlabel('Frequency (Hz)');
ylabel('|P(f)|');
%export_fig browniannoise.png;

% noisyS = S;
% for i = 0:11
%     noise = sigma*rednoise(1, N);
%     shape = size(noise);
%     noiseReshaped = reshape(noise, [N 1]);
%     
%     if i < 11
%         noisyS((i*N)+1:(i+1)*N) = S((i*N)+1:(i+1)*N) + noiseReshaped;
%     else
%         noisyS((i*N)+1:(i+1)*N) = S((i*N)+1:end-1) + noiseReshaped;
%     end
% end
        
    
figure(5);
plot(t(95500:96000), noisyS(95500:96000));
title('Noisy Signal Unfiltered');
xlabel('Time (s)');
ylabel('Pressure (mmHg)');

figure(1);
plot(t(95500:96000), S(95500:96000));
title('Original Signal');
xlabel('Time (s)');
ylabel('Pressure (mmHg)');

% d = fdesign.lowpass('Fp,Fst,Ap,Ast',1,25,0.1,20,50);
% Hd = design(d, 'cheby1');
% output = filter(Hd, S);
% noisyOutput = filter(Hd, noisyS);

cutoff = 7;
[b, a] = butter(1, cutoff/(125/2), 'low');
noisyOutput = filter(b, a, noisyS);
output = filter(b, a, S);

cutoff = 25;
[b, a] = butter(1, cutoff/(125/2), 'low');
originalFilter = filter(b, a, noisyS);

cutoff = 3;
[b, a] = butter(1, cutoff/(125/2), 'low');
lowFilter = filter(b, a, noisyS);

figure(3);
plot(t(95500:96000), output(95500:96000));
title('Filtered Original Signal (cut-off=7Hz)');

figure(6);
plot(t(95500:96000), noisyOutput(95500:96000));
title('Filtered Noisy Signal (cut-off=7Hz)');
xlabel('Time (s)');
ylabel('Pressure (mmHg)');

figure(12);
plot(t(95500:96000), originalFilter(95500:96000));
title('Filtered Noisy Signal (cut-off=25Hz)');
xlabel('Time (s)');
ylabel('Pressure (mmHg)');

figure(13);
plot(t(95500:96000), lowFilter(95500:96000));
title('Filtered Noisy Signal (cut-off=3Hz)');
xlabel('Time (s)');
ylabel('Pressure (mmHg)');

%FFT of unfiltered signal
X = fft(S);
P2 = abs(X/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
figure(2);
plot(f, P1);
title('fft noisy Signal');

%FFT of filtered signal
Y = fft(noisyOutput);
P4 = abs(X/length(signals{1}));
P3 = P4(1:L/2+1);
P3(2:end-1) = 2*P3(2:end-1);
f = Fs*(0:(L/2))/L;
figure(4);
plot(f, P3);
title('fft noisySignal post filter');

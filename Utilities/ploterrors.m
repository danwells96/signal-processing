
%Expand to 20Hz in frequency for better graph
frequencies = [2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20];
noiseErrors = [6.2232; 5.5704; 5.6541; 5.9832; 6.3584; 6.7283; 7.0725; 7.3957; 7.6909; 7.9760; 8.2440; 8.5023; 8.7468; 8.9819; 9.2129; 9.4319; 9.6568; 9.8653; 10.0731];
noiselessErrors = [7.1504; 5.8696; 5.3158; 5.0212; 4.8534; 4.7481; 4.6832; 4.6441; 4.6308; 4.6217; 4.6166; 4.6158; 4.6150; 4.6210; 4.6190; 4.6254; 4.6317; 4.6405; 4.6466];

maxNoiselessError = max(noiselessErrors);
maxNoiseError = max(noiseErrors);
maxError = max(maxNoiseError, maxNoiselessError);

scaledNoiselessErrors = noiselessErrors/maxNoiselessError;

scaledNoiseErrors = noiseErrors/maxNoiseError;

f = fit(frequencies, scaledNoiselessErrors, 'cubicinterp');
fn = fit(frequencies, scaledNoiseErrors, 'cubicinterp');

figure(1);
plot(f, frequencies, scaledNoiselessErrors);
hold on
plot(fn, frequencies, scaledNoiseErrors);
hold off

figure(2);
plot(frequencies, noiseErrors);
hold on
plot(frequencies, noiselessErrors);
hold off
function v = eegfft(data, f)

%load eegtestout2.mat

%data = data/22000;
Fs = f;
[B, A] = butter(3, [7 13]/(Fs/2), 'bandpass');

fdata = filtfilt(B, A, data);


subplot(2,1,1)
%plot(time, data)
plot(data)

subplot(2,1,2)
%plot(time, fdata, 'r')
plot(data, 'r')

freq = Fs*(0:8191)/8192;
tmp = data((1:8192),1);
tmp = tmp - mean(tmp);

P = abs(fft(hanning(8192).*tmp));

figure
plot(freq, P)
set(gca, 'FontSize', 16)

xlim([0 100])

end


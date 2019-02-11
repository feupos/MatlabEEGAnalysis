function v = eeg_erd_ers(signal, fs, tb, te, fb, fe)

ts = te-tb;
n = ts*fs;

t = ts*[1:n]/n;

data = signal(:,1+tb*fs:te*fs);
wo = 50/(fs/2);  bw = wo/35;
[B,A] = iirnotch(wo,bw);
% [B, A] = butter(3, [1 20]/(fs/2), 'bandpass');
data = filtfilt(B, A, data);

figure
plot(t,data);

data = data - mean(data);
[B, A] = butter(4, [fb fe]/(fs/2), 'bandpass');
data = filtfilt(B, A, data);


figure
plot(t,data);

p = data.^2;

figure
plot(t,p);

% [B, A] = butter(5, 0.2/(fs/2), 'low');
% p = filtfilt(B, A, p);
% 
% figure
% plot(t,p);

end
function real_time_spectrum()

comPort = 'COM3';

step = 600;

fs = 600;


v = zeros(1,600*10);
i = 1;
a = zeros(1,600*10);
temp = zeros(1,600*10);

delete(instrfindall);
% Open serial connection with Arduino
s = serial(comPort);
set(s,'DataBits',8);
set(s,'StopBits',1);
set(s,'BaudRate',115200);
set(s,'Parity','none');
fclose(s);
fopen(s);



%signal = serialRead('COM3',10);
while (i <=600*10)

        a(1,1) = fread(s,1,'uint8');
        a(1,2) = fread(s,1,'uint8');
        b = a(1,1) + bitshift(a(1,2),8);
        b = typecast(uint16(b),'int16');
        v(1,i) = b;
        i = i+1;
        %fprintf('.');
        %axis([1 500 0 60000]);
        %plot(temp);
        %drawnow
end
        signal = gpuArray(v);


%[B, A] = butter(3, [1 30]/(fs/2), 'bandpass');
%signal = filtfilt(B, A, signal);
wo = 50/(fs/2);  bw = wo/35;
[B,A] = iirnotch(wo,bw);
signal = filter(B, A, signal);
%data = signal(:,1+tb*fs:te*fs);
%signal = signal - mean(signal);
n = norm(signal,Inf);
signal = signal/n;


%dialogBox = uicontrol('Style', 'PushButton', 'String', 'Break','Callback', 'delete(gcbf)');
%while (ishandle(dialogBox))
%while(1)
    
    clf
    subplot(2,1,1)
    plot(signal)
    xlim([5400 6000])
     subplot(2,1,2)
     vec = zeros(10,600,'gpuArray');
     for i = 1:10
         ts = 1;
         n=600;
         data = signal(1,1+600*(i-1):600+600*(i-1));    
         
          data = hanning(n)'.*data;
          data=data/norm(data,Inf);        
         
         t = ts*[1:n]/n;
         
         p = abs(fft(data,n));
         p = fftshift(p);
         p = p.*conj(p)/600;
         f = [-n/2:n/2-1]/n*fs;
         
         vec(i,:) = p;
         
     end
     
     pcolor(f, [1 2 3 4 5 6 7 8 9 10], vec)
     %ylim([0 20])
     drawnow;
     
     
     %new_signal = serialRead('COM3',1);
     v = zeros(1,step);
     i = 1;
     a = zeros(1,step);
     temp = zeros(1,step);
     
     while (i <= step)

        a(1,1) = fread(s,1,'uint8');
        a(1,2) = fread(s,1,'uint8');
        b = a(1,1) + bitshift(a(1,2),8);
        b = typecast(uint16(b),'int16');
        v(1,i) = b;
        i = i+1;
        %fprintf('.');
        %axis([1 500 0 60000]);
        %plot(temp);
        %drawnow
     end
        
        new_signal=gpuArray(v);
    
%     [B, A] = butter(3, [1 30]/(fs/2), 'bandpass');
%     new_signal = filtfilt(B, A, new_signal);
    wo = 50/(fs/2);  bw = wo/35;
    [B,A] = iirnotch(wo,bw);
    new_signal = filter(B, A, new_signal);
    %data = signal(:,1+tb*fs:te*fs);
    new_signal = new_signal - mean(new_signal);
    new_signal = new_signal/n;
    
    signal(:,1:6000-step) = signal(:,step+1:6000);
    signal(:,6000-step+1:6000) = new_signal;
    
    
    
    
    
    
%end

end


figure(1);
hold on;

for i = 601:20:1800;
   clf;
   %plot(testsample(i-600:i));
   %spectrogram(testsample(i-600:i),'yaxis')
%    Nx = length(x);
%     nsc = floor(Nx/4.5);
%     nov = floor(nsc/2);
%     nff = max(256,2^nextpow2(nsc));

    %spectrogram(x,600,'yaxis');
    spectrogram(x(:,i-600:i),200,0,2048,600,'yaxis');
    ylim([0 60])
   drawnow;
   pause(0.03333334);
end;

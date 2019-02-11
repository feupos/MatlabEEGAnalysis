
function v = serialRead(comPort,t)

v = zeros(1,600*t);

i = 1;
a = zeros(1,600*t);
temp = zeros(1,600*t);


try
    delete(instrfindall);
    % Open serial connection with Arduino
    s = serial(comPort);
    set(s,'DataBits',8);
    set(s,'StopBits',1);
    set(s,'BaudRate',115200);
    set(s,'Parity','none');
    fclose(s);
    fopen(s);
    
    fwrite(s,t,'int16');
    
    tic
    
    
    while (i <=600*t)

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
    
    toc
  

catch ERROR
    mbox = msgbox({'Error! (-_-")','',ERROR.identifier,'',ERROR.message},'Error','error');
    uiwait(mbox);
    fclose(s);
    delete(s);    
end


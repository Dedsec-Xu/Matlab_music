if(toc > gate)
    sound(yp((counter-1)*fs+1:counter*fs,1:2),fs);
    tic
    set(handles.slider3,'value',counter);        
    counter = counter + 1;

    if(Select == 2)
        y(counter*fs+1:(counter+1)*fs,1) = frefilter(y(counter*fs+1:(counter+1)*fs,1)',fs,weightCoe);
        y(counter*fs+1:(counter+1)*fs,2) = frefilter(y(counter*fs+1:(counter+1)*fs,2)',fs,weightCoe); 
        yp=y.*volume;
    end

    if(Select == 1) 
        y(counter*fs+1:(counter+1)*fs,1) = timefilter(y(counter*fs+1:(counter+1)*fs,1),fs,weightCoe);
        y(counter*fs+1:(counter+1)*fs,2) = timefilter(y(counter*fs+1:(counter+1)*fs,2),fs,weightCoe); 
        yp=y.*volume;
    end
    if(Select == 0) 
        yp=y.*volume;
    end
end
function z = kaiserfilter(data, lows1, lowp1, highp2, highs2, fs)
%lows1表示阻带边缘下限频率,highs2表示阻带边缘上限频率
%lowp1表示通带边缘下限频率,highp2表示通带边缘上限频率
%fs采样频率
%data滤波数据
    %lows1=6615;lowp1=9922;highp2=14333;highs2=17640;fs=44100;%此行为测试
    f=[lows1,lowp1,highp2,highs2];
    %f=[0.3,0.45,0.65,0.8];
    a=[0,1,0];
    dev=[0.01,0.1087,0.01];
    [n,wn,beta,ftype]=kaiserord(f,a,dev,fs);
    h1=fir1(n,wn,ftype,kaiser(n+1,beta),'noscale');
    z=filter(h1,1,data);
    %[hh1,w1]=freqz(h1,1,256);
    %plot(w1/pi,20*log10(abs(hh1)));
end
function z = kaiserfilter(data, lows1, lowp1, highp2, highs2, fs)
%lows1��ʾ�����Ե����Ƶ��,highs2��ʾ�����Ե����Ƶ��
%lowp1��ʾͨ����Ե����Ƶ��,highp2��ʾͨ����Ե����Ƶ��
%fs����Ƶ��
%data�˲�����
    %lows1=6615;lowp1=9922;highp2=14333;highs2=17640;fs=44100;%����Ϊ����
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
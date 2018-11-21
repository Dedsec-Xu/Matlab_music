function yy=frefilter(y0,fs,k)   %y0为传入的声音采样矩阵，wn为通带频率集,fs为采样率,k为对应的加权系数集
%注：采样点个数最好为fs的倍数
wn=[30 60 100 200 500 1000 2000 4000 8000 16000 20000];
y=fft(y0);      %fft变换
num=length(k);  %权值个数
s=length(y);    %采样点个数
yy=zeros(1,s);
for i=1:num
w=wn(i):wn(i+1);
n=floor(s*w/fs);
no=hamming(length(n))';
y(n)=no.*y(n);
yy(n)=k(i)*y(n);
end
yy=real(ifft(yy));
%yy=yy./max(yy);
end
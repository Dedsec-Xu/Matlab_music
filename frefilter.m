function yy=frefilter(y0,fs,k)   %y0Ϊ�����������������wnΪͨ��Ƶ�ʼ�,fsΪ������,kΪ��Ӧ�ļ�Ȩϵ����
%ע��������������Ϊfs�ı���
wn=[30 60 100 200 500 1000 2000 4000 8000 16000 20000];
y=fft(y0);      %fft�任
num=length(k);  %Ȩֵ����
s=length(y);    %���������
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
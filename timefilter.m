function z = timefilter(data, fs, coeff)
    ls1=30;lp1=35;hp1=55;hs1=60;
    y1=kaiserfilter(data,ls1,lp1,hp1,hs1,fs);
    ls2=60;lp2=65;hp2=95;hs2=100;
    y2=kaiserfilter(data,ls2,lp2,hp2,hs2,fs);
    ls3=100;lp3=110;hp3=190;hs3=200;
    y3=kaiserfilter(data,ls3,lp3,hp3,hs3,fs);
    ls4=200;lp4=230;hp4=470;hs4=500;
    y4=kaiserfilter(data,ls4,lp4,hp4,hs4,fs);
    ls5=500;lp5=600;hp5=900;hs5=1000;
    y5=kaiserfilter(data,ls5,lp5,hp5,hs5,fs);
    ls6=1000;lp6=1200;hp6=1800;hs6=2000;
    y6=kaiserfilter(data,ls6,lp6,hp6,hs6,fs);
    ls7=2000;lp7=2400;hp7=3600;hs7=4000;
    y7=kaiserfilter(data,ls7,lp7,hp7,hs7,fs);
    ls8=4000;lp8=4800;hp8=7200;hs8=8000;
    y8=kaiserfilter(data,ls8,lp8,hp8,hs8,fs);
    ls9=8000;lp9=10000;hp9=14000;hs9=16000;
    y9=kaiserfilter(data,ls9,lp9,hp9,hs9,fs);
    ls10=16000;lp10=18000;hp10=18000;hs10=20000;
    y10=kaiserfilter(data,ls10,lp10,hp10,hs10,fs);
    
    y1=y1*coeff(1);
    y2=y2*coeff(2);
    y3=y3*coeff(3);
    y4=y4*coeff(4);
    y5=y5*coeff(5);
    y6=y6*coeff(6);
    y7=y7*coeff(7);
    y8=y8*coeff(8);
    y9=y9*coeff(9);
    y10=y10*coeff(10);
    
    
    z=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;
end
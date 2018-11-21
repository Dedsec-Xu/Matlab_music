function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 02-May-2018 20:04:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)
ImageFile  = 'material\WEL.jpg';
ScreenSize = get(0,'ScreenSize');
jImage     = im2java(imread(ImageFile));
jfBounds   = num2cell([...
    (ScreenSize(3)-jImage.getWidth)/2 ...
    (ScreenSize(4)-jImage.getHeight)/2 ...
    jImage.getWidth ...
    jImage.getHeight]);
jFrame     = javax.swing.JFrame;
icon       = javax.swing.ImageIcon(jImage);
label      = javax.swing.JLabel(icon);
jFrame.getContentPane.add(label);
jFrame.setUndecorated(true)
jFrame.setBounds(jfBounds{:});
jFrame.pack
jFrame.show
pause(2)
jFrame.dispose
% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global n stp  y counter fs weightCoe  Select fpath   i  m a b volume fig;
Select = 0;
counter = 1;
n=10;m=0;
stp=0;i=1;
weightCoe=ones(1,10);
fs=44100;
volume=0.25;
fig = handles.figure1;
folder = fileparts(mfilename('fullpath'));
nimbus_laf = 'com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel';
javax.swing.UIManager.setLookAndFeel(nimbus_laf);
h = handles.figure1; %创建一个Figure，并返回其句柄
newIcon = javax.swing.ImageIcon('material\mainicon.png')
figFrame = get(h,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标
ha=axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'down')
II=imread('material\BG.jpg');
image(II)
colormap gray
set(ha,'handlevisibility','off','visible','off');

set(handles.Album,'visible','off');

II=imread('material\buttons\playbutton.jpg');
set(handles.playbutton,'cdata',II);

II=imread('material\buttons\musicname.jpg');
set(handles.musicname,'cdata',II);


II=imread('material\buttons\stopbutton.jpg');
set(handles.stopbutton,'cdata',II);


II=imread('material\buttons\load30.jpg');
set(handles.loadbutton,'cdata',II);


II=imread('material\buttons\save30.jpg');
set(handles.savebutton,'cdata',II);


II=imread('material\buttons\pausebutton.jpg');
set(handles.pausebutton,'cdata',II);


II=imread('material\buttons\pianobutton.jpg');
set(handles.pianobutton,'cdata',II);


II=imread('material\buttons\equalizerbutton.jpg');
set(handles.equalizerbutton,'cdata',II);

II=imread('material\buttons\Stoptime.jpg');
set(handles.Stoptime,'cdata',II);


II=imread('material\buttons\Starttime.jpg');
set(handles.Starttime,'cdata',II);


set(handles.slider2,'min',0);
set(handles.slider2,'max',1);
set(handles.slider2,'value',0.5);
guidata(hObject, handles);

set(handles.axes2,'visible','off');







% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x  y stp counter w fs Select fpath  weightCoe a b i yp volume;
i=1;
stp = 1;
gate = 0.97;
widd = 3;
pointsss = 150;
ylimax = 30;
axes(handles.axes1);
axis off;
axes(handles.axes2);
axis off;
sound(yp((counter-1)*fs+1:counter*fs,1:2),fs);
tic
counter = counter + 1;

%yp=y.*volume;

while (counter <= floor(length(y)/fs)-1)
    if(stp == 0)
        break;
    end  
    
    
    str=ConvTime(counter-1);   %用自定义的函数将str定义为x分x秒
    
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
    
    set(handles.Starttime,'string',str);

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
    
    T2=clock;
    
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


        m=25;
        
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
        
        while (m)
            T1=clock;
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
            time=T1-T2;
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
            music_sincere = y((counter-1)*fs+1:counter*fs,1);
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
            s=3600*time(4)+60*time(5)+time(6);
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
            if(round(s*fs+pointsss)<length(music_sincere))
                ypt=music_sincere(round(s*fs)+1:round(s*fs+pointsss));
                
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
               
               set(handles.figure1,'CurrentAxes',handles.axes1);
               axis off;
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

                plot(handles.axes1,ypt,'w','Linewidth',widd);
                axis off;

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
               axis off;
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

                set(handles.axes1,'ylim',[-max(y((counter-1)*fs+1:counter*fs,1)) max(y((counter-1)*fs+1:counter*fs,1))],'xlim',[0 pointsss]); 
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

               set(handles.figure1,'CurrentAxes',handles.axes2);
               axis off;
                
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
                
                y1=fft(ypt,512);
                
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
    
                f=fs*(0:255)/512;
                
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
    
                bar(handles.axes2,f,abs(y1(1:256)),0.8,'w');
                axis off;
                
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
    
                 axis off;
                 
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
    
                set(handles.axes2,'ylim',[0 ylimax],'xlim',[0 5000]);
                
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
    
                drawnow;
                
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
    
            end
            m=m-1;
            
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
    
        end
    set(handles.slider3,'value',counter);
end

if(stp == 1)
    sound(yp((counter-1)*fs+1:length(y),1:2),fs);
end
%start(handles.timer1);
% --- Executes during object creation, after setting all properties.
function playbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 

% --- Executes on button press in pianobutton.
function pianobutton_Callback(hObject, eventdata, handles)
% hObject    handle to pianobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
yoghurt;

% --- Executes on button press in equalizerbutton.
function equalizerbutton_Callback(hObject, eventdata, handles)
% hObject    handle to equalizerbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x  y stp counter w fs Select fpath  weightCoe a b i ;
equalizer(hObject,handles);;


% --- Executes on button press in pausebutton.
function pausebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pausebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  stp x;
stp=0;
guidata(hObject,handles);

% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global n i stp x y fs  weightCoe w fpath   N step w1 w2 w3 w4 w5 a b yp volume counter ;
n=1;i=1;
%打开过程
[filename, pathname] = uigetfile('*.mp3', 'open');
handles.filename = filename;
handles.nfilename = filename(1:end-4);
handles.pathname = pathname;
handles.fullname = [pathname, filename];
set(handles.musicname,'String',handles.nfilename);
if exist(['music\album\',handles.nfilename,'.jpg']) > 0    
handles.Albump=imread(['music\album\',handles.nfilename,'.jpg']);
m = 265/max(size(handles.Albump));
handles.Albumpr = imresize(handles.Albump, m);
set(handles.Album,'cdata',handles.Albumpr);
set(handles.Album,'visible','on');
else
set(handles.Album,'visible','off');
end

fpath=[pathname filename];
[y,Fs]=audioread(fpath);
Max=length(y);

fs = Fs;
w = y;
x=audioplayer(w,fs);
stp=0;
%setappdata(handles.figure_main,'Max',Max); 
%setappdata(handles.figure_main,'fpath',fpath); 
set(handles.slider3,'min',1); 
set(handles.slider3,'max',fix(x.TotalSamples/fs)-1);    %最下方进度条（基本不可用）
str=ConvTime(fix(x.TotalSamples/fs));   %用自定义的函数将str定义为x分x秒
set(handles.Stoptime,'string',str);     %最下方进度条右方
step=fix(x.TotalSamples/fs/4);
set(handles.slider3,'value',1);
yp=y.*volume;
counter =1;

guidata(hObject, handles);



function str=ConvTime(sec)
a=fix(sec/60);
b=mod(sec,60);
if b<10
str=strcat('0',num2str(a),':','0',num2str(b));
else
str=strcat('0',num2str(a),':',num2str(b));
end



% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.mp3', 'save');
handles.sfilename = sfilename;
handles.spathname = spathname;
handles.sfullname = [spathname, sfilename];

guidata(hObject, handles);


% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x  y stp counter w fs Select fpath  weightCoe a b i;
counter=fix(length(y)/fs)-1;
playbutton_Callback(hObject, eventdata, handles);
stp=0;
counter=1;
%guidata(hObject,handles);

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global y yp volume;
volume=get(hObject,'value');
volume=volume*volume;
yp=y.*volume;


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global x n i N counter stp;
duty=get(hObject,'value');
counter=fix(duty);
%stop(x);
playbutton_Callback(hObject, eventdata, handles);
stp=0;

%guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes on button press in Album.
function Album_Callback(hObject, eventdata, handles)
% hObject    handle to Album (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pfilename, ppathname] = uiputfile('*.jpg', 'save album cover');
imwrite(handles.Albump,[ppathname, pfilename]);


% --- Executes on button press in Rtime.
function Rtime_Callback(hObject, eventdata, handles)
% hObject    handle to Rtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Stoptime.
function Stoptime_Callback(hObject, eventdata, handles)
% hObject    handle to Stoptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in musicname.
function musicname_Callback(hObject, eventdata, handles)
% hObject    handle to musicname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function musicname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to musicname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Starttime.
function Starttime_Callback(hObject, eventdata, handles)
% hObject    handle to Starttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global counter;
start=ConvTime(counter-1);
set(hObject,'string',start); 

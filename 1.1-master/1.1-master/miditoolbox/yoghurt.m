function varargout = sincere(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sincere_OpeningFcn, ...
                   'gui_OutputFcn',  @sincere_OutputFcn, ...
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

function sincere_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
ha=axes('units','normalized','pos',[0 0 1 1]);
 uistack(ha,'down');
 ii=imread('BG.jpg');
%beijing1.jpg
 image(ii);
 colormap gray
 set(ha,'handlevisibility','off','visible','off');

% Update handles structure
guidata(hObject, handles);


function varargout = sincere_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function playkey(KeyNum,hObject, eventdata, handles)
 [y,fs] = audioread('EOP.mp3');
sig = y(1:104417,1);
[n,wn] = buttord(1*2/fs,30*2/fs,1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);
saff = fft(sig_abs_filt,1024);
tt = 104417 / 44100;
nn = round(tt * fs);
x = [1:1:nn];
t = (0:nn-1)/fs;
y2(x) = sig_abs_filt(round(x*(104417-1)/nn) + 1);
%plot(t,sig,'b',t,sig_abs_filt,'r'),title('Ô­Ê¼ÐÅºÅ(À¶É«)Óë°üÂç£¨ºìÉ«£©');

%fs = 44100; %sample rate
music = [];
dt = 1/fs;
%double f;
double freq;
%T = 1;
%---------------------------generate botton frequence
    freq = 27.5 * (2^((KeyNum - 1)/12))/2;
%---------------------------the tone of piano
        Af = [freq*1,987.8
	 	      freq*2,368.6
			  freq*3,620.2
			  freq*4,483.9
			  freq*5,156.7
			  freq*6,83.62
			  freq*7,120.1
			  freq*8,70.73
			  freq*9,5.348
			  freq*10,24.41
			  freq*11,27.35
			  freq*12,21.3
			  freq*13,10.31
			  freq*14,6.477
			  freq*15,15.91
			  freq*16,3.495
			  freq*17,2.546
			  freq*18,0.4751
			  freq*19,0.8858
			  freq*20,0.3792
			  freq*21,0.6012
			  freq*22,0.4224
			  freq*23,0.1538
			  freq*24,0.4154
			  freq*25,0.2032];
%-------------------------generate envelope
	%t = [0:dt:T];
    large = size(t);
    tone = zeros(1,large(2));
    stren = Af(:,2)/max(Af(:,2));
    %mod = (10*t)./exp(10*t);
    %mod = mod / max(mod);
%-------------------------generate music
    for i=1:25
    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
    end
	NoteSound = y2.*tone;
    music = [music NoteSound];
music = music / max(music);
%plot(music);
sound(music,fs);


T2=clock;
pause(0.05);
m=1000;

while (m)
    T1=clock;
    time=T1-T2;
    s=3600*time(4)+60*time(5)+time(6);
    if(round(s*fs+50)<length(music))
        yp=music(round(s*fs):round(s*fs+50));
        plot(handles.axes1,yp,'LineWidth',2);
        set(handles.axes1,'ylim',[-1 1],'xlim',[0 50]); 
        y1=fft(yp,2048);
        f=fs*(0:1023)/2048;
        bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g');
        set(handles.axes2,'ylim',[0 40],'xlim',[0 2000]);
        drawnow;
    end
    m=m-1;
end

% --- Executes on button press in pushbutton1.

function work1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.txt', 'ÇëÑ¡È¡¼òÆ×');
fs = 44100; %sample rate
dt = 1/fs;
music = [];
i = 0;
n = 0;
k = [0;0;0;0];

double f;

notes = textread([pathname filename]);
j = size(notes);
n = j(2) - 3;%number of notes
b =  (2^((notes(1)-1)/12)) * 27.50;%freq for note 1
amp = 2^(1/12);
T = 60 / notes(9);
beat = notes(5);



for i = 1:n
	k = notes(:,i + 3);
	t = [0:dt:T*k(4)];
	j = size(t);
	tsize = j(2);

	if k(1) == 0
		NoteSound = zeros(1,tsize);
        music = [music NoteSound];
	else

		switch(k(1))			%basic freq
	    case 1
	    f = b;
	    case 2
	    f = b * amp ^ 2;
	    case 3
	    f = b * amp ^ 4;
	    case 4
	    f = b * amp ^ 5;
	    case 5
	    f = b * amp ^ 7;
	    case 6
	    f = b * amp ^ 9;
	    case 7
	    f = b * amp ^ 11;
	    otherwise
	    end

	    f = f * (2 ^ (k(2)));	%with or with out dot 

	    switch(k(3))			%notechange (b or #)
	    case 0
	    case -1
	    f = f / amp;
	    case 1
	    f = f * amp;
	    otherwise
	    end
		
		mod = sin(pi*t/t(end));
		NoteSound = mod.*sin(2*pi*f*t);
		music = [music NoteSound];

		
	end



end
music = music / max(music);
%sound(music,fs);
[file,path] = uiputfile('music.wav','Save file name');
audiowrite([path file],music,fs);

%player = audioplayer(music, fs);
sound(music,fs);
T=clock;
pause(0.05);
m=100000;

while (m)
    T1=clock;
    time=T1-T;
    s=3600*time(4)+60*time(5)+time(6);
    if(round(s*fs+5000)<length(music))
        yp=music(round(s*fs):round(s*fs+50));
        plot(handles.axes1,yp,'LineWidth',2);
        set(handles.axes1,'ylim',[-1 1],'xlim',[0 50]);
        y1=fft(yp,2048);
        f=fs*(0:1023)/2048;
        bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g');
        set(handles.axes2,'ylim',[0 8],'xlim',[100 250]);
        drawnow;
    end
    m=m-1;
end
function work2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(28,hObject, eventdata, handles);%C3


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(29,hObject, eventdata, handles);%#C3


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(30,hObject, eventdata, handles);%D

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(31,hObject, eventdata, handles);%#D

% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(32,hObject, eventdata, handles);%E

% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(33,hObject, eventdata, handles);%F

% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(34,hObject, eventdata, handles);%#F

% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(35,hObject, eventdata, handles);%G

% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(36,hObject, eventdata, handles);%G#

% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(37,hObject, eventdata, handles);%A

% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(38,hObject, eventdata, handles);%#A

% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(39,hObject, eventdata, handles);%B


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(40,hObject, eventdata, handles);%C4

% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(41,hObject, eventdata, handles);%#C

% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(42,hObject, eventdata, handles);%D

% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(43,hObject, eventdata, handles);%#D

% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(44,hObject, eventdata, handles);%E

% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(45,hObject, eventdata, handles);%F

% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(46,hObject, eventdata, handles);%#F

% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(47,hObject, eventdata, handles);%G

% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(48,hObject, eventdata, handles);%#G

% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(49,hObject, eventdata, handles);%A

% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(50,hObject, eventdata, handles);%#A

% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(51,hObject, eventdata, handles);%B


% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(52,hObject, eventdata, handles);%C5

% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(53,hObject, eventdata, handles);%#C

% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(54,hObject, eventdata, handles);%D

% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(55,hObject, eventdata, handles);%#D

% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(56,hObject, eventdata, handles);%E

% --- Executes on button press in pushbutton55.
function pushbutton55_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(57,hObject, eventdata, handles);%F

% --- Executes on button press in pushbutton56.
function pushbutton56_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton56 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(58,hObject, eventdata, handles);%#F

% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(59,hObject, eventdata, handles);%G

% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(60,hObject, eventdata, handles);%#G

% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(61,hObject, eventdata, handles);%A

% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(62,hObject, eventdata, handles);%#A

% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playkey(63,hObject, eventdata, handles);%B


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
a=eventdata.Character;

switch(a)
    case 'a'
        playkey(40,hObject, eventdata, handles);
    case 'A'
        playkey(41,hObject, eventdata, handles);
    case 's'
        playkey(42,hObject, eventdata, handles);
    case 'S'
        playkey(43,hObject, eventdata, handles);
    case 'd'
        playkey(44,hObject, eventdata, handles);
    case 'f'
        playkey(45,hObject, eventdata, handles);
    case 'F'
        playkey(46,hObject, eventdata, handles);
    case 'g'
        playkey(47,hObject, eventdata, handles);
    case 'G'
        playkey(48,hObject, eventdata, handles);
    case 'h'
        playkey(49,hObject, eventdata, handles);
    case 'H'
        playkey(50,hObject, eventdata, handles);
    case 'j'
        playkey(51,hObject, eventdata, handles);



    case 'z'
        playkey(28,hObject, eventdata, handles);
    case 'Z'
        playkey(29,hObject, eventdata, handles);
    case 'x'
        playkey(30,hObject, eventdata, handles);
    case 'X'
        playkey(31,hObject, eventdata, handles);
    case 'c'
        playkey(32,hObject, eventdata, handles);
    case 'v'
        playkey(33,hObject, eventdata, handles);
    case 'V'
        playkey(34,hObject, eventdata, handles);
    case 'b'
        playkey(35,hObject, eventdata, handles);
    case 'B'
        playkey(36,hObject, eventdata, handles);
    case 'n'
        playkey(37,hObject, eventdata, handles);
    case 'N'
        playkey(38,hObject, eventdata, handles);
    case 'm'
        playkey(39,hObject, eventdata, handles);




    case 'q'
        playkey(52,hObject, eventdata, handles);
    case 'Q'
        playkey(53,hObject, eventdata, handles);
    case 'w'
        playkey(54,hObject, eventdata, handles);
    case 'W'
        playkey(55,hObject, eventdata, handles);
    case 'e'
        playkey(56,hObject, eventdata, handles);
    case 'r'
        playkey(57,hObject, eventdata, handles);
    case 'R'
        playkey(58,hObject, eventdata, handles);
    case 't'
        playkey(59,hObject, eventdata, handles);
    case 'T'
        playkey(60,hObject, eventdata, handles);
    case 'y'
        playkey(61,hObject, eventdata, handles);
    case 'Y'
        playkey(62,hObject, eventdata, handles);
    case 'u'
        playkey(63,hObject, eventdata, handles);




    case '1'
        playkey(64,hObject, eventdata, handles);
    case '!'
        playkey(65,hObject, eventdata, handles);
    case '2'
        playkey(66,hObject, eventdata, handles);
    case '@'
        playkey(67,hObject, eventdata, handles);
    case '3'
        playkey(68,hObject, eventdata, handles);
    case '4'
        playkey(69,hObject, eventdata, handles);
    case '$'
        playkey(70,hObject, eventdata, handles);
    case '5'
        playkey(71,hObject, eventdata, handles);
    case '%'
        playkey(72,hObject, eventdata, handles);
    case '6'
        playkey(73,hObject, eventdata, handles);
    case '^'
        playkey(74,hObject, eventdata, handles);
    case '7'
        playkey(75,hObject, eventdata, handles);

end


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mid', 'open');
notes = readmidi([pathname filename]);
[file,path] = uiputfile('*.txt','Save file name');
dlmwrite([path file], notes, 'precision', '%5f', 'delimiter', '\t');


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F=str2double(get(handles.edit1,'String'));
V=str2double(get(handles.edit2,'String'));
sel=get(handles.popupmenu2,'value');
fs = 44100;
[filename, pathname] = uigetfile('*.txt', 'open');
notes = textread([pathname filename]);

notes(:,6) = notes(:,6) .* (1/V);

notes(:,6) = notes(:,6) .* (1/V);

j = size(notes);

plus = F*ones(j(1),1);

notes(:,4) = notes(:,4) + plus;


music = nmat22snd(notes,'fm',fs,sel);

k = notes(:,3);

music = music/max(music);

player = audioplayer(music, fs);

play(player);

T=clock;
pause(0.05);
m=100000;
axis([0,0.01,-0.5,0.5]);
set(gca,'color',[0.95,0.95,0.95]);
while (m)
    T1=clock;
    time=T1-T;
    s=3600*time(4)+60*time(5)+time(6);
    if(round(s*fs+1000)<length(music))
        yp=music(round(s*fs):round(s*fs+1000));
        plot(handles.axes1,yp,'LineWidth',2);
        set(handles.axes1,'ylim',[-0.8 0.8],'xlim',[0 1000]);
        y1=fft(yp,2048);
        f=fs*(0:1023)/2048;
        bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g');
        set(handles.axes2,'ylim',[0 100],'xlim',[0 2500]);
        drawnow;
    end
    m=m-1;
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.txt', 'ÇëÑ¡È¡¼òÆ×');
fs = 44100; %sample rate
dt = 1/fs;
music = [];
i = 0;
n = 0;
k = [0;0;0;0];

double f;

notes = textread([pathname filename]);
j = size(notes);
n = j(2) - 3;%number of notes
b =  (2^((notes(1)-1)/12)) * 27.50;%freq for note 1
amp = 2^(1/12);
T = 60 / notes(9);
beat = notes(5);

[y,fs] = audioread('piano.wav');
sig = y(1:48000,1);
[n2,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n2,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

for i = 1:n
	k = notes(:,i + 3);
	t = [0:dt:T*k(4)];
	j = size(t);
	tsize = j(2);

	if k(1) == 0
		NoteSound = zeros(1,tsize); 
        music = [music NoteSound];
	else

		switch(k(1))			%basic freq
	    case 1
	    f = b;
	    case 2
	    f = b * amp ^ 2;
	    case 3
	    f = b * amp ^ 4;
	    case 4
	    f = b * amp ^ 5;
	    case 5
	    f = b * amp ^ 7;
	    case 6
	    f = b * amp ^ 9;
	    case 7
	    f = b * amp ^ 11;
	    otherwise
	    end

	    f = f * (2 ^ (k(2)));	%with or with out dot 

	    switch(k(3))			%notechange (b or #)
	    case 0
	    case -1
	    f = f / amp;
	    case 1
	    f = f * amp;
	    otherwise
	    end

	clear y2;
	x = [1:1:tsize];
	y2(x) = sig_abs_filt(round(x*(48000-1)/tsize) + 1);
	%plot(t,sig,'b',t,sig_abs_filt,'r'),title('Ô­Ê¼ÐÅºÅ(À¶É«)Óë°üÂç£¨ºìÉ«£©');

	%fs = 44100; %sample rate
	dt = 1/fs;
	%double f;
	double freq;
	%T = 1;
	%---------------------------generate botton frequence
	    freq = f;
	%---------------------------the tone of piano
	        Af = [freq*1,987.8
		 	      freq*2,368.6
				  freq*3,620.2
				  freq*4,483.9
				  freq*5,156.7
				  freq*6,83.62
				  freq*7,120.1
				  freq*8,70.73
				  freq*9,5.348
				  freq*10,24.41
				  freq*11,27.35
				  freq*12,21.3
				  freq*13,10.31
				  freq*14,6.477
				  freq*15,15.91
				  freq*16,3.495
				  freq*17,2.546
				  freq*18,0.4751
				  freq*19,0.8858
				  freq*20,0.3792
				  freq*21,0.6012
				  freq*22,0.4224
				  freq*23,0.1538
				  freq*24,0.4154
				  freq*25,0.2032];
	%-------------------------generate envelope
		%t = [0:dt:T];
	    large = size(t);
	    tone = zeros(1,large(2));
	    stren = Af(:,2)/max(Af(:,2));
	    %mod = (10*t)./exp(10*t);
	    %mod = mod / max(mod);
	%-------------------------generate music
	    for i=1:25
	    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
	    end
		NoteSound = y2.*tone;
	    music = [music NoteSound];
		
	end



end
music = music / max(music);
%sound(music,fs);

%player = audioplayer(music, fs);
sound(music,fs);
T=clock;
pause(0.05);
m=100000;

while (m)
    T1=clock;
    time=T1-T;
    s=3600*time(4)+60*time(5)+time(6);
    if(round(s*fs+5000)<length(music))
        yp=music(round(s*fs):round(s*fs+500));
        plot(handles.axes1,yp);
        set(handles.axes1,'ylim',[-1 1],'xlim',[0 500]);
        y1=fft(yp,2048);
        f=fs*(0:1023)/2048;
        bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g');
        set(handles.axes2,'ylim',[0 10],'xlim',[100 2500]);
        drawnow;
    end
    m=m-1;
end


% --- Executes on button press in pushbutton63.
function pushbutton63_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton63 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


function w = nmat22snd(nmat,synthtype,fs,sel)
% Create waveform of NMAT using a simple synthesis
% w = nmat2snd(nmat,<synthtype>,<fs>,<f_min>,<f_max>)
% Create waveform of NMAT using a simple FM synthesis. The default sampling rate is 
% 22050 Hz and velocities are scaled to have
% a max value of 1.
%
% SYNTHTYPE 'fm' (default) uses FM synthesis to approximate horn sound.
% SYNTHTYPE 'shepard' creates waveform of NMAT using Shepard tones. 
% These tones have also been 
%  called 'Circular tones' because they are specifically constructed to contain 
%  frequency components at octave intervals with an emphasis of the spectral 
%  components between 500Hz and 1000 Hz that effectively 
%  eliminates octave information (Shepard, 1964). 
%
% Part of the code has been obtained from the work of Ed Doering.
%  Ed.Doering@Rose-Hulman.Edu
%
% Input argument:
%	NMAT = notematrix
%     SYNTHTYPE (Optional) = Synthesis type, either FM synthesis ('fm', default) 
%           or Shepard tones ('shepard')
%     FS (optional) = sampling rate (default 22050)
%
% Output:
%	Y = waveform
%
% Example 1: samples1 = nmat2snd(laksin);
% Example 2: samples2 = nmat2snd(laksin,'shepard', 22050);
%
% Reference:
%    Moore, F. R. (1990). Elements of Computer Music. New York: Prentice-Hall.
%    Shepard, R. N. (1964). Circularity in judgements of 
%       relative pitch. Journal of the Acoustical Society of America, 
%       36, 2346-2353. 
%
% Change History :
% Date		Time	Prog	Note
% 29.9.2003	20:13	TE	Created under MATLAB 5.3 (PC)
% 4/15/05           JBP added ability to specify number of partials in
%                       tone, also shifted harmonic envelope such that tones are actually 3
%                       semitones lower than desired. To fix, transpose input up by 3 semitones
%                       (3 midi notes) to get correct pitch with better envelope.
% 2.5.2005	9:30	TE	Almost a total revision if the shepard function
%? Part of the MIDI Toolbox, Copyright ? 2004, University of Jyvaskyla, Finland
% See License.txt

if isempty(nmat), return; end


%%%%%%%%%%%%  WARNINGS

% END WARNINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var = sel;

switch var
          case 2

% convert MIDI numbers to frequencies in Hz
notes(:,1)=onset(nmat,'sec');
notes(:,2)=dur(nmat,'sec')+0.01;
notes(:,3)=midi2hz(pitch(nmat));
notes(:,4)=velocity(nmat);

[yp,] = audioread('EOP.mp3'); %get piano sound
sig = yp(1:104417,1);
[n,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

% generate time vector for output waveform; end time is nearest integer
% above the last note event time (give some extra room)
tt=0:1/fs:ceil(max(notes(:,1))+max(notes(:,2)))-(1/fs);

% scale note velocities so max velocity is one
notes(:,4)=notes(:,4)/max(notes(:,4));
% convert each note to a waveform, and add the waveform to the output waveform

y=zeros(size(tt));

for i=1:size(notes,1),
   % convert note to waveform using the instrument defined by 'fncname'
   w=pianosynth(notes(i,2:4),fs,sig_abs_filt); % 
   % place waveform in the output file
   ttint=round(notes(i,1)*fs)+1:round(notes(i,1)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end

   w=y/4; %rescale to fit between -1 and +1 (4 is a conservative estimate)
 %rescale to fit between -1 and +1 (4 is a conservative estimate)

% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end

case 1

% convert MIDI numbers to frequencies in Hz
notes(:,1)=onset(nmat,'sec');
notes(:,2)=dur(nmat,'sec')+0.01;
notes(:,3)=midi2hz(pitch(nmat));
notes(:,4)=velocity(nmat);

[yp,] = audioread('piano.wav'); %get piano sound
sig = yp(1:48000,1);
[n,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

% generate time vector for output waveform; end time is nearest integer
% above the last note event time (give some extra room)
tt=0:1/fs:ceil(max(notes(:,1))+max(notes(:,2)))-(1/fs);

% scale note velocities so max velocity is one
notes(:,4)=notes(:,4)/max(notes(:,4));
% convert each note to a waveform, and add the waveform to the output waveform

y=zeros(size(tt));

for i=1:size(notes,1),
   % convert note to waveform using the instrument defined by 'fncname'
   w=Gpianosynth(notes(i,2:4),fs,sig_abs_filt); % 
   % place waveform in the output file
   ttint=round(notes(i,1)*fs)+1:round(notes(i,1)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end

   w=y/4; %rescale to fit between -1 and +1 (4 is a conservative estimate)
 %rescale to fit between -1 and +1 (4 is a conservative estimate)

% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end

case 3

% convert MIDI numbers to frequencies in Hz
notes(:,1)=onset(nmat,'sec');
notes(:,2)=dur(nmat,'sec')+0.01;
notes(:,3)=midi2hz(pitch(nmat));
notes(:,4)=velocity(nmat);

[yp,] = audioread('violin.wav'); %get piano sound
sig = yp(1:53000,1);
[n,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

% generate time vector for output waveform; end time is nearest integer
% above the last note event time (give some extra room)
tt=0:1/fs:ceil(max(notes(:,1))+max(notes(:,2)))-(1/fs);

% scale note velocities so max velocity is one
notes(:,4)=notes(:,4)/max(notes(:,4));
% convert each note to a waveform, and add the waveform to the output waveform
y=zeros(size(tt));


for i=1:size(notes,1),
   % convert note to waveform using the instrument defined by 'fncname'
   w=violinsynth(notes(i,2:4),fs,sig_abs_filt); % 
   % place waveform in the output file
   ttint=round(notes(i,1)*fs)+1:round(notes(i,1)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end

   w=y/4; %rescale to fit between -1 and +1 (4 is a conservative estimate)
 %rescale to fit between -1 and +1 (4 is a conservative estimate)

% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end


case 4
	% convert MIDI numbers to frequencies in Hz
notes(:,1)=onset(nmat,'sec');
notes(:,2)=dur(nmat,'sec')+0.01;
notes(:,3)=midi2hz(pitch(nmat));
notes(:,4)=velocity(nmat);

[yp,] = audioread('guitar.wav'); %get piano sound
sig = yp(1:48000,1);
[n,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

% generate time vector for output waveform; end time is nearest integer
% above the last note event time (give some extra room)
tt=0:1/fs:ceil(max(notes(:,1))+max(notes(:,2)))-(1/fs);

% scale note velocities so max velocity is one
notes(:,4)=notes(:,4)/max(notes(:,4));
% convert each note to a waveform, and add the waveform to the output waveform
y=zeros(size(tt));


for i=1:size(notes,1),
   % convert note to waveform using the instrument defined by 'fncname'
   w=guitarsynth(notes(i,2:4),fs,sig_abs_filt); % 
   % place waveform in the output file
   ttint=round(notes(i,1)*fs)+1:round(notes(i,1)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end

   w=y/4; %rescale to fit between -1 and +1 (4 is a conservative estimate)
 %rescale to fit between -1 and +1 (4 is a conservative estimate)




case 5
	% convert MIDI numbers to frequencies in Hz
notes(:,1)=onset(nmat,'sec');
notes(:,2)=dur(nmat,'sec')+0.01;
notes(:,3)=midi2hz(pitch(nmat));
notes(:,4)=velocity(nmat);

[yp,] = audioread('sax.wav'); %get piano sound
sig = yp(1:56000,1);
[n,wn] = buttord(30*2/fs,100*2/fs,0.1,30);  
[B,A] = butter(n,wn,'low');
sig_abs = abs(sig);
sig_abs_filt = filter(B,A,sig_abs);

% generate time vector for output waveform; end time is nearest integer
% above the last note event time (give some extra room)
tt=0:1/fs:ceil(max(notes(:,1))+max(notes(:,2)))-(1/fs);

% scale note velocities so max velocity is one
notes(:,4)=notes(:,4)/max(notes(:,4));
% convert each note to a waveform, and add the waveform to the output waveform
y=zeros(size(tt));


for i=1:size(notes,1),
   % convert note to waveform using the instrument defined by 'fncname'
   w=saxsynth(notes(i,2:4),fs,sig_abs_filt); % 
   % place waveform in the output file
   ttint=round(notes(i,1)*fs)+1:round(notes(i,1)*fs)+length(w);
   y(ttint)=y(ttint)+w;
end

   w=y/4; %rescale to fit between -1 and +1 (4 is a conservative estimate)
 %rescale to fit between -1 and +1 (4 is a conservative estimate)

% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end

% play the sound if no output arguments, otherwise return the sound
%if nargout<1
%   soundsc(y,fs);
%else
%   out=y;
%end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		function y1=fmsynth(note,fs)
		% FM horn instrument (Moore p. 327)
		%
		% note is in duration-frequency-amplitude format
		% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

		% generate time vector
		du=note(1);
		tt=0:1/fs:du;

		fc = note(2);	%carrier frequency
		h = 1;		%harmonicity ratio
		fm = h*fc;	%modulating frequency
		Imin=0;		%minimum modulation index
		Imaxmin = 5;	%modulation index (max value above Imin)

		% envelopes
		env=envelope([0 0 -1; 0.047354167 1 -1; 0.1725625 0.4908 0; 0.385208333 0.3344 -1; 1 0 0],du,fs);

		%disp(['env ' num2str(size(env)) 'tt ' num2str(size(tt))])
		aa = note(3)*env; 
		ii = Imin+Imaxmin*env;

		% output waveform
		y1 = aa.*sin(2*pi*fc*tt + ii.*sin(2*pi*fm*tt));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		function y2=envelope(v,du,fs)
		% envelope function (Moore p. 184, and p. 514)
		%	env=envelope(vlist,du,fs) accepts a matrix 'vlist' where each row is a triple indicating
		%  time (arbitrary units), value (usually between 0 and 1), and transition type.
		%  'du' is the envelope duration in seconds, and 'fs' is the sampling frequency in Hz.
		%
		%  See p. 184 and p. 514 of F. Richard Moore's text ("Elements of Computer Music", 1990, 

		% Find the number of vertices
		numv=size(v,1);

		% Set the time column to occur over duration
		v(:,1)=(v(:,1)/v(numv,1))*du;

		% Generate the envelope (guard against divide by zero error by adding
		% a small number to denominator)
		y2=[];
		for k=1:numv-1 
		   ii=linspace(0,1,(v(k+1,1)-v(k,1))*fs);
		   if v(k,3)==0
		      y2=[y2 linspace(v(k,2),v(k+1,2),size(ii,2))];
		   else
		      y2=[y2 v(k,2)+(v(k+1,2)-v(k,2))*(1-exp(v(k,3)*ii))/(1-exp(v(k,3)+1e-12))];
		   end
		end

		% Figure out how many samples are expected
		nums=size(0:1/fs:du,2);

		% Figure out how many samples were generated
		numg=size(y2,2);

		% Pad or trim the vector as needed
		% (NOTE: This method is a bit of a kluge -- maybe someone can suggest a better
		% way!)
		if numg<nums
		   y2=[y2 zeros(1,nums-numg)];
		elseif numg>nums
		   y2(nums+1:numg)=[];
		end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			function s = shepardtone(pitch,dur,fs)
            t = 0:1/fs:dur;
            f = midi2hz(pitch);
            u = zeros(size(t));

            % Thresholds for the spectra, Krumhansl & Kessler, 1982, p341: "loudness envelope over five-octave range (
            %          from 77.8 Hz to 2349 Hz), which consisted of three parts: a gradually increasing section over the 
            %          first octave and a half, a constant section over the
            %          middle two octaves, and a symmetrically decreasing
            %          section over the last octave and a half. The
            %          corresponding amplitude of the sine wave components
            %          at each frequency was determined using the
            %          amplitude-loudness curves of Fletcher and Munson
            %          (1933), originally introduced by Shepard (1964).
            
            % Loudness envelope min and max (simpler version than suggested above)
            f_min=16;
            f_max=20000;
            
            % Number of partials needed
            f_max_part = min(f_max,fs/2);
            pl=ceil(log2(f_min/f));
            ph=floor(log2(f_max_part/f));
            partials = f*2.^(pl:ph);
                        
            % Amplitudes
            ampl = 1-cos(2*pi*(log(partials/f_min)./log((f_max)/f_min)));
            ampl = ampl/(max(ampl));
            
            % Calculate waves for the partials
            warning off
            for j=1:length(partials)
               u = u + ampl(j).*sin(2*pi*partials(j)*t);
            end
            
            % Envelope
            ramp=.1;
            envelope(1:ramp*fs)=t(1:ramp*fs).*t(1:ramp*fs);
            envelope(length(t)-ramp*fs+1:length(t))=fliplr(envelope(1:ramp*fs));
            envelope(ramp*fs:end-ramp*fs)=max(envelope);
            factor=exp(1)/max(envelope);
            y=envelope.*factor;
            s=y.*u;
            warning on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			function y4=pianosynth(note,fs,sig_abs_filt)
			% FM horn instrument (Moore p. 327)
			%
			% note is in duration-frequency-amplitude format
			% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

			% generate time vector
			% FM horn instrument (Moore p. 327)

			du = 104417 / 44100 *(note(3)/512+0.5);
			tt=0:1/fs:du;

			fc = note(2);	%carrier frequency


			
		
			
			
			t = 0:1/fs:du;
			nn = size(t,2);
			x = [1:1:nn];
			y2(x) = sig_abs_filt(round(x*(104417-1)/nn) + 1);
			%plot(t,sig,'b',t,sig_abs_filt,'r'),title('????????(????)???????????????');

			%fs = 44100; %sample rate
			music = [];
			dt = 1/fs;
			%double f;
			double freq;
			%T = 1;
			%---------------------------generate botton frequence
			    freq = fc;
			%---------------------------the tone of piano
			        Af = [freq*1,987.8
				 	      freq*2,368.6
						  freq*3,620.2
						  freq*4,483.9
						  freq*5,156.7
						  freq*6,83.62
						  freq*7,120.1
						  freq*8,70.73
						  freq*9,5.348
						  freq*10,24.41
						  freq*11,27.35
						  freq*12,21.3
						  freq*13,10.31
						  freq*14,6.477
						  freq*15,15.91
						  freq*16,3.495
						  freq*17,2.546
						  freq*18,0.4751
						  freq*19,0.8858
						  freq*20,0.3792
						  freq*21,0.6012
						  freq*22,0.4224
						  freq*23,0.1538
						  freq*24,0.4154
						  freq*25,0.2032];
			%-------------------------generate envelope
				%t = [0:dt:T];
			    large = size(t);
			    tone = zeros(1,large(2));
			    stren = Af(:,2)/max(Af(:,2));
			    %mod = (10*t)./exp(10*t);
			    %mod = mod / max(mod);
			%-------------------------generate music
			    for i=1:25
			    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
			    end
				y4 = y2.*tone;
                y4 = y4 *note(3)/128;
                
            function y5=Gpianosynth(note,fs,sig_abs_filt)
			% FM horn instrument (Moore p. 327)
			%
			% note is in duration-frequency-amplitude format
			% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

			% generate time vector
			% FM horn instrument (Moore p. 327)

			du = note(1)*(1+note(3)/256);
			tt=0:1/fs:du;

			fc = note(2);	%carrier frequency


			
		
			
			
			t = 0:1/fs:du;
			nn = size(t,2);
			x = [1:1:nn];
			y2(x) = sig_abs_filt(round(x*(48000-1)/nn) + 1);
			%plot(t,sig,'b',t,sig_abs_filt,'r'),title('????????(????)???????????????');

			%fs = 44100; %sample rate
			dt = 1/fs;
			%double f;
			double freq;
			%T = 1;
			%---------------------------generate botton frequence
			    freq = fc;
			%---------------------------the tone of piano
			        Af = [freq*1,987.8
				 	      freq*2,368.6
						  freq*3,620.2
						  freq*4,483.9
						  freq*5,156.7
						  freq*6,83.62
						  freq*7,120.1
						  freq*8,70.73
						  freq*9,5.348
						  freq*10,24.41
						  freq*11,27.35
						  freq*12,21.3
						  freq*13,10.31
						  freq*14,6.477
						  freq*15,15.91
						  freq*16,3.495
						  freq*17,2.546
						  freq*18,0.4751
						  freq*19,0.8858
						  freq*20,0.3792
						  freq*21,0.6012
						  freq*22,0.4224
						  freq*23,0.1538
						  freq*24,0.4154
						  freq*25,0.2032];
			%-------------------------generate envelope
				%t = [0:dt:T];
			    large = size(t);
			    tone = zeros(1,large(2));
			    stren = Af(:,2)/max(Af(:,2));
			    %mod = (10*t)./exp(10*t);
			    %mod = mod / max(mod);
			%-------------------------generate music
			    for i=1:25
			    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
			    end
				y5 = y2.*tone;
                y5 = y5 *note(3)/128;

                function y6=violinsynth(note,fs,sig_abs_filt)
			% FM horn instrument (Moore p. 327)
			%
			% note is in duration-frequency-amplitude format
			% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

			% generate time vector
			% FM horn instrument (Moore p. 327)

			du = note(1);
			tt=0:1/fs:du;

			fc = note(2);	%carrier frequency


			
		
			
			
			t = 0:1/fs:du;
			nn = size(t,2);
			x = [1:1:nn];
			y2(x) = sig_abs_filt(round(x*(48000-1)/nn) + 1);
			%plot(t,sig,'b',t,sig_abs_filt,'r'),title('????????(????)???????????????');

			%fs = 44100; %sample rate
			dt = 1/fs;
			%double f;
			double freq;
			%T = 1;
			%---------------------------generate botton frequence
			    freq = fc;
			%---------------------------the tone of piano
			        Af = [freq*1,603.7571
				 	      freq*2,309.7122
						  freq*3,421.0204
						  freq*4,57.5981
						  freq*5,74.5945
						  freq*6,76.4599
						  freq*7,43.8063
						  freq*8,15.9196
						  freq*9,9.1919
						  freq*10,14.2853
						  freq*11,4.3677
						  freq*12,5.3503
						  freq*13,10.7509
						  freq*14,3.0805
						  freq*15,3.1974
						  freq*16,6.2824
						  freq*17,6.0610
						  freq*18,6.2569
						  freq*19,4.6588
						  freq*20,4.9715
						  ];
			%-------------------------generate envelope
				%t = [0:dt:T];
			    large = size(t);
			    tone = zeros(1,large(2));
			    stren = Af(:,2)/max(Af(:,2));
			    %mod = (10*t)./exp(10*t);
			    %mod = mod / max(mod);
			%-------------------------generate music
				sizeaf=size(Af,1);
			    for i=1:sizeaf
			    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
			    end
				y6 = y2.*tone;
               	y6 =	y6 *note(3)/128;




               	

                function y7=saxsynth(note,fs,sig_abs_filt)
			% FM horn instrument (Moore p. 327)
			%
			% note is in duration-frequency-amplitude format
			% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

			% generate time vector
			% FM horn instrument (Moore p. 327)

			du = 56000/44100;
			tt=0:1/fs:du;

			fc = note(2);	%carrier frequency


			
		
			
			
			t = 0:1/fs:du;
			nn = size(t,2);
			x = [1:1:nn];
			y2(x) = sig_abs_filt(round(x*(56000-1)/nn) + 1);
			%plot(t,sig,'b',t,sig_abs_filt,'r'),title('????????(????)???????????????');

			%fs = 44100; %sample rate
			dt = 1/fs;
			%double f;
			double freq;
			%T = 1;
			%---------------------------generate botton frequence
			    freq = fc;
			%---------------------------the tone of piano
			        Af =[freq*1,219.6
				 	      freq*2,42.3
						  freq*3,25.3
						  freq*4,39.9
						  freq*5,6.3
						  freq*6,3.3
						  freq*7,6.4
						  freq*8,6.4
						  freq*9,6.8
						  freq*10,12.3
						  freq*11,4.0
						  freq*12,0.7
						  freq*13,2.5
						  freq*14,2.1
						  freq*15,4.7
						  freq*16,3.9
						  freq*17,4.2
						  freq*18,2.4
						  freq*19,4.1
						  freq*20,2.8
						  ];
			%-------------------------generate envelope
				%t = [0:dt:T];
			    large = size(t);
			    tone = zeros(1,large(2));
			    stren = Af(:,2)/max(Af(:,2));
			    %mod = (10*t)./exp(10*t);
			    %mod = mod / max(mod);
			%-------------------------generate music
				sizeaf=size(Af,1);
			    for i=1:sizeaf
			    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
			    end
				y7 = y2.*tone;
               	y7 =	y7 *note(3)/128;





               	 function y8=guitarsynth(note,fs,sig_abs_filt)
			% FM horn instrument (Moore p. 327)
			%
			% note is in duration-frequency-amplitude format
			% (duration in seconds, frequency in Hz, amplitude usually between 0 and 1)

			% generate time vector
			% FM horn instrument (Moore p. 327)

			du = (48000/44100) *(1+note(3)/128);
			tt=0:1/fs:du;

			fc = note(2);	%carrier frequency


			
		
			
			
			t = 0:1/fs:du;
			nn = size(t,2);
			x = [1:1:nn];
			y2(x) = sig_abs_filt(round(x*(48000-1)/nn) + 1);
			%plot(t,sig,'b',t,sig_abs_filt,'r'),title('????????(????)???????????????');

			%fs = 44100; %sample rate
			dt = 1/fs;
			%double f;
			double freq;
			%T = 1;
			%---------------------------generate botton frequence
			    freq = fc;
			%---------------------------the tone of piano
			         Af = [freq*1,277
					 	   freq*2,139
					       freq*3,78
						   freq*4,7
						   freq*5,10
						   freq*6,6
						   freq*7,2
						   freq*8,7
						   freq*9,7
						   freq*10,4
						   freq*11,4
						   freq*12,4			 
						   freq*13,9
						   freq*14,2
						   freq*15,3
						   freq*16,8
						   freq*17,2
						   freq*18,4
						   freq*19,2
						   freq*20,4
						   freq*21,2];
			%-------------------------generate envelope
				%t = [0:dt:T];
			    large = size(t);
			    tone = zeros(1,large(2));
			    stren = Af(:,2)/max(Af(:,2));
			    %mod = (10*t)./exp(10*t);
			    %mod = mod / max(mod);
			%-------------------------generate music
				sizeaf=size(Af,1);
			    for i=1:sizeaf
			    	tone = stren(i)*cos(2*pi*Af(i,1)*t) + tone;
			    end
				y8 = y2.*tone;
               	y8 =	y8 *note(3)/128;


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

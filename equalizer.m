function varargout = equalizer(varargin)
% EQUALIZER MATLAB code for equalizer.fig
%      EQUALIZER, by itself, creates a new EQUALIZER or raises the existing
%      singleton*.
%
%      H = EQUALIZER returns the handle to a new EQUALIZER or the handle to
%      the existing singleton*.
%
%      EQUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER.M with the given input arguments.
%
%      EQUALIZER('Property','Value',...) creates a new EQUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before equalizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to equalizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help equalizer

% Last Modified by GUIDE v2.5 22-Apr-2018 18:29:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @equalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @equalizer_OutputFcn, ...
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


% --- Executes just before equalizer is made visible.
function equalizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to equalizer (see VARARGIN)
global ha;
% Choose default command line output for equalizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes equalizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = handles.figure1; %´´½¨Ò»¸öFigure£¬²¢·µ»ØÆä¾ä±ú
newIcon = javax.swing.ImageIcon('material\equalizeico.png')
figFrame = get(h,'JavaFrame'); %È¡µÃFigureµÄJavaFrame¡£
figFrame.setFigureIcon(newIcon); %ÐÞ¸ÄÍ¼±ê
ha=axes('units','normalized','position',[0 0 1 1]);
uistack(ha,'down')
II=imread('material\EQBG.jpg');
image(II)
colormap gray
set(ha,'handlevisibility','off','visible','off');
set(handles.prename,'Visible','off');
set(handles.sure,'Visible','off');

%setappdata(handles.figure_equalizer,'Max',0);
%setappdata(handles.figure_equalizer,'fpath',0);
%set(handles.figure_Equalizer,'defaultAxesColor',[0.941 0.941 0.941])

global n stp  y counter fs weightCoe  Select fpath   i  m a b;
             

set(handles.slider1,'min',-20);
set(handles.slider1,'max',20);
set(handles.slider1,'value',0);
set(handles.slider1,'SliderStep',[0.1,0.1]);

set(handles.slider2,'min',-20);
set(handles.slider2,'max',20);
set(handles.slider2,'value',0);
set(handles.slider2,'SliderStep',[0.1,0.1]);

set(handles.slider3,'min',-20);
set(handles.slider3,'max',20);
set(handles.slider3,'value',0);
set(handles.slider3,'SliderStep',[0.1,0.1]);

set(handles.slider4,'min',-20);
set(handles.slider4,'max',20);
set(handles.slider4,'value',0);
set(handles.slider4,'SliderStep',[0.1,0.1]);

set(handles.slider5,'min',-20);
set(handles.slider5,'max',20);
set(handles.slider5,'value',0);
set(handles.slider5,'SliderStep',[0.1,0.1]);

set(handles.slider6,'min',-20);
set(handles.slider6,'max',20);
set(handles.slider6,'value',0);
set(handles.slider6,'SliderStep',[0.1,0.1]);

set(handles.slider7,'min',-20);
set(handles.slider7,'max',20);
set(handles.slider7,'value',0);
set(handles.slider7,'SliderStep',[0.1,0.1]);

set(handles.slider8,'min',-20);
set(handles.slider8,'max',20);
set(handles.slider8,'value',0);
set(handles.slider8,'SliderStep',[0.1,0.1]);

set(handles.slider9,'min',-20);
set(handles.slider9,'max',20);
set(handles.slider9,'value',0);
set(handles.slider9,'SliderStep',[0.1,0.1]);

set(handles.slider10,'min',-20);
set(handles.slider10,'max',20);
set(handles.slider10,'value',0);
set(handles.slider10,'SliderStep',[0.1,0.1]);
global Select;



II=imread('material\buttons\resetbutton.jpg');
set(handles.resetbutton,'cdata',II);

II=imread('material\buttons\eqsave.jpg');
set(handles.eqsave,'cdata',II);

guidata(hObject, handles);s = load('presets\sum.mat');
sc=struct2cell(s);  
t=cell2mat(sc); 

presetnames{1,1}='';

if t == 1
else    
    for i = 2:t
        presetnames{1,i}=fgets(fopen(['presets\',num2str(i),'.txt']));
    end
end

set(handles.popupmenu1,'string',presetnames);
hdl = varargin{2};


% --- Outputs from this function are returned to the command line.
function varargout = equalizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(1)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(2)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);


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
global weightCoe ;
weightCoe(3)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(4)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(5)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(6)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(7)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(10)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);



% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(8)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global weightCoe ;
weightCoe(9)=10^(get(hObject,'value')/20);
set(handles.popupmenu1,'Value',1);

% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.slider1,'Value',0);
set(handles.slider2,'Value',0);
set(handles.slider3,'Value',0);
set(handles.slider4,'Value',0);
set(handles.slider5,'Value',0);
set(handles.slider6,'Value',0);
set(handles.slider7,'Value',0);
set(handles.slider8,'Value',0);
set(handles.slider9,'Value',0);
set(handles.slider10,'Value',0);
set(handles.prename,'String','');
global weightCoe ;
weightCoe(1)=10^(0);
weightCoe(2)=10^(0);
weightCoe(3)=10^(0);
weightCoe(4)=10^(0);
weightCoe(5)=10^(0);
weightCoe(6)=10^(0);
weightCoe(7)=10^(0);
weightCoe(8)=10^(0);
weightCoe(9)=10^(0);
weightCoe(10)=10^(0);




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global weightCoe ha;
switch get(handles.popupmenu1,'Value')  

  case 1  

      set(handles.slider1,'Value',0);
    set(handles.slider2,'Value',0);
    set(handles.slider3,'Value',0);
    set(handles.slider4,'Value',0);
    set(handles.slider5,'Value',0);
    set(handles.slider6,'Value',0);
    set(handles.slider7,'Value',0);
    set(handles.slider8,'Value',0);
    set(handles.slider9,'Value',0);
    set(handles.slider10,'Value',0);
    
    weightCoe(1)=10^(0);
    weightCoe(2)=10^(0);
    weightCoe(3)=10^(0);
    weightCoe(4)=10^(0);
    weightCoe(5)=10^(0);
    weightCoe(6)=10^(0);
    weightCoe(7)=10^(0);
    weightCoe(8)=10^(0);
    weightCoe(9)=10^(0);
    weightCoe(10)=10^(0);
    
    set(handles.figure1,'CurrentAxes',ha);
    ha=axes('units','normalized','position',[0 0 1 1]);
    II=imread('material\EQBG.jpg');
    image(II)

    colormap gray
    set(ha,'handlevisibility','off','visible','off');
    set(handles.prename,'Visible','off');
    set(handles.sure,'Visible','off');

    II=imread('material\buttons\resetbutton.jpg');
    set(handles.resetbutton,'cdata',II);

    II=imread('material\buttons\eqsave.jpg');
    set(handles.eqsave,'cdata',II);


    otherwise
        
        
    s = load(['presets\',num2str(get(handles.popupmenu1,'Value')),'.mat']);
    sc=struct2cell(s);  
    db=cell2mat(sc); 
    if(get(handles.popupmenu1,'Value')<11)
    set(handles.figure1,'CurrentAxes',ha);
    ha=axes('units','normalized','position',[0 0 1 1]);
    II=imread(['material\EQBG',num2str(get(handles.popupmenu1,'Value')),'.jpg']);
    image(II)

    colormap gray
    set(ha,'handlevisibility','off','visible','off');
    set(handles.prename,'Visible','off');
    set(handles.sure,'Visible','off');

    II=imread(['material\buttons\resetbutton',num2str(get(handles.popupmenu1,'Value')),'.jpg']);
    set(handles.resetbutton,'cdata',II);

    II=imread(['material\buttons\eqsave',num2str(get(handles.popupmenu1,'Value')),'.jpg']);
    set(handles.eqsave,'cdata',II);
    end

      set(handles.slider1,'Value',db(1,1));
    set(handles.slider2,'Value',db(1,2));
    set(handles.slider3,'Value',db(1,3));
    set(handles.slider4,'Value',db(1,4));
    set(handles.slider5,'Value',db(1,5));
    set(handles.slider6,'Value',db(1,6));
    set(handles.slider7,'Value',db(1,7));
    set(handles.slider8,'Value',db(1,8));
    set(handles.slider9,'Value',db(1,9));
    set(handles.slider10,'Value',db(1,10));
    weightCoe(8)=10^(get(hObject,'value')/20);
        weightCoe(1)=10^(get(handles.slider1,'Value')/20);
        weightCoe(2)=10^(get(handles.slider2,'Value')/20);
        weightCoe(3)=10^(get(handles.slider3,'Value')/20);
        weightCoe(4)=10^(get(handles.slider4,'Value')/20);
        weightCoe(5)=10^(get(handles.slider5,'Value')/20);
        weightCoe(6)=10^(get(handles.slider6,'Value')/20);
        weightCoe(7)=10^(get(handles.slider7,'Value')/20);
        weightCoe(8)=10^(get(handles.slider8,'Value')/20);
        weightCoe(9)=10^(get(handles.slider9,'Value')/20);
        weightCoe(10)=10^(get(handles.slider10,'Value')/20);

end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in eqon.
function eqon_Callback(hObject, eventdata, handles)
% hObject    handle to eqon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eqon
global Select;

eqo = get(handles.eqon,'Value')
if(eqo == 1)
    if get(handles.domainselection,'Value') == 1
        Select = 1;
        set(handles.domainselection,'String','T');
        set(handles.eqon,'String','on');
        set(handles.eqon,'foregroundcolor',[1 0 0]);
    else
        Select = 2;
        set(handles.domainselection,'String','f');
        set(handles.eqon,'String','on');
        set(handles.eqon,'foregroundcolor',[1 0 0]);
    end
else
    if get(handles.domainselection,'Value') == 1
        Select = 0;
        set(handles.domainselection,'String','T');
        set(handles.eqon,'String','off');
        set(handles.eqon,'foregroundcolor',[0 0 0]);
    else
        Select = 0;
        set(handles.domainselection,'String','f');
        set(handles.eqon,'String','off');
        
        set(handles.eqon,'foregroundcolor',[0 0 0]);
    end
end


% --- Executes on button press in eqsave.
function eqsave_Callback(hObject, eventdata, handles)
% hObject    handle to eqsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.prename,'Visible','on');
set(handles.sure,'Visible','on');

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function eqon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eqon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




function prename_Callback(hObject, eventdata, handles)
% hObject    handle to prename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prename as text
%        str2double(get(hObject,'String')) returns contents of prename as a double


% --- Executes during object creation, after setting all properties.
function prename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sure.
function sure_Callback(hObject, eventdata, handles)
% hObject    handle to sure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
presetnum = size(get(handles.popupmenu1,'String'),1);
name = get(handles.prename,'String');
sum = presetnum + 1;

handles.preset(1)  = get(handles.slider1,'Value');
handles.preset(2)  = get(handles.slider2,'Value');
handles.preset(3)  = get(handles.slider3,'Value');
handles.preset(4)  = get(handles.slider4,'Value');
handles.preset(5)  = get(handles.slider5,'Value');
handles.preset(6)  = get(handles.slider6,'Value');
handles.preset(7)  = get(handles.slider7,'Value');
handles.preset(8)  = get(handles.slider8,'Value');
handles.preset(9)  = get(handles.slider9,'Value');
handles.preset(10) = get(handles.slider10,'Value');
save('presets\sum.mat', 'sum');
save(['presets\',num2str(presetnum+1),'.mat'], '-struct', 'handles', 'preset');
fid=fopen(['presets\',num2str(presetnum+1),'.txt'],'w');
fprintf(fid,name);

s = load('presets\sum.mat');
sc=struct2cell(s);  
t=cell2mat(sc); 

presetnames{1,1}=' ';

for i = 2:t
    presetnames{1,i}=fgets(fopen(['presets\',num2str(i),'.txt']));
end



set(handles.popupmenu1,'string',presetnames);

set(handles.popupmenu1,'value',sum);
set(handles.prename,'Visible','off');
set(handles.prename,'String','');
set(handles.sure,'Visible','off');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over eqon.
function eqon_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to eqon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.prename,'String',get(handles.popupmenu1(2),'String'));


function domainselection_Callback(hObject, eventdata, handles)
% hObject    handle to timesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Select;
eqo = get(handles.eqon,'Value')
if(eqo == 1)
    if get(handles.domainselection,'Value') == 1
        Select = 1;
        set(handles.domainselection,'String','T');
        set(handles.eqon,'String','on');
        set(handles.eqon,'foregroundcolor',[1 0 0]);
    else
        Select = 2;
        set(handles.domainselection,'String','f');
        set(handles.eqon,'String','on');
        set(handles.eqon,'foregroundcolor',[1 0 0]);
    end
else
    if get(handles.domainselection,'Value') == 1
        Select = 0;
        set(handles.domainselection,'String','T');
        set(handles.eqon,'String','off');
        set(handles.eqon,'foregroundcolor',[0 0 0]);
    else
        Select = 0;
        set(handles.domainselection,'String','f');
        set(handles.eqon,'String','off');
        
        set(handles.eqon,'foregroundcolor',[0 0 0]);
    end
end

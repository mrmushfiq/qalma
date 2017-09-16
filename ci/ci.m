% M. Mushfiqur Rahman
% Florida Atlantic University
% August, 2017

function varargout = ci(varargin)
% CI MATLAB code for ci.fig
%      CI, by itself, creates a new CI or raises the existing
%      singleton*.
%
%      H = CI returns the handle to a new CI or the handle to
%      the existing singleton*.
%
%      CI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CI.M with the given input arguments.
%
%      CI('Property','Value',...) creates a new CI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ci_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ci_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ci

% Last Modified by GUIDE v2.5 31-Aug-2017 18:50:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ci_OpeningFcn, ...
                   'gui_OutputFcn',  @ci_OutputFcn, ...
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


% --- Executes just before ci is made visible.
function ci_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ci (see VARARGIN)

% Choose default command line output for ci
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ci wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.bbs_txt, 'Visible', 'off');

setpixelposition(handles.radius1_pop,[3, 10, 70, 40]);
setpixelposition(handles.radius2_pop,[87, 10, 70, 40]);

setpixelposition(handles.w_1_pop,[79, 5, 70, 40]);
setpixelposition(handles.w_2_pop,[153, 5, 70, 40]);

set(handles.axes1,... 
        'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    
set(handles.wiener_check,'Value', 1);
set(handles.dark_check,'Value', 1); 
set(handles.w_1_pop, 'string', {1:10}, 'Value', 5);
set(handles.w_2_pop, 'string', {1:10}, 'Value', 5);

set(handles.radius1_pop, 'string', {1:20}, 'Value', 1, 'Visible' , 'on');
set(handles.radius2_pop, 'string', {1:20}, 'Value', 3,  'Visible' , 'on');

set(handles.sensitivity_slider, 'SliderStep', [0.01, 0.1], 'Value', 0.94);
set(handles.threshold_slider, 'SliderStep', [0.01, 0.1], 'Value', 0.14);

set(handles.sensitivity_txt, 'String', '0.94');
set(handles.threshold_txt, 'String', '0.14');

set(handles.contrast_low_slider,'Min', 0, 'Max', 1, 'SliderStep', [0.01, 0.1], 'Value', 0);
set(handles.contrast_high_slider, 'Min', 0, 'Max', 1,'SliderStep', [0.01, 0.1], 'Value', 0.8);

set(handles.contrast_low_txt, 'String', '0');
set(handles.contrast_high_txt, 'String', '0.8');

set(handles.contrast_low_txt, 'Enable', 'off');
set(handles.contrast_high_txt, 'Enable', 'off');
set(handles.contrast_low_slider, 'Enable', 'off');
set(handles.contrast_high_slider, 'Enable', 'off');
set(handles.sensitivity_txt, 'Enable', 'off');
set(handles.threshold_txt, 'Enable', 'off');
set(handles.sensitivity_slider, 'Enable', 'off');
set(handles.threshold_slider, 'Enable', 'off');
set(handles.radius1_pop, 'Enable', 'off');
set(handles.radius2_pop, 'Enable', 'off');
set(handles.dark_check,'Enable', 'off'); 
set(handles.bright_check,'Enable', 'off'); 
set(handles.analyze_button, 'Enable', 'off');
set(handles.add_button, 'Enable', 'off');
set(handles.wiener_check, 'Enable','off');
set(handles.w_1_pop, 'Enable','off');
set(handles.w_2_pop, 'Enable','off');
set(handles.manual_check, 'Enable','off');
set(handles.reset_button, 'Enable', 'off');

set(handles.text5, 'Visible', 'off');
set(handles.dice_txt, 'Visible', 'off'); 

% --- Outputs from this function are returned to the command line.
function varargout = ci_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global img_url;
[f p] = uigetfile({'*.dcm','DICOM Files'});

try
    img_d = dicomread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));

    imshow(img,'Parent',handles.axes1);
    img_url = strcat(p,f);

    ci_loadingF(handles,img_url);
    
    set(handles.contrast_low_txt, 'Enable', 'on');
    set(handles.contrast_high_txt, 'Enable', 'on');
    set(handles.contrast_low_slider, 'Enable', 'on');
    set(handles.contrast_high_slider, 'Enable', 'on');
    set(handles.sensitivity_txt, 'Enable', 'on');
    set(handles.threshold_txt, 'Enable', 'on');
    set(handles.sensitivity_slider, 'Enable', 'on');
    set(handles.threshold_slider, 'Enable', 'on');
    set(handles.radius1_pop, 'Enable', 'on');
    set(handles.radius2_pop, 'Enable', 'on');
    set(handles.dark_check,'Enable', 'on'); 
    set(handles.bright_check,'Enable', 'on'); 
    set(handles.analyze_button, 'Enable', 'on');
    set(handles.wiener_check, 'Enable','on');
    set(handles.w_1_pop, 'Enable','on');
    set(handles.w_2_pop, 'Enable','on');
    set(handles.manual_check, 'Enable','on');
    set(handles.reset_button, 'Enable', 'on');
    set(handles.text5, 'Visible', 'off');
    set(handles.dice_txt, 'Visible', 'off'); 

catch
    h = msgbox('Please upload an image');
end

    
% --- Executes on button press in analyze_button.
function analyze_button_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.analyze_button, 'Enable', 'off');
global img_url;
ciF(handles,img_url); 
set(handles.load_button, 'Visible', 'off');
set(handles.add_button, 'Enable', 'on');
set(handles.text5, 'Visible', 'on');
set(handles.dice_txt, 'Visible', 'on'); 


% --- Executes on button press in add_button.
function add_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global img_url;
[f p] = uigetfile({'*.dcm','DICOM Files'});

try
    img_d = dicomread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));

    imshow(img,'Parent',handles.axes1);
    img_url = strcat(p,f);

    ci_loadingF(handles,img_url);
    set(handles.analyze_button, 'Enable', 'on');
    set(handles.text5, 'Visible', 'off');
    set(handles.dice_txt, 'Visible', 'off'); 

    
catch
    h = msgbox('Please upload an image');
end


% --- Executes on selection change in radius2_pop.
function radius2_pop_Callback(hObject, eventdata, handles)
% hObject    handle to radius2_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns radius2_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from radius2_pop
global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function radius2_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius2_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in radius1_pop.
function radius1_pop_Callback(hObject, eventdata, handles)
% hObject    handle to radius1_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns radius1_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from radius1_pop
global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function radius1_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius1_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function comment_txt_Callback(hObject, eventdata, handles)
% hObject    handle to comment_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comment_txt as text
%        str2double(get(hObject,'String')) returns contents of comment_txt as a double


% --- Executes during object creation, after setting all properties.
function comment_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comment_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function contrast_high_slider_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_high_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get(handles.contrast_high_slider, 'Value');
set(handles.contrast_high_txt, 'String', num2str(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function contrast_high_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_high_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function contrast_high_txt_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_high_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contrast_high_txt as text
%        str2double(get(hObject,'String')) returns contents of contrast_high_txt as a double
a = get(handles.contrast_high_txt, 'String');
set(handles.contrast_high_slider, 'Value', str2num(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function contrast_high_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_high_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in wiener_check.
function wiener_check_Callback(hObject, eventdata, handles)
% hObject    handle to wiener_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wiener_check
global img_url;
ci_loadingF(handles,img_url);

% --- Executes on selection change in w_1_pop.
function w_1_pop_Callback(hObject, eventdata, handles)
% hObject    handle to w_1_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns w_1_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from w_1_pop
global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function w_1_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w_1_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in w_2_pop.
function w_2_pop_Callback(hObject, eventdata, handles)
% hObject    handle to w_2_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns w_2_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from w_2_pop
global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function w_2_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w_2_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function threshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get(handles.threshold_slider, 'Value');
set(handles.threshold_txt, 'String', num2str(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function threshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function threshold_txt_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_txt as text
%        str2double(get(hObject,'String')) returns contents of threshold_txt as a double
a = get(handles.threshold_txt, 'String');
set(handles.threshold_slider, 'Value', str2num(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function threshold_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sensitivity_slider_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get(handles.sensitivity_slider, 'Value');
set(handles.sensitivity_txt, 'String', num2str(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function sensitivity_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensitivity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sensitivity_txt_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivity_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sensitivity_txt as text
%        str2double(get(hObject,'String')) returns contents of sensitivity_txt as a double
a = get(handles.sensitivity_txt,'String');
set(handles.sensitivity_slider, 'Value', str2num(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function sensitivity_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensitivity_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dark_check.
function dark_check_Callback(hObject, eventdata, handles)
% hObject    handle to dark_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dark_check
set(handles.bright_check, 'Value', 0);

global img_url;
ci_loadingF(handles,img_url);

% --- Executes on button press in bright_check.
function bright_check_Callback(hObject, eventdata, handles)
% hObject    handle to bright_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bright_check
set(handles.dark_check, 'Value', 0);

global img_url;
ci_loadingF(handles,img_url);

% --- Executes on slider movement.
function contrast_low_slider_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_low_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
a = get(handles.contrast_low_slider, 'Value');
set(handles.contrast_low_txt, 'String', num2str(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function contrast_low_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_low_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function contrast_low_txt_Callback(hObject, eventdata, handles)
% hObject    handle to contrast_low_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of contrast_low_txt as text
%        str2double(get(hObject,'String')) returns contents of contrast_low_txt as a double
a = get(handles.contrast_low_txt, 'String');
set(handles.contrast_low_slider, 'Value', str2num(a));

global img_url;
ci_loadingF(handles,img_url);

% --- Executes during object creation, after setting all properties.
function contrast_low_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contrast_low_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in home_button.
function home_button_Callback(hObject, eventdata, handles)
% hObject    handle to home_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(ci);
run('qalma');


% --- Executes on button press in manual_check.
function manual_check_Callback(hObject, eventdata, handles)
% hObject    handle to manual_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manual_check
global img_url;

if get(handles.manual_check, 'Value') == 1
    h = msgbox('Please click on the BBs after clicking the analyze button');
    try
        ci_loadingF(handles,img_url);
    catch
        h1 = msgbox('Please load an image first');
    end
else
    try
        ci_loadingF(handles,img_url);
    catch
        h1 = msgbox('Please load an image first');
    end 
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
clearvars;


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wiener_check,'Value', 1);
set(handles.dark_check,'Value', 1); 
set(handles.w_1_pop, 'string', {1:10}, 'Value', 5);
set(handles.w_2_pop, 'string', {1:10}, 'Value', 5);

set(handles.radius1_pop, 'string', {1:20}, 'Value', 1, 'Visible' , 'on');
set(handles.radius2_pop, 'string', {1:20}, 'Value', 3,  'Visible' , 'on');

set(handles.sensitivity_slider, 'SliderStep', [0.01, 0.1], 'Value', 0.94);
set(handles.threshold_slider, 'SliderStep', [0.01, 0.1], 'Value', 0.14);

set(handles.sensitivity_txt, 'String', '0.94');
set(handles.threshold_txt, 'String', '0.14');

set(handles.contrast_low_slider,'Min', 0, 'Max', 1, 'SliderStep', [0.01, 0.1], 'Value', 0);
set(handles.contrast_high_slider, 'Min', 0, 'Max', 1,'SliderStep', [0.01, 0.1], 'Value', 0.8);

set(handles.contrast_low_txt, 'String', '0');
set(handles.contrast_high_txt, 'String', '0.8');

set(handles.text5, 'Visible', 'off');
set(handles.dice_txt, 'Visible', 'off'); 

global img_url;
ci_loadingF(handles,img_url);

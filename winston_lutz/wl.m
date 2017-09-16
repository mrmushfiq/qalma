% M. Mushfiqur Rahman
% Florida Atlantic University
% August, 2017

function varargout = wl(varargin)
% WL MATLAB code for wl.fig
%      WL, by itself, creates a new WL or raises the existing
%      singleton*.
%
%      H = WL returns the handle to a new WL or the handle to
%      the existing singleton*.
%
%      WL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WL.M with the given input arguments.
%
%      WL('Property','Value',...) creates a new WL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wl

% Last Modified by GUIDE v2.5 25-Aug-2017 22:33:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wl_OpeningFcn, ...
                   'gui_OutputFcn',  @wl_OutputFcn, ...
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


% --- Executes just before wl is made visible.
function wl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wl (see VARARGIN)

% Choose default command line output for wl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wl wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global mag_count;
mag_count = 0; 

set(handles.radiation_slider, 'Min',0,'Max',100,'Value', 14);
set(handles.ball_slider,'Min',0,'Max',100,'Value', 13);
set(handles.ball_txt, 'String', 13);
set(handles.radiation_txt, 'String', 14);

set(handles.axes1, 'Visible', 'off');
set(handles.axes2, 'Visible', 'off');
set(handles.axes3, 'Visible', 'off');


set(handles.radiation_slider, 'Visible', 'off');
set(handles.radiation_txt, 'Visible', 'off');
set(handles.ball_slider, 'Visible', 'off');
set(handles.ball_txt, 'Visible', 'off');
set(handles.text7, 'Visible', 'off');

set(handles.original_label, 'Visible', 'off');
set(handles.filter1_label, 'Visible', 'off');
set(handles.filter2_label, 'Visible', 'off');
set(handles.analyze_button, 'Visible', 'on');

set(handles.distance_label, 'Visible', 'off');
set(handles.distance_txt, 'Visible', 'off');

set(handles.report_button, 'Visible', 'on');

set(handles.uitable1, 'visible', 'off');
set(handles.uitable1, 'Data', []);
set(handles.uitable1, 'ColumnName', {'Image', 'Distance(mm)', 'Comment'});

set(handles.mag_txt, 'String', '1');
set(handles.res_txt, 'String', '0.34');

set(handles.zoom_pop, 'String', {1:10}, 'Value', 6);
set(handles.analyze_button, 'Enable', 'off');
set(handles.report_button, 'Enable', 'off');
set(handles.zoom_pop, 'Enable', 'off');



% --- Outputs from this function are returned to the command line.
function varargout = wl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function ball_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ball_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global img;
global img_url; 

v = get(handles.ball_slider, 'Value');
set(handles.ball_txt, 'String', num2str(v));
wlF_loading(handles,img_url); 



% --- Executes during object creation, after setting all properties.
function ball_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ball_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ball_txt_Callback(hObject, eventdata, handles)
% hObject    handle to ball_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ball_txt as text
%        str2double(get(hObject,'String')) returns contents of ball_txt as a double
global img;
global img_url; 

s= get(handles.ball_txt, 'String');
set(handles.ball_slider, 'Value', str2num(s));
wlF_loading(handles,img_url); 


% --- Executes during object creation, after setting all properties.
function ball_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ball_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function radiation_slider_Callback(hObject, eventdata, handles)
% hObject    handle to radiation_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global img;
global img_url; 
v = get(handles.radiation_slider, 'Value');
set(handles.radiation_txt, 'String', num2str(v));
wlF_loading(handles,img_url); 



% --- Executes during object creation, after setting all properties.
function radiation_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiation_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function radiation_txt_Callback(hObject, eventdata, handles)
% hObject    handle to radiation_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radiation_txt as text
%        str2double(get(hObject,'String')) returns contents of radiation_txt as a double
global img;
global img_url; 

s = get(handles.radiation_txt, 'String');
set(handles.radiation_slider, 'Value', str2num(s));
wlF_loading(handles,img_url); 


% --- Executes during object creation, after setting all properties.
function radiation_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiation_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img; 
global file_name; 
global img_url; 
[f p] = uigetfile(...    
    {'*.dcm','Supported Files (*.dcm)'; ...
 },...    
    'MultiSelect', 'off');

try
    %img_d = imread([p f]);
    img_d = dicomread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));

    file_name = f;

    set(handles.axes1, 'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    set(handles.axes2, 'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    set(handles.axes3, 'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);

    set(handles.radiation_slider, 'Visible', 'on');
    set(handles.radiation_txt, 'Visible', 'on');
    set(handles.ball_slider, 'Visible', 'on');
    set(handles.ball_txt, 'Visible', 'on');

    set(handles.original_label, 'Visible', 'on');
    set(handles.filter1_label, 'Visible', 'on');
    set(handles.filter2_label, 'Visible', 'on');
    set(handles.analyze_button, 'Visible', 'on');

    set(handles.distance_label, 'Visible', 'on');
    set(handles.distance_txt, 'Visible', 'on');

    imshow(img,'Parent',handles.axes1);
    img_url = strcat(p,f);
    wlF_loading(handles,img_url); 
    set(handles.analyze_button, 'Enable', 'on');
    set(handles.zoom_pop, 'Enable', 'on');

catch
    h = msgbox('Please upload an image');
end


% --- Executes on button press in analyze_button.
function analyze_button_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global file_name;
global img_url; 
set(handles.report_button, 'Visible', 'on');
wlF(handles,img_url); 
set(handles.uitable1, 'visible', 'on');
set(handles.load_button, 'Visible', 'off'); 
set(handles.text7, 'Visible', 'on');
set(handles.report_button, 'Enable', 'on');


D = get(handles.uitable1, 'Data');

[r,c] = size(D);
D{r+1,1} = file_name; 
D{r+1,2} = get(handles.distance_txt, 'String'); 
D{r+1,3} = get(handles.comment_txt, 'String');

set(handles.uitable1, 'Data', D);
set(handles.row_pop, 'String', {1:r+1});

% --- Executes on button press in instructions_button.
function instructions_button_Callback(hObject, eventdata, handles)
% hObject    handle to instructions_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in report_button.
function report_button_Callback(hObject, eventdata, handles)
% hObject    handle to report_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

frame = getframe(handles.axes1);
imf = frame2im(frame);
%imwrite(imf, 'wl_result.png');
tc = get(handles.comment_txt, 'String'); 
tc = strcat('Comment : ', tc);
dist = get(handles.distance_txt, 'String');
dist = strcat('Distance between the centers : ', dist);
texts = {dist,' ', tc};

D = get(handles.uitable1, 'Data');


f1=figure
t = uitable(f1,'Data',D,'Position',[20 60 400 300]);
t.ColumnName = {'Image','Distance(mm)','Comment'};


saveas(f1, 'wl_report.pdf')


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


% --- Executes on button press in add_image.
function add_image_Callback(hObject, eventdata, handles)
% hObject    handle to add_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img; 
global file_name;
global img_url; 

[f p] = uigetfile(...    
    {'*.dcm','Supported Files (*.dcm)'; ...
 },...    
    'MultiSelect', 'off');


% [f p] = uigetfile(...    
%     {'*.jpg; *.JPG; *.jpeg; *.JPEG; *.img; *.IMG; *.tif;*.png; .dcm;*.TIF; *.tiff, *.TIFF','Supported Files (*.dcm,*.jpg,*.img,*.tiff,*.png)'; ...
%     '*.jpg','jpg Files (*.jpg)';...
%     '*.JPG','JPG Files (*.JPG)';...
%     '*.jpeg','jpeg Files (*.jpeg)';...
%     '*.JPEG','JPEG Files (*.JPEG)';...
%     '*.img','img Files (*.img)';...
%     '*.IMG','IMG Files (*.IMG)';...
%     '*.tif','tif Files (*.tif)';...
%     '*.TIF','TIF Files (*.TIF)';...
%     '*.tiff','tiff Files (*.tiff)';...
%     '*.TIFF','TIFF Files (*.TIFF)'},...    
%     'MultiSelect', 'off');

try
    %img_d = imread([p f]);
    img_d = dicomread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));
    file_name = f; 

    set(handles.axes1, 'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    set(handles.axes2, 'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    set(handles.axes3, 'Visible', 'on', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);

    set(handles.radiation_slider, 'Visible', 'on');
    set(handles.radiation_txt, 'Visible', 'on');
    set(handles.ball_slider, 'Visible', 'on');
    set(handles.ball_txt, 'Visible', 'on');

    set(handles.original_label, 'Visible', 'on');
    set(handles.filter1_label, 'Visible', 'on');
    set(handles.filter2_label, 'Visible', 'on');
    set(handles.analyze_button, 'Visible', 'on');

    set(handles.distance_label, 'Visible', 'on');
    set(handles.distance_txt, 'Visible', 'on');

    imshow(img,'Parent',handles.axes1);
    img_url = strcat(p,f);
    wlF_loading(handles,img_url); 
    set(handles.analyze_button, 'Enable', 'on');
    set(handles.zoom_pop, 'Enable', 'on');


catch
    h = msgbox('Please upload an image');
end



function res_txt_Callback(hObject, eventdata, handles)
% hObject    handle to res_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of res_txt as text
%        str2double(get(hObject,'String')) returns contents of res_txt as a double


% --- Executes during object creation, after setting all properties.
function res_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to res_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mag_txt_Callback(hObject, eventdata, handles)
% hObject    handle to mag_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mag_txt as text
%        str2double(get(hObject,'String')) returns contents of mag_txt as a double


% --- Executes during object creation, after setting all properties.
function mag_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mag_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to comment_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comment_txt as text
%        str2double(get(hObject,'String')) returns contents of comment_txt as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comment_txt (see GCBO)
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
close(wl);
run('qalma');


% --- Executes on selection change in zoom_pop.
function zoom_pop_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zoom_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zoom_pop
global img;
global img_url; 

wlF_loading(handles,img_url); 


% --- Executes during object creation, after setting all properties.
function zoom_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoom_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in delete_button.
function delete_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
D = get(handles.uitable1, 'Data');

[r,c] = size(D);
row = get(handles.row_pop, 'Value');

if r>0
   D(row,:) = [];
end

set(handles.uitable1, 'Data', D);


% --- Executes on selection change in row_pop.
function row_pop_Callback(hObject, eventdata, handles)
% hObject    handle to row_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns row_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from row_pop


% --- Executes during object creation, after setting all properties.
function row_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
clearvars;
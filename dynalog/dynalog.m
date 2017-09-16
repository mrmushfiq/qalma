% M. Mushfiqur Rahman
% Florida Atlantic University
% August, 2017


function varargout = dynalog(varargin)
% DYNALOG MATLAB code for dynalog.fig
%      DYNALOG, by itself, creates a new DYNALOG or raises the existing
%      singleton*.
%
%      H = DYNALOG returns the handle to a new DYNALOG or the handle to
%      the existing singleton*.
%
%      DYNALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DYNALOG.M with the given input arguments.
%
%      DYNALOG('Property','Value',...) creates a new DYNALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dynalog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dynalog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dynalog

% Last Modified by GUIDE v2.5 25-Aug-2017 22:37:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dynalog_OpeningFcn, ...
                   'gui_OutputFcn',  @dynalog_OutputFcn, ...
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


% --- Executes just before dynalog is made visible.
function dynalog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dynalog (see VARARGIN)

% Choose default command line output for dynalog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dynalog wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.axes1,'visible','off');
set(handles.report_button,'visible','off');
set(handles.comment_txt,'visible','off');
set(handles.mag_panel, 'visible', 'off');

set(handles.axes2,'visible','off');
set(handles.axes3,'visible','off');
set(handles.axes4,'visible','off');
set(handles.mag_txt, 'String', '1');

% --- Outputs from this function are returned to the command line.
function varargout = dynalog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in a_button.
function a_button_Callback(hObject, eventdata, handles)
% hObject    handle to a_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f_a;
global p_a;
[f_a p_a] = uigetfile(...    
    {'*.dlg'},...    
    'MultiSelect', 'off');
set(handles.file_a_txt, 'String', f_a);

% --- Executes on button press in b_button.
function b_button_Callback(hObject, eventdata, handles)
% hObject    handle to b_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f_b;
global p_b; 
[f_b p_b] = uigetfile(...    
    {'*.dlg'},...    
    'MultiSelect', 'off');
set(handles.file_b_txt, 'String', f_b);


% --- Executes on button press in dynalyze_button.
function dynalyze_button_Callback(hObject, eventdata, handles)
% hObject    handle to dynalyze_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global f_a;
global p_a;
global f_b;
global p_b;
dynalogF(handles, f_a, f_b, p_a, p_b);


% --- Executes on button press in report_button.
function report_button_Callback(hObject, eventdata, handles)
% hObject    handle to report_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tc = get(handles.comment_txt, 'String'); 
tc = strcat('Comment: ', tc);

f2 = figure('Position', [100, 100, 724, 700]);
[picket,map1] = imread('picket_dyn.png');
title('Dynalog Report');

h1=subplot(4,4,1:12); 
imshow(picket,[]);
axis equal;
h2=subplot(4,4,[14,15]);
text(0.3,1,tc); axis off;

saveas(f2,'Dynalog_Report.pdf');



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


% --- Executes on button press in home_button.
function home_button_Callback(hObject, eventdata, handles)
% hObject    handle to home_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(dynalog);
run('qalma');



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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
if exist('picket_dyn.png', 'file')==2
  delete('picket_dyn.png');
end
clearvars;
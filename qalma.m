function varargout = qalma(varargin)
% QALMA MATLAB code for qalma.fig
%      QALMA, by itself, creates a new QALMA or raises the existing
%      singleton*.
%
%      H = QALMA returns the handle to a new QALMA or the handle to
%      the existing singleton*.
%
%      QALMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QALMA.M with the given input arguments.
%
%      QALMA('Property','Value',...) creates a new QALMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qalma_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qalma_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qalma

% Last Modified by GUIDE v2.5 08-Jun-2017 23:41:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qalma_OpeningFcn, ...
                   'gui_OutputFcn',  @qalma_OutputFcn, ...
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


% --- Executes just before qalma is made visible.
function qalma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qalma (see VARARGIN)

% Choose default command line output for qalma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes qalma wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%set(handles.date_txt, 'String', date);

% --- Outputs from this function are returned to the command line.
function varargout = qalma_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ss_button.
function ss_button_Callback(hObject, eventdata, handles)
% hObject    handle to ss_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(qalma);
run('star_shot');


% --- Executes on button press in pf_button.
function pf_button_Callback(hObject, eventdata, handles)
% hObject    handle to pf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(qalma);
%run('./picket_panda8/picket_panda.m');
run('picket_panda');

% --- Executes on button press in wl_button.
function wl_button_Callback(hObject, eventdata, handles)
% hObject    handle to wl_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(qalma);
run('wl');


% --- Executes on button press in lr_button.
function lr_button_Callback(hObject, eventdata, handles)
% hObject    handle to lr_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(qalma);
run('ci');


% --- Executes on button press in lf_button.
function lf_button_Callback(hObject, eventdata, handles)
% hObject    handle to lf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(qalma);
run('dynalog');


% --- Executes on button press in rotate_button.
function rotate_button_Callback(hObject, eventdata, handles)
% hObject    handle to rotate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in crop_button.
function crop_button_Callback(hObject, eventdata, handles)
% hObject    handle to crop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in invert_button.
function invert_button_Callback(hObject, eventdata, handles)
% hObject    handle to invert_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

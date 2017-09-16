% M. Mushfiqur Rahman
% Florida Atlantic University
% August, 2017

function varargout = picket_panda(varargin)
% PICKET_PANDA MATLAB code for picket_panda.fig
%      PICKET_PANDA, by itself, creates a new PICKET_PANDA or raises the existing
%      singleton*.
%
%      H = PICKET_PANDA returns the handle to a new PICKET_PANDA or the handle to
%      the existing singleton*.
%
%      PICKET_PANDA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKET_PANDA.M with the given input arguments.
%
%      PICKET_PANDA('Property','Value',...) creates a new PICKET_PANDA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picket_panda_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picket_panda_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picket_panda

% Last Modified by GUIDE v2.5 23-Aug-2017 18:14:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picket_panda_OpeningFcn, ...
                   'gui_OutputFcn',  @picket_panda_OutputFcn, ...
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


% --- Executes just before picket_panda is made visible.
function picket_panda_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picket_panda (see VARARGIN)

% Choose default command line output for picket_panda
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes picket_panda wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global count; 
count = 0; % go button click counter
global mag_count; %mag button click counter
mag_count = 0; 

set(handles.axes2, 'visible', 'off', 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);

set(handles.axes1, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
set(handles.data_transfer_min, 'Data',[]);

set(handles.smoothing_param,'string','3');
set(handles.picket_num_pop, 'String',{1:10});
set(handles.level_txt, 'String', '26');

set(handles.width_left_txt, 'String', '37');
set(handles.width_right_txt, 'String', '37');
set(handles.w1_pop, 'String', {1:10});
set(handles.w2_pop, 'String', {1:10});
% set(handles.w1_pop, 'Value', 3);
% set(handles.w2_pop, 'Value', 2);
set(handles.w1_pop, 'Value', 5);
set(handles.w2_pop, 'Value', 5);

set(handles.rotate_pop, 'String', [0,90,180,270,360]);
set(handles.rotate_check, 'Value', 1);
set(handles.rotate_pop, 'Value', 1);
set(handles.profile_check, 'Value', 0);
set(handles.wiener_check, 'Value',1);
set(handles.mag_txt, 'String', '1.5');
set(handles.res_txt, 'String', '0.781');

set(handles.go_button, 'Enable', 'off');
set(handles.recalculate_button, 'Enable', 'off');
set(handles.plus_button, 'Enable', 'off');
set(handles.minus_button, 'Enable', 'off');
set(handles.column_mlc, 'Enable', 'off');
set(handles.select_line, 'Enable', 'off');
set(handles.report_button, 'Enable', 'off');
set(handles.rotate_pop, 'Enable', 'off');
set(handles.magnify_button, 'Enable', 'off');
set(handles.clear, 'Enable', 'off');

% --- Outputs from this function are returned to the command line.
function varargout = picket_panda_OutputFcn(hObject, eventdata, handles) 
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
%......
%dicomF(handles);

global img;
[f p] = uigetfile({'*.dcm','DICOM Files'});

try
    img_d = dicomread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));
    %img = imrotate(img, 90);

    imshow(img,'Parent',handles.axes1);
    h = msgbox({'Please select the number of pickets and select the pickets'});
    pause(2)
    delete(h);
    set(handles.go_button, 'Enable', 'on');
    set(handles.rotate_pop, 'Enable', 'on');
    set(handles.magnify_button, 'Enable', 'on');
    set(handles.clear, 'Enable', 'on');
catch
    h = msgbox('Please upload an image');
end



% --- Executes when entered data in editable cell(s) in data_transfer_min.
function data_transfer_min_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to data_transfer_min (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in select_line.
function select_line_Callback(hObject, eventdata, handles)
% hObject    handle to select_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_line contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_line
set(handles.plus_button, 'Enable', 'on');
set(handles.minus_button, 'Enable', 'on');

% --- Executes during object creation, after setting all properties.
function select_line_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plus_button.
function plus_button_Callback(hObject, eventdata, handles)
% hObject    handle to plus_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img;
moveF(handles,img,-1);  %sign = -1 , one pixel movement
%magnifier('aacircle', 20, 'current_positions.png');
set(handles.recalculate_button, 'Enable', 'on');


% --- Executes on button press in minus_button.
function minus_button_Callback(hObject, eventdata, handles)
% hObject    handle to minus_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
moveF(handles,img,+1);
set(handles.recalculate_button, 'Enable', 'on');
%sign = +1 , one pixel movement
%magnifier('aacircle', 20, 'current_positions.png');


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
imshow(img);
h = msgbox({'Please select the number of pickets (or keep as it is) and select the pickets'});
pause(2)
delete(h);
set(handles.go_button, 'Enable', 'on');
set(handles.data_transfer_min, 'Data',[]);
set(handles.column_mlc, 'Enable', 'off');
set(handles.select_line, 'Enable', 'off');



% --- Executes on selection change in column_mlc.
function column_mlc_Callback(hObject, eventdata, handles)
% hObject    handle to column_mlc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns column_mlc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from column_mlc
set(handles.select_line, 'Enable', 'on');

global img;

min_data = get(handles.data_transfer_min, 'Data');
[r,c]= size(min_data);

column = get(handles.column_mlc, 'Value');
min = min_data(:,column); %just getting the column required

my_line = get(handles.select_line,'Value');
xy = get(handles.xy_data,'Data');
x=xy(:,1);

level = str2num(get(handles.level_txt, 'String'));

%for i=my_line:length(min)-1
% min(i) = min(i) + 1;
%end


for i=1:length(min)-1
    leafpos(i) = (min(i) + min(i+1))/2; 
end

imshow(img);

min_s = min;
hold on
p = column;
col = num2str(p);
text([round(x(p))+level],[0],col, 'Color','black')

for j=1:length(leafpos)
%   line([round(x(1))-30 round(x(1))-20],[leafpos(j) leafpos(j)],'Color','r')
    name = num2str(j);
    
    text([round(x(p))],[leafpos(j)],name, 'Color','yellow')
    
    line([round(x(p))+level],[leafpos(j)],'Color','r','Marker','*', 'MarkerSize',3)
end

hold off

hold on

for j=1:length(min_s)
    line([round(x(p))+level-4 round(x(p))+level+11],[min_s(j) min_s(j)],'Color','g')
end


hold off



% --- Executes during object creation, after setting all properties.
function column_mlc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to column_mlc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in magnify_button.
function magnify_button_Callback(hObject, eventdata, handles)
% hObject    handle to magnify_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%im= getimage(handles.axes1);
%magnifier('aacircle', 20, 'current_positions.png');
global mag_count;
mag_count = mag_count + 1;

while mag_count > 0
    if mod(mag_count,2) == 0    
        set(handles.axes2, 'visible', 'off');
        set(get(handles.axes2,'children'),'visible','off');
        %delete(handles.axes2);
        axes(handles.axes1);
        %ginput(0);
        break;
    else
        %[x,y] = ginput; 

        [x,y] = ginput(1); 
        set(handles.axes2, 'visible', 'on');
        frame = getframe(handles.axes1);
        im = frame2im(frame);
        [r,c] = size(im);
        %magnifier('aacircle', 20, im);

        imshow(im,'Parent',handles.axes2);

        axes(handles.axes2);
        zoom(3);
        axis([double(x+10) double(x + 110) double(y-40) double(y)]);
        set(handles.axes2, 'Units', 'pixels', 'Position', [x-3, r-y, 200, 140],...
            'box','off','XTickLabel',[],'xtick',[],'YTickLabel',[],'ytick',[]);
         

    end
end
 %mag_counter =0;
% --- Executes on button press in recalculate_button.
function recalculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to recalculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.recalculate_button, 'Enable', 'off');
set(handles.plus_button, 'Enable', 'off');
set(handles.minus_button, 'Enable', 'off');
set(handles.select_line, 'Enable', 'on');

global img;
recalcF(handles,img);


% --- Executes on button press in report_button.
function report_button_Callback(hObject, eventdata, handles)
% hObject    handle to report_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f2 = figure
f2.Position =  [100, 100, 740, 900];
[snap,map1] = imread('current_positions.png');
[gaps,map2] = imread('edge_gaps.png');
title('Report');
subplot(8,10,1:30), imshow(snap,[]); axis equal;
subplot(8,10,31:80),imshow(gaps,[]); axis equal;
saveas(f2,'Picket_Report.pdf');
 



function smoothing_param_Callback(hObject, eventdata, handles)
% hObject    handle to smoothing_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothing_param as text
%        str2double(get(hObject,'String')) returns contents of smoothing_param as a double


% --- Executes during object creation, after setting all properties.
function smoothing_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothing_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in picket_num_pop.
function picket_num_pop_Callback(hObject, eventdata, handles)
% hObject    handle to picket_num_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns picket_num_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from picket_num_pop
v=get(handles.picket_num_pop, 'Value');
set(handles.column_mlc, 'String', {1:v});

% --- Executes during object creation, after setting all properties.
function picket_num_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to picket_num_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in go_button.
function go_button_Callback(hObject, eventdata, handles)
% hObject    handle to go_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.go_button, 'Enable', 'off');
set(handles.column_mlc, 'Enable', 'on');
set(handles.report_button, 'Enable', 'on');

global img;
dicomF2(handles,img);

min_data = get(handles.data_transfer_min, 'Data');

[r,c]= size(min_data);
pickets = get(handles.picket_num_pop,'Value');
set(handles.column_mlc, 'String',{1:pickets});
set(handles.select_line, 'String',{1:r});

global count;
count = count +1;

function width_right_txt_Callback(hObject, eventdata, handles)
% hObject    handle to width_right_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_right_txt as text
%        str2double(get(hObject,'String')) returns contents of width_right_txt as a double


% --- Executes during object creation, after setting all properties.
function width_right_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_right_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_left_txt_Callback(hObject, eventdata, handles)
% hObject    handle to width_left_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_left_txt as text
%        str2double(get(hObject,'String')) returns contents of width_left_txt as a double


% --- Executes during object creation, after setting all properties.
function width_left_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_left_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in w2_pop.
function w2_pop_Callback(hObject, eventdata, handles)
% hObject    handle to w2_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns w2_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from w2_pop


% --- Executes during object creation, after setting all properties.
function w2_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w2_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in w1_pop.
function w1_pop_Callback(hObject, eventdata, handles)
% hObject    handle to w1_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns w1_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from w1_pop


% --- Executes during object creation, after setting all properties.
function w1_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w1_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rotate_check.
function rotate_check_Callback(hObject, eventdata, handles)
% hObject    handle to rotate_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rotate_check


% --- Executes on selection change in rotate_pop.
function rotate_pop_Callback(hObject, eventdata, handles)
% hObject    handle to rotate_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rotate_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rotate_pop

global img;

v = get(handles.rotate_check, 'Value');
if v ==1
    g = get(handles.rotate_pop, 'Value');
    if g == 2
        img = imrotate(img, 90);
    elseif g == 3
        img = imrotate(img, 180);
    elseif g == 4
        img = imrotate(img, 270);
    elseif g == 5
        img = imrotate(img, 360);
    end
end
imshow(img,'Parent',handles.axes1);

% --- Executes during object creation, after setting all properties.
function rotate_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotate_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in profile_check.
function profile_check_Callback(hObject, eventdata, handles)
% hObject    handle to profile_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of profile_check
global count;
if count > 0 & get(handles.profile_check,'Value')== 1
    openfig('f_x.fig');
end


% --- Executes on button press in wiener_check.
function wiener_check_Callback(hObject, eventdata, handles)
% hObject    handle to wiener_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wiener_check


% --- Executes on button press in home_button.
function home_button_Callback(hObject, eventdata, handles)
% hObject    handle to home_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(picket_panda);
%run('../qalma.m');
run('qalma')



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



function level_txt_Callback(hObject, eventdata, handles)
% hObject    handle to level_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of level_txt as text
%        str2double(get(hObject,'String')) returns contents of level_txt as a double


% --- Executes during object creation, after setting all properties.
function level_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to level_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in profile_v_check.
function profile_v_check_Callback(hObject, eventdata, handles)
% hObject    handle to profile_v_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of profile_v_check
global count; 
if count > 0 & get(handles.profile_v_check,'Value')== 1
    if exist('f_y.fig', 'file')==2
      openfig('f_y.fig');
    end
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

if exist('f_x.fig', 'file')==2
  delete('f_x.fig');
end

if exist('f_y.fig', 'file')==2
  delete('f_y.fig');
end

if exist('f_x_s.fig', 'file')==2
  delete('f_x_s.fig');
end

if exist('f_x.fig', 'file')==2
  delete('f_x.fig');
end

if exist('edge_gaps.png', 'file')==2
  delete('edge_gaps.png');
end

if exist('current_positions.png', 'file')==2
  delete('current_positions.png');
end

clearvars; 
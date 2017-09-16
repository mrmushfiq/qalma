% M. Mushfiqur Rahman
% Florida Atlantic University
% August, 2017

function varargout = star_shot(varargin)
% STAR_SHOT MATLAB code for star_shot.fig
%      STAR_SHOT, by itself, creates a new STAR_SHOT or raises the existing
%      singleton*.
%
%      H = STAR_SHOT returns the handle to a new STAR_SHOT or the handle to
%      the existing singleton*.
%
%      STAR_SHOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STAR_SHOT.M with the given input arguments.
%
%      STAR_SHOT('Property','Value',...) creates a new STAR_SHOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before star_shot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to star_shot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help star_shot

% Last Modified by GUIDE v2.5 25-Aug-2017 22:35:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @star_shot_OpeningFcn, ...
                   'gui_OutputFcn',  @star_shot_OutputFcn, ...
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


% --- Executes just before star_shot is made visible.
function star_shot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to star_shot (see VARARGIN)

% Choose default command line output for star_shot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes star_shot wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.axes1, 'box','off','XTickLabel',[],'xtick',[],'YTickLabel',[],'ytick',[]);
%set(handles.num_arms_pop, 'String',{4:24});
set(handles.axes2, 'visible', 'off');
set(handles.axes3, 'visible', 'off');
set(handles.radius_name, 'visible', 'off');
set(handles.radius_txt, 'visible', 'off');
set(handles.comment_txt, 'visible', 'on');
set(handles.report_button, 'visible', 'on');
set(handles.mm_txt, 'visible', 'off');

set(handles.uitable1, 'visible', 'off');
set(handles.uitable1, 'Data', []);
set(handles.uitable1, 'ColumnName', {'Image','Gantry','Couch', 'Collimator', 'Radius(mm)','Comment'});

set(handles.wiener_check, 'Value', 1);
set(handles.w1_pop, 'String',{1:10}, 'Value', 8);
set(handles.w2_pop, 'String',{1:10}, 'Value', 8);
set(handles.avg_txt, 'String', '2');
set(handles.crop_check, 'Value', 1);
set(handles.resolution_txt, 'String', '0.39');
set(handles.mag_factor_txt, 'String', '1'); 

set(handles.analyze_button, 'Enable', 'off');
set(handles.report_button, 'Enable', 'off');
set(handles.add_button, 'Enable', 'off');
warning('off','all')


global analyzer;
analyzer = 0; 

global c1;
global c2;
global c3; 
c1 = get(handles.gantry_check, 'Value');
c2 = get(handles.couch_check, 'Value');
c3 = get(handles.collimator_check, 'Value');

% --- Outputs from this function are returned to the command line.
function varargout = star_shot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global file_name;

[f p] = uigetfile(...    
    {'*.jpg; *.JPG; *.jpeg; *.JPEG; *.img; *.IMG; *.tif;*.png; *.TIF; *.tiff, *.TIFF','Supported Files (*.jpg,*.img,*.tiff,*.png)'; ...
    '*.jpg','jpg Files (*.jpg)';...
    '*.JPG','JPG Files (*.JPG)';...
    '*.jpeg','jpeg Files (*.jpeg)';...
    '*.JPEG','JPEG Files (*.JPEG)';...
    '*.img','img Files (*.img)';...
    '*.IMG','IMG Files (*.IMG)';...
    '*.tif','tif Files (*.tif)';...
    '*.TIF','TIF Files (*.TIF)';...
    '*.tiff','tiff Files (*.tiff)';...
    '*.TIFF','TIFF Files (*.TIFF)'},...    
    'MultiSelect', 'off');

try    
    img_d = imread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));
    imshow(img,'Parent',handles.axes1);
    img = img_d;
    file_name = f; 
    set(handles.analyze_button, 'Enable', 'on');
    set(handles.report_button, 'Enable', 'on');
    set(handles.add_button, 'Enable', 'on');

catch
    h = msgbox('Please upload an image');
end

% --- Executes on button press in analyze_button.
function analyze_button_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.analyze_button, 'Enable', 'off');
global img;
global file_name; 
global analyzer;


analyzer = analyzer + 1; 
%starF(handles,img);

[radii,pass] = starF(handles,img);

if pass == 1

    set(handles.browse_button, 'Visible', 'off'); 
    setpixelposition(handles.uitable1,[65, 10, 490, 127]);
    set(handles.uitable1, 'visible', 'on');

    global c1;
    global c2;
    global c3;


    c1 = get(handles.gantry_check, 'Value');
    c2 = get(handles.couch_check, 'Value');
    c3 = get(handles.collimator_check, 'Value');

    D = get(handles.uitable1, 'Data');

    [r,c] = size(D);
    D{r+1,1} = file_name; 

    if c1==1
        D{r+1,2} = '   X   ';
    elseif c2 == 1
        D{r+1,3} = '   X   ';
    elseif c3 == 1
        D{r+1,4} = '   X   '; 
    else
        h = msgbox({'Check at least one of the three components'});
        pause(2)
        delete(h);
    end 

    D{r+1,5} = get(handles.radius_txt, 'String');
%     if pass == 1
%         D{r+1,5} = get(handles.radius_txt, 'String'); 
%     else
%         D{r+1,5} = '-';
%     end

    D{r+1,6} = get(handles.comment_txt, 'String');

    set(handles.uitable1, 'Data', D);
    set(handles.row_pop, 'String', {1:r+1});
end

% --- Executes on selection change in num_arms_pop.
function num_arms_pop_Callback(hObject, eventdata, handles)
% hObject    handle to num_arms_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns num_arms_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from num_arms_pop


% --- Executes during object creation, after setting all properties.
function num_arms_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_arms_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_txt_Callback(hObject, eventdata, handles)
% hObject    handle to radius_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius_txt as text
%        str2double(get(hObject,'String')) returns contents of radius_txt as a double


% --- Executes during object creation, after setting all properties.
function radius_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in report_button.
function report_button_Callback(hObject, eventdata, handles)
% hObject    handle to report_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tc = get(handles.comment_txt, 'String'); 
tc = strcat('Comment:', tc);
result = get(handles.radius_txt, 'String');
result = strcat('Radius: ',result); 
D = get(handles.uitable1, 'Data');


f2=figure
t = uitable(f2,'Data',D,'Position',[20 60 500 300]);
t.ColumnName = {'Image','Gantry','Couch', 'Collimator', 'Radius(mm)','Comment'}

saveas(f2,'Star_Report.pdf');


% --- Executes on button press in add_button.
function add_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
global file_name;
%set(handles.axes2, 'visible', 'off');
set(handles.axes2, 'Units', 'pixels', 'Position', [300, 300, 10, 10]);

[f p] = uigetfile(...    
    {'*.jpg; *.JPG; *.jpeg; *.JPEG; *.img; *.IMG; *.tif;*.png; *.TIF; *.tiff, *.TIFF','Supported Files (*.jpg,*.img,*.tiff,*.png)'; ...
    '*.jpg','jpg Files (*.jpg)';...
    '*.JPG','JPG Files (*.JPG)';...
    '*.jpeg','jpeg Files (*.jpeg)';...
    '*.JPEG','JPEG Files (*.JPEG)';...
    '*.img','img Files (*.img)';...
    '*.IMG','IMG Files (*.IMG)';...
    '*.tif','tif Files (*.tif)';...
    '*.TIF','TIF Files (*.TIF)';...
    '*.tiff','tiff Files (*.tiff)';...
    '*.TIFF','TIFF Files (*.TIFF)'},...    
    'MultiSelect', 'off');

try
    img_d = imread([p f]);
    img=im2double(img_d);
    img=uint8(255*mat2gray(img));
    set(handles.axes1, 'Units', 'pixels', 'Position', [37, 99, 544, 397]);
    imshow(img,'Parent',handles.axes1);

    setpixelposition(handles.uitable1,[65, 10, 490, 70]);

    img = img_d;
    file_name = f; 
    set(handles.analyze_button, 'Enable', 'on');

catch
    h = msgbox('Please upload an image');
end

%imshow(img,'Parent',handles.axes1);

% --- Executes on button press in gantry_check.
function gantry_check_Callback(hObject, eventdata, handles)
% hObject    handle to gantry_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gantry_check
set(handles.couch_check,'Value',0); 
set(handles.collimator_check,'Value',0); 


% --- Executes on button press in couch_check.
function couch_check_Callback(hObject, eventdata, handles)
% hObject    handle to couch_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of couch_check
set(handles.gantry_check,'Value',0); 
set(handles.collimator_check,'Value',0); 

% --- Executes on button press in collimator_check.
function collimator_check_Callback(hObject, eventdata, handles)
% hObject    handle to collimator_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of collimator_check
set(handles.couch_check,'Value',0); 
set(handles.gantry_check,'Value',0); 


% --- Executes on button press in delete_row_button.
function delete_row_button_Callback(hObject, eventdata, handles)
% hObject    handle to delete_row_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in manual_check.
function manual_check_Callback(hObject, eventdata, handles)
% hObject    handle to manual_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manual_check



function rotate_txt_Callback(hObject, eventdata, handles)
% hObject    handle to rotate_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotate_txt as text
%        str2double(get(hObject,'String')) returns contents of rotate_txt as a double
% global img;
% angle = str2num(get(handles.rotate_txt,'String'));
% 
% if get(handles.manual_check, 'Value') == 1
%     img = imrotate(img, angle);
%     imshow(img,'Parent',handles.axes2);
% else
%     h = msgbox({'Please Activate Manual mode'});
%     pause(1)
%     delete(h);
% end

% --- Executes during object creation, after setting all properties.
function rotate_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotate_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in center_check.
function center_check_Callback(hObject, eventdata, handles)
% hObject    handle to center_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of center_check


% --- Executes on button press in invert_check.
function invert_check_Callback(hObject, eventdata, handles)
% hObject    handle to invert_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of invert_check
global img;
v1 = get(handles.manual_check, 'Value');
v2 = get(handles.invert_check, 'Value');
if v1 == 1 & v2 == 1
    img = imcomplement(img);
    imshow(img,'Parent',handles.axes1);
end
set(handles.invert_check, 'Value',0);

% --- Executes on button press in analyze_button.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function avg_txt_Callback(hObject, eventdata, handles)
% hObject    handle to avg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avg_txt as text
%        str2double(get(hObject,'String')) returns contents of avg_txt as a double


% --- Executes during object creation, after setting all properties.
function avg_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avg_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in report_button.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to report_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in wiener_check.
function wiener_check_Callback(hObject, eventdata, handles)
% hObject    handle to wiener_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of wiener_check



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to comment_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comment_txt as text
%        str2double(get(hObject,'String')) returns contents of comment_txt as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comment_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mag_factor_txt_Callback(hObject, eventdata, handles)
% hObject    handle to mag_factor_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mag_factor_txt as text
%        str2double(get(hObject,'String')) returns contents of mag_factor_txt as a double


% --- Executes during object creation, after setting all properties.
function mag_factor_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mag_factor_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resolution_txt_Callback(hObject, eventdata, handles)
% hObject    handle to resolution_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolution_txt as text
%        str2double(get(hObject,'String')) returns contents of resolution_txt as a double


% --- Executes during object creation, after setting all properties.
function resolution_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolution_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in crop_check.
function crop_check_Callback(hObject, eventdata, handles)
% hObject    handle to crop_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crop_check


% --- Executes on button press in home_button.
function home_button_Callback(hObject, eventdata, handles)
% hObject    handle to home_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(star_shot);
run('qalma');


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);

if exist('starshot.png', 'file')==2
  delete('starshot.png');
end

if exist('starshot_zoomed.png', 'file')==2
  delete('starshot_zoomed.png');
end
clearvars;
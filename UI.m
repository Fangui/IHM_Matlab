function [x,y,z] = UI(varargin)

% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 06-Jul-2017 09:19:30

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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
end


function [files, vectPath] = fillVector(f, files, vectPath)
matFiles = dir(fullfile(f, '*.mat'));
size = length(matFiles);
x = 1;
while x <= size
    name = matFiles(x).name;
    clear CtrlHPF;
    try
        load(name ,'CtrlHPF');
    catch
        warning('Fail load');
    end
    if exist('CtrlHPF', 'var') == 0
        matFiles(x) = [];
        size = size - 1;
    else
        files(end + 1) = matFiles(x);
        vectPath = [vectPath;{f}];
        x = x + 1;
    end
end
[files, vectPath] = callFillVector(f, files, vectPath);
end

function [files vectPath] = callFillVector(f, files, vectPath)

vectFiles = dir(f);
vectDir = vectFiles([vectFiles.isdir]);
for i = 3 : length(vectDir)
    path = f;
    name = vectDir(i).name;
    path = strcat(path, '\');
    path = strcat(path, name);
    cd(path);
    [files, vectPath] = fillVector(path, files, vectPath);
    cd('..');
end

end

% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;
%f = uigetdir('C:\Users\cats\Documents\VP\R_NUMCA_Simulink\Signal');
f = uigetdir('C:\Clement\Matlab');
cd(f);
files = dir(fullfile(f, '*.mat'));
size = length(files);
vectPath = [];
x = 1;
while x <= size
    name = files(x).name;
    clear CtrlHPF;
    load(name ,'CtrlHPF');
    if exist('CtrlHPF', 'var') == 0
        files(x) = [];
        size = size - 1;
    else
        x = x + 1;
        vectPath = [vectPath; {f}];
    end
end

[files vectPath] = callFillVector(f, files, vectPath);

handles.files = files;
handles.vectPath = vectPath;
handles.f = f;
set(handles.text1, 'string', f);
set(handles.listbox1,'string',{files.name});
% Update handles structure
guidata(hObject, handles);
end

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
handles.output = hObject;
files = handles.files;
vectPath = handles.vectPath;
f = handles.f;

index = get(handles.listbox1,'value');
name = files(index).name;
list = get(hObject, 'String');
itemSelected = list{index};

path = char(vectPath(index));

itemSelected = strcat('\', itemSelected);
itemSelected = strcat(path, itemSelected);
set(handles.text1, 'string', itemSelected);

cd;
cd(path);

load(name,'CtrlHPF');
plot(CtrlHPF(9,:));
cd;
cd(f);
guidata(hObject, handles);

% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
%path = get(handles.text1, 'string');

contents = cellstr(get(handles.popupmenu3,'String'));
x = contents{get(handles.popupmenu3,'Value')};

contents = cellstr(get(handles.popupmenu4,'String'));
y = contents{get(handles.popupmenu4,'Value')};

contents = cellstr(get(handles.popupmenu5,'String'));
z = contents{get(handles.popupmenu5,'Value')};

files = handles.files;
index = get(handles.listbox1,'Value');
filename = files(index).name;

vectPath = handles.vectPath;
path = char(vectPath(index));

close all;
AG( x,y,z, path, filename);
end


% --- Executes on selection change in popupmenu3.
function x = popupmenu3_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
x = contents{get(hObject,'Value')};

% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 2);
%set(handles.popupmenu3, 'Value', 2);
end


% --- Executes on selection change in popupmenu4.
function y = popupmenu4_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
y = contents{get(hObject,'Value')};
end

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 3);
end

% --- Executes on selection change in popupmenu5.
function z = popupmenu5_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
z = contents{get(hObject,'Value')};

end
% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Value', 4);
end

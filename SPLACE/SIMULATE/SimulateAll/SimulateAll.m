%{
 Copyright 2013 KIOS Research Center for Intelligent Systems and Networks, University of Cyprus (www.kios.org.cy)

 Licensed under the EUPL, Version 1.1 or � as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
 You may not use this work except in compliance with the Licence.
 You may obtain a copy of the Licence at:

 http://ec.europa.eu/idabc/eupl

 Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the Licence for the specific language governing permissions and limitations under the Licence.
%}

function varargout = SimulateAll(varargin)
% SimulateAll M-file for SimulateAll.fig
% In This M file you can see how the axes along with a patch can be used to
% render a progress bar for your existing Gui. Box Property of the Axes
% must be enabled in order to make the axes look like a progress bar and
% also the xTick & yTick values must be set to empty. In order to change
% the Color of the Patch do pass the color value to changecolor function.
% Run this m file and click on the start button to see how this progress bar works.
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimulateAll_OpeningFcn, ...
                   'gui_OutputFcn',  @SimulateAll_OutputFcn, ...
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


% --- Executes just before SimulateAll is made visible.
function SimulateAll_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimulateAll (see VARARGIN)
% Choose default command line output for SimulateAll
    handles.output = hObject;
    
    handles.file0 = varargin{1}.file0;
    handles.B = varargin{1}.B;
    handles.LoadText = varargin{1}.LoadText;
    handles.runMultipleScenarios = varargin{1}.runMultipleScenarios;
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    if exist([pathname,handles.file0,'.0'],'file')==2
        if ~isempty([handles.file0,'.0']) 
            load([pathname,handles.file0,'.0'],'-mat');
        else
            B.InputFile=handles.B.InputFile;
        end
    else
        B.InputFile=[];
    end

    if ~strcmp(handles.B.InputFile,B.InputFile)
        set(handles.start,'enable','off');
%         set(handles.SaveEveryScenarios,'enable','off');
        %set(handles.EditNumberOfScenarios,'enable','off');
        set(handles.FileText,'String','')
    else
        set(handles.start,'enable','on');
%         set(handles.SaveEveryScenarios,'enable','on');
        %set(handles.EditNumberOfScenarios,'enable','on');
        set(handles.FileText,'String',[handles.file0,'.0'])
        T=100;%SaveEvreyScenarios
        handles.TotalNofSce=P.TotalScenarios;
        if T>handles.TotalNofSce
            T=handles.TotalNofSce;
        end
%         set(handles.SaveEveryScenarios,'String',T);
        set(handles.TotalScenarios,'String',handles.TotalNofSce);
        %set(handles.EditNumberOfScenarios,'String',handles.TotalNofSce);
    end

    set(handles.load,'enable','on');
    handles.str='Simulate All Scenarios';
    set(handles.figure1,'name',handles.str);
    % Update handles structure
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = SimulateAll_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%     handles.T=str2num(get(handles.SaveEveryScenarios, 'String'));
%     if  ~length(handles.T) || handles.T<0 || handles.T>handles.TotalNofSce
%         msgbox('  Give number of save every scenarios', 'Error', 'modal')
%         return
%     end
    
    set(handles.start,'enable','off');
    set(handles.load,'enable','off');
%     handles.binary_file = 1;%get(handles.checkbox1, 'Value');

    runMultipleScenarios(handles)
    %if libisloaded('epanet2')
    %    unloadlibrary('epanet2');
    %end
    %handles.B=epanet(handles.B.InputFile);clc;
    pause(0.1);
    close;

    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{'>>Create Hydraulic and Quality files.'}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg)); 
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%     set(handles.runMultipleScenarios,'enable','off');

    % --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    [file0,pathNM] = uigetfile([pathname,'*.0'],'Select the MATLAB *.0 file');
    if length(pathNM)~=1
        pathname=pathNM;
    end
    
    file0=file0(1:end-2);
    if isnumeric(file0)
        file0=[];
    end
    if ~isempty((file0)) 
        save([pwd,'\RESULTS\','File0.File'],'file0','-mat');
        load([pathname,file0,'.0'],'-mat');
        handles.file0=file0;
        if ~strcmp(handles.B.InputFile,B.InputFile)
            set(handles.start,'enable','off');
            %set(handles.EditNumberOfScenarios,'enable','off');
%             set(handles.SaveEveryScenarios,'enable','off');
            load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            msg=[msg;{['>>Wrong File0 "',file0,'"']}];
            set(handles.LoadText,'String',msg);
            set(handles.LoadText,'Value',length(msg)); 
            save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            set(handles.FileText,'String','')
        else
            set(handles.start,'enable','on');
            %set(handles.EditNumberOfScenarios,'enable','on');
%             set(handles.SaveEveryScenarios,'enable','on');
            T=100;%SaveEvreyScenarios
            handles.TotalNofSce=P.TotalScenarios;
            if T>handles.TotalNofSce
                T=handles.TotalNofSce;
            end
%             set(handles.SaveEveryScenarios,'String',T);
            set(handles.FileText,'String',[handles.file0,'.0'])
            set(handles.TotalScenarios,'String',handles.TotalNofSce);
            %set(handles.EditNumberOfScenarios,'String',handles.TotalNofSce);
        end
        handles.P=P;
        hanldes.B=B;
        % Update handles structure
        guidata(hObject, handles);
    end
    save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function SaveEveryScenarios_Callback(hObject, eventdata, handles)
% hObject    handle to SaveEveryScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaveEveryScenarios as text
%        str2double(get(hObject,'String')) returns contents of SaveEveryScenarios as a double


% --- Executes during object creation, after setting all properties.
function SaveEveryScenarios_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveEveryScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditNumberOfScenarios_Callback(hObject, eventdata, handles)
% hObject    handle to EditNumberOfScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditNumberOfScenarios as text
%        str2double(get(hObject,'String')) returns contents of EditNumberOfScenarios as a double


% --- Executes during object creation, after setting all properties.
function EditNumberOfScenarios_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNumberOfScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function TotalScenarios_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




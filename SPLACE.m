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

function varargout = SPLACE(varargin)
% SPLACE MATLAB code for SPLACE.fig
%      SPLACE, by itself, creates a new SPLACE or raises the existing
%      singleton*.
%
%      H = SPLACE returns the handle to a new SPLACE or the handle to
%      the existing singleton*.
%
%      SPLACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPLACE.M with the given input arguments.
%
%      SPLACE('Property','Value',...) creates a new SPLACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SPLACE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SPLACE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SPLACE

% Last Modified by GUIDE v2.5 28-Jun-2013 16:01:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SPLACE_OpeningFcn, ...
                   'gui_OutputFcn',  @SPLACE_OutputFcn, ...
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

% --- Executes just before SPLACE is made visible.
function SPLACE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SPLACE (see VARARGIN)
    path(path,genpath(pwd));

    % Choose default command line output for SPLACE
    handles.output = hObject;
           
    handles.ZoomIO=1;
    if libisloaded('epanet2')
        unloadlibrary('epanet2');
    end
    pathname=[pwd,'\RESULTS\'];
    save([pathname,'pathname.File'],'pathname','-mat');

    % UIWAIT makes SPLACE wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    opening(hObject, eventdata, handles)
    
function opening(hObject, eventdata, handles)
        

    
    a=imread('Splace.png');
    set(handles.frameOfNet,'Visible','on');
    set(handles.frameOfNet,'CData',a);
    
    set(handles.figure1,'name','S-Place: Quality Sensor Placement in Water Distribution Systems');
    ScreenSize=get(0,'ScreenSize');

    position = get(handles.figure1,'Position');
    %set(handles.figure1,'Position',[ScreenSize(3)/32 ScreenSize(4)/50 177.7 46.8])
%     set(handles.figure1,'Position',[ScreenSize(3)/32 ScreenSize(4)/50 position(3) position(4)]);
    
    set(handles.CreateScenarios,'enable','off');
    set(handles.runMultipleScenarios,'enable','off');
    set(handles.ComputeImpactMatrix,'enable','off');
    set(handles.SolveSensorPlacement,'enable','off');
    set(handles.SplaceTable,'visible','on');
    
    set(handles.SaveNetwork,'visible','off');
    set(handles.Zoom,'visible','off');
    set(handles.NodesID,'visible','off');
    set(handles.LinksID,'visible','off');
    set(handles.FontsizeENplotText,'visible','off');
    set(handles.FontsizeENplot,'visible','off');
    
    set(handles.SplaceTable,'String','');
    set(handles.SplaceTable,'enable','inactive');

    % Functions
    dir_struct = dir(strcat([pwd,'\SPLACE\SCENARIOS\'],''));
    [sorted_names,~] = sortrows({dir_struct.name}');
    for i=3:length(sorted_names)
        [~,name1{i-2},~]=fileparts(sorted_names{i});
    end
    set(handles.methodsScenarios,'String',name1);

    
    dir_struct = dir(strcat([pwd,'\SPLACE\IMPACT\'],''));
    [sorted_names,~] = sortrows({dir_struct.name}');
    for i=3:length(sorted_names)
        [~,name2{i-2},~]=fileparts(sorted_names{i});
    end
    set(handles.Impacts,'String',name2);
    
    dir_struct = dir(strcat([pwd,'\SPLACE\SIMULATE\'],''));
    [sorted_names,~] = sortrows({dir_struct.name}');
    for i=3:length(sorted_names)
        [~,name3{i-2},~]=fileparts(sorted_names{i});
    end
    set(handles.Simulate,'String',name3);
    
    dir_struct = dir(strcat([pwd,'\SPLACE\OPTIMIZATION\'],''));
    [sorted_names,~] = sortrows({dir_struct.name}');
    for i=3:length(sorted_names)
        [~,name4{i-2},~]=fileparts(sorted_names{i});
    end
    set(handles.Optimization,'String',name4);
    
    set(handles.LoadText,'Value',1);
    set(handles.LoadText,'String','S-PLACE:Please Load Input File.');
    
    % Update handles structure
    guidata(hObject, handles);
    
    % --- Outputs from this function are returned to the command line.
function varargout = SPLACE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in LoadInputFile.
function LoadInputFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadInputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.CreateScenarios,'enable','inactive');
    set(handles.runMultipleScenarios,'enable','inactive');
    set(handles.ComputeImpactMatrix,'enable','inactive');
    set(handles.SolveSensorPlacement,'enable','inactive');
    set(handles.Exit,'enable','inactive');
    
    [InputFile,PathFile] = uigetfile('NETWORKS\*.inp');

    PathFile = strcat(PathFile,InputFile);
    if InputFile~=0
        if libisloaded('epanet2')
           unloadlibrary('epanet2');
        end
        col = get(handles.LoadInputFile,'backg');  % Get the background color of the figure.
        set(handles.LoadInputFile,'str','LOADING...','backg','w') % Change color of button. 
        % The pause (or drawnow) is necessary to make button changes appear.
        % To see what this means, try doing this with the pause commented out.
        pause(.1)  % FLUSH the event queue, drawnow would work too.
        % Here is where you put whatever function calls or processes that the
        % pushbutton is supposed to activate. 
        % Next we simulate some running process.  Here just sort a vector.

        % Load Input File
        B=Epanet(PathFile,InputFile); %clc;
        handles.B = B;
        if exist('File0.File','file')==2
            load([pwd,'\RESULTS\','File0.File'],'-mat'); 
            file0=[];
            save([pwd,'\RESULTS\','File0.File'],'file0','-mat')
        end
        if exist([pwd,'\RESULTS\','h1.f'])==2
            delete([pwd,'\RESULTS\','h1.f'],'h1','-mat');
        end
        if exist([pwd,'\RESULTS\','hNodesID.f'])==2
            delete([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');
        end
        if exist([pwd,'\RESULTS\','hLinksID.f'])==2
            delete([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
        end
        
        pathname=[pwd,'\RESULTS\'];
        save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

        if B.errorCode~=0 
            s = sprintf('Could not open network ''%s'', please insert the correct filename(*.inp).\n',InputFile); 
            set(handles.LoadText,'String',s);
            set(handles.LoadInputFile,'str','Load Input File','backg',col);
            return
        end

%         set(handles.LoadText,'String',which(InputFile));
        msg=['>>Load Input File "',InputFile,'" Successful.']; 
        Getmsg=['>>Current version of EPANET:',num2str(B.Version)];
        msg=[msg;{Getmsg}];
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        set(handles.LoadText,'Value',length(msg)); 
        set(handles.LoadText,'String',msg);
        
        set(handles.LoadInputFile,'str','Load Input File','backg',col)  % Now reset the button features.
        % Update handles structure
        guidata(hObject, handles);
        
        axes(handles.axes1)
        B.plot;    
        axis on
        set(handles.axes1,'Color','w')
        set(handles.axes1,'XTick',[])
        set(handles.axes1,'YTick',[])

        set(handles.CreateScenarios,'enable','on');
        set(handles.runMultipleScenarios,'enable','on');
        set(handles.ComputeImpactMatrix,'enable','on');   
        set(handles.SolveSensorPlacement,'enable','on');
        
        % graphs
        set(handles.SaveNetwork,'visible','on');
        set(handles.Zoom,'visible','on');
        set(handles.NodesID,'visible','on');
        set(handles.LinksID,'visible','on');      
        set(handles.NodesID,'value',0);
        set(handles.LinksID,'value',0);
        
        set(handles.FontsizeENplotText,'visible','on');
        set(handles.FontsizeENplot,'visible','on');
        set(handles.SplaceTable,'String','');
            
        set(handles.frameOfNet,'Visible','off');

    else
        if ~libisloaded('epanet2')
            set(handles.CreateScenarios,'enable','off');
            set(handles.runMultipleScenarios,'enable','off');
            set(handles.ComputeImpactMatrix,'enable','off');
            set(handles.SolveSensorPlacement,'enable','off');
            
        else
            set(handles.CreateScenarios,'enable','on');
            set(handles.runMultipleScenarios,'enable','on');
            set(handles.ComputeImpactMatrix,'enable','on');
            set(handles.SolveSensorPlacement,'enable','on');

        end
    end
    
    set(handles.Exit,'enable','on');
% --- Executes on button press in runMultipleScenarios.
function runMultipleScenarios_Callback(hObject, eventdata, handles)
    set(handles.Exit,'enable','inactive');
    set(handles.CreateScenarios,'enable','inactive');
    set(handles.LoadInputFile,'enable','inactive');
    set(handles.ComputeImpactMatrix,'enable','inactive');
    set(handles.SolveSensorPlacement,'enable','inactive');
    
    close(findobj('type','figure','name','Simulate All Scenarios'))
    close(findobj('type','figure','name','Simulate Random Scenarios'))
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');
    
    if exist('File0.File','file')==2 
        load([pwd,'\RESULTS\','File0.File'],'-mat');
        if exist([pathname,file0],'file')==2 
            if ~isempty(file0) 
                load([pathname,file0],'-mat');
            else
                B.InputFile=handles.B.InputFile;
            end
        else
            B.InputFile=[];
        end
%         if ~strcmp(handles.B.InputFile,B.InputFile)         
%             load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%             msg=[msg;{'>>Cannot find file.'}];
%             set(handles.LoadText,'String',msg);
%             msg=[msg;{'>>Load new file0.'}];
%             set(handles.LoadText,'String',msg);
%             set(handles.LoadText,'Value',length(msg)); 
%             save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%         end
    else
        file0=[];
    end

    arguments.file0=file0(1:end-2);
    arguments.B=handles.B;
    arguments.LoadText = handles.LoadText;
    arguments.runMultipleScenarios=handles.runMultipleScenarios;
    tmp1=get(handles.Simulate,'value');
    tmp2=get(handles.Simulate,'string');    
    %runMultipleScenariosGui(arguments);
    t=str2func(tmp2{tmp1});
    t(arguments);
    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{['>>',tmp2{tmp1},' Selected']}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg));
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    
    set(handles.CreateScenarios,'enable','on');
    set(handles.LoadInputFile,'enable','on');
    set(handles.ComputeImpactMatrix,'enable','on');
    set(handles.SolveSensorPlacement,'enable','on');
    set(handles.Exit,'enable','on');
% --- Executes on button press in CreateScenarios.
function CreateScenarios_Callback(hObject, eventdata, handles)
% hObject    handle to CreateScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.runMultipleScenarios,'enable','inactive');
    set(handles.LoadInputFile,'enable','inactive');
    set(handles.ComputeImpactMatrix,'enable','inactive');
    set(handles.SolveSensorPlacement,'enable','inactive');
    set(handles.Exit,'enable','inactive');
    
    close(findobj('type','figure','name','Create Scenarios (Grid)'));
    arguments.LoadText = handles.LoadText;
    arguments.B = handles.B; 
    
    tmp1=get(handles.methodsScenarios,'value');
    tmp2=get(handles.methodsScenarios,'string');    
    %CreateScenariosGui(arguments);
    t=str2func(tmp2{tmp1});
    t(arguments);
    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{['>>',tmp2{tmp1},' Method Selected']}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg));
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    
    set(handles.runMultipleScenarios,'enable','on');
    set(handles.LoadInputFile,'enable','on');
    set(handles.ComputeImpactMatrix,'enable','on');
    set(handles.SolveSensorPlacement,'enable','on');
    set(handles.Exit,'enable','on');
% --- Executes on button press in LoadText.
function LoadText_Callback(hObject, eventdata, handles)
% hObject    handle to LoadText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    delete(hObject);

    if libisloaded('epanet2')
       unloadlibrary('epanet2');
    end
    clc;
    close(findobj('type','figure','name','Release Location'));
    close(findobj('type','figure','name','Solve Sensor Placement'));
    close(findobj('type','figure','name','Compute Impact Matrix (CWCV)'));
    close(findobj('type','figure','name','Solve with exhaustive method..'));
    close(findobj('type','figure','name','Solve with test1 method..'));
    close(findobj('type','figure','name','Solve with test2 method..'));
    close(findobj('type','figure','name','Simulate All Scenarios'));
    close(findobj('type','figure','name','Simulate Random Scenarios'));
    close(findobj('type','figure','name','Create Scenarios (Grid)'));

    rmpath(genpath(pwd));
    
    %Delete s files 
    a='abcdefghijklmnoqrstuvwxyz';
    for i=1:length(a)
        s=sprintf('s%s*',a(i));
        delete(s)
    end
    for i=1:9
        s=sprintf('s%.f*',i);
        delete(s)
    end
    % --- Executes on button press in ComputeImpactMatrix.
function ComputeImpactMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeImpactMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.runMultipleScenarios,'enable','inactive');
    set(handles.LoadInputFile,'enable','inactive');
    set(handles.CreateScenarios,'enable','inactive');
    set(handles.SolveSensorPlacement,'enable','inactive');
    set(handles.Exit,'enable','inactive');
    
    close(findobj('type','figure','name','Compute Impact Matrix (CWCV)'));
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    if exist('File0.File','file')==2 
        load([pwd,'\RESULTS\','File0.File'],'-mat');
        
        if exist([pathname,file0],'file')==2 && exist([pathname,file0(1:end-1),'c0'],'file')==2
            if ~isempty(file0) 
                load([pathname,file0],'-mat');
            else
                B.InputFile=handles.B.InputFile;
            end
        else
            B.InputFile=[];
            load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            set(handles.LoadText,'Value',1);
            msg=[msg;{'>>First must be run Simulate Scenarios.'}];
            set(handles.LoadText,'String',msg);
            set(handles.LoadText,'Value',length(msg)); 
            save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            set(handles.runMultipleScenarios,'enable','on');
            set(handles.LoadInputFile,'enable','on');
            set(handles.CreateScenarios,'enable','on');
            set(handles.SolveSensorPlacement,'enable','on');
            set(handles.Exit,'enable','on');
            return
        end
%         if ~strcmp(handles.B.InputFile,B.InputFile)             
%             load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%             set(handles.LoadText,'Value',1);
%             msg=[msg;{'>>Cannot find file.'}];
%             set(handles.LoadText,'String',msg);
%             msg=[msg;{'>>Load new file0.'}];
%             set(handles.LoadText,'String',msg);
%             set(handles.LoadText,'Value',length(msg)); 
%             save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%         end
    else
        file0=[];
    end

    arguments.file0=file0(1:end-2);
    arguments.B=handles.B;
    arguments.LoadText = handles.LoadText;
    tmp1=get(handles.Impacts,'value');
    tmp2=get(handles.Impacts,'string');    
    %ComputeImpactMatricesGui(arguments);
    t=str2func(tmp2{tmp1});
    t(arguments);
    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{['>>',tmp2{tmp1},' Selected']}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg));
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    
    set(handles.runMultipleScenarios,'enable','on');
    set(handles.LoadInputFile,'enable','on');
    set(handles.CreateScenarios,'enable','on');
    set(handles.SolveSensorPlacement,'enable','on');
    set(handles.Exit,'enable','on');
            
function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SolveSensorPlacement.
function SolveSensorPlacement_Callback(hObject, eventdata, handles)
% hObject    handle to SolveSensorPlacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.runMultipleScenarios,'enable','inactive');
    set(handles.LoadInputFile,'enable','inactive');
    set(handles.CreateScenarios,'enable','inactive');
    set(handles.ComputeImpactMatrix,'enable','inactive');
    set(handles.Exit,'enable','inactive');
    
    close(findobj('type','figure','name','Solve Sensor Placement'))
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    if exist('File0.File','file')==2 
        load([pwd,'\RESULTS\','File0.File'],'-mat');
        if exist([pathname,file0],'file')==2
            if ~isempty(file0) 
                    load([pathname,file0],'-mat');
                if exist([pathname,file0(1:end-2),'.w'],'file')==2
                else
                    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
                    set(handles.LoadText,'Value',1);
                    msg=[msg;{'>>Cannot find impact matrix.'}];
                    set(handles.LoadText,'String',msg);                    
                    msg=[msg;{'>>Select Compute Impact Matrix.'}];
                    set(handles.LoadText,'String',msg);
                    set(handles.LoadText,'Value',length(msg)); 
                    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
                end
            else
                B.InputFile=handles.B.InputFile;
            end
        else
            B.InputFile=[];
        end
%         if ~strcmp(handles.B.InputFile,B.InputFile)         
%             load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%             set(handles.LoadText,'Value',1);
%             msg=[msg;{'>>Cannot find file.'}];
%             set(handles.LoadText,'String',msg);
%             msg=[msg;{'>>Select Create Scenarios.'}];
%             set(handles.LoadText,'String',msg);
%             msg=[msg;{'>>Or Load new.'}];
%             set(handles.LoadText,'String',msg);
%             set(handles.LoadText,'Value',length(msg));
%             save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
%         end
    else
        file0=[];
    end

    arguments.file0=file0(1:end-2);
    arguments.B=handles.B;
    arguments.LoadText = handles.LoadText;
    arguments.SplaceTable = handles.SplaceTable;    
    tmp1=get(handles.Optimization,'value');
    tmp2=get(handles.Optimization,'string');    
    %SolveSensorPlacementGui(arguments);
    t=str2func(tmp2{tmp1});
    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{['>>',tmp2{tmp1},' Method Selected']}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg));
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    
    t(arguments);

    set(handles.runMultipleScenarios,'enable','on');
    set(handles.LoadInputFile,'enable','on');
    set(handles.CreateScenarios,'enable','on');
    set(handles.SolveSensorPlacement,'enable','on');
    set(handles.ComputeImpactMatrix,'enable','on');
    set(handles.Exit,'enable','on');

% --- Executes during object creation, after setting all properties.
function LoadText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.figure1,'Visible','off');
    if libisloaded('epanet2')
       unloadlibrary('epanet2');
    end
    clc;
    close(findobj('type','figure','name','Release Location'));
    close(findobj('type','figure','name','Solve Sensor Placement'));
    close(findobj('type','figure','name','Run Multiple Scenarios'));
    close(findobj('type','figure','name','Compute Impact Matrix (CWCV)'));
    close(findobj('type','figure','name','Solve with exhaustive method..'));
    close(findobj('type','figure','name','Create Scenarios (Grid)'));

    rmpath(genpath(pwd));
    
    %Delete s files 
    a='abcdefghijklmnoqrstuvwxyz';
    for i=1:length(a)
        s=sprintf('s%s*',a(i));
        delete(s)
    end
    for i=1:9
        s=sprintf('s%.f*',i);
        delete(s)
    end
    
% --- Executes on selection change in SplaceTable.
function SplaceTable_Callback(hObject, eventdata, handles)
% hObject    handle to SplaceTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SplaceTable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SplaceTable
    if exist([pwd,'\RESULTS\','hNodesID.f'])==2
        load([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');
        delete(hNodesID(:)); hNodesID=[];
        save([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');    
    end
    if exist([pwd,'\RESULTS\','hLinksID.f'])==2
        load([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
        delete(hLinksID(:)); hLinksID=[];
        save([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
    end
    
    FontSize = str2num(get(handles.FontsizeENplot,'String'));
    if  ~length(FontSize) || FontSize<0 || FontSize>20
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{'>>Give Font Size.'}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        return
    end
    lineSensors = get(handles.SplaceTable,'Value');
    StringSensors = get(handles.SplaceTable,'String');
        
    tline = StringSensors(lineSensors);
    tline = regexp(tline,'\s*','split');
    tline = tline{1};
    if length(tline)>2
        
        if exist([pwd,'\RESULTS\','h1.f'])==2
            load([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
            for i=1:length(IndexID)
                C1='b'; C2='b';
                if sum(IndexID==handles.B.NodeReservoirIndex)
                    C2='g'; C1='g';
                elseif sum(IndexID==handles.B.TankIndex)
                    C2='k'; C1='k';
                end
                plot(handles.B.CoordinatesXY(IndexID,1),handles.B.CoordinatesXY(IndexID,2),'o','LineWidth',2,'MarkerEdgeColor',C1,...
                'MarkerFaceColor',C2,'MarkerSize',5);
                if h1~=1
                    delete(h1(:)); h1=[];
                end
            end
            IndexID=[];
        end
    
        if length(tline)==5
            SensorsNodesID=tline(end);
        else
            SensorsNodesID=tline(6:end);
        end
%         SensorsNodesID=tline(6:end);
        for i=1:length(SensorsNodesID)
            IndexID(i)= find(strcmpi(handles.B.NodeNameID,SensorsNodesID(i)));
            xy{i}=handles.B.CoordinatesXY(find(strcmpi(handles.B.NodeNameID,SensorsNodesID(i))),:);
        end
            
        t=1;
        for u=1:length(SensorsNodesID)
            plot(xy{u}(1),xy{u}(2),'o','LineWidth',2,'MarkerEdgeColor','r',...
                  'MarkerFaceColor','r',...
                  'MarkerSize',5)
            h1(t)=text(xy{u}(1),xy{u}(2),char(handles.B.NodeNameID(IndexID(u))),'FontSize',FontSize);
            t=t+1;
        end
        save([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
    end


% --- Executes during object creation, after setting all properties.
function SplaceTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SplaceTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Zoom.
function Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.ZoomIO==1
        zoom on;
        handles.ZoomIO=0;
        set(handles.Zoom,'String','Reset');
    elseif handles.ZoomIO==0
        zoom off;
        set(handles.Zoom,'String','Zoom');
        handles.ZoomIO=1;
    end
    

    % Update handles structure
    guidata(hObject, handles);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LinksID.
function LinksID_Callback(hObject, eventdata, handles)
% hObject    handle to LinksID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LinksID

    if exist([pwd,'\RESULTS\','hNodesID.f'])==2
        load([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');
        delete(hNodesID(:)); hNodesID=[];
        save([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');    
    end
    if exist([pwd,'\RESULTS\','hLinksID.f'])==2
        load([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
        delete(hLinksID(:)); hLinksID=[];
        save([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
    end

    if exist([pwd,'\RESULTS\','h1.f'])==2
        load([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
        for i=1:length(IndexID)
            C1='b'; C2='b';
            if sum(IndexID==handles.B.NodeReservoirIndex)
                C2='g'; C1='g';
            elseif sum(IndexID==handles.B.TankIndex)
                C2='k'; C1='k';
            end
            plot(handles.B.CoordinatesXY(IndexID,1),handles.B.CoordinatesXY(IndexID,2),'o','LineWidth',2,'MarkerEdgeColor',C1,...
            'MarkerFaceColor',C2,'MarkerSize',5);
            if h1~=1
                delete(h1(:)); h1=[];
            end
        end
        IndexID=[];
        save([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
    end
        
    FontSize = str2num(get(handles.FontsizeENplot,'String'));
    if  ~length(FontSize) || FontSize<0 || FontSize>20
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{'>>Give Font Size.'}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        return
    end
    
    value=get(handles.LinksID,'Value');
    if value==1
        set(handles.NodesID,'Value',0);
        
        for i=1:handles.B.CountLinks
            
            x1=handles.B.CoordinatesXY(handles.B.NodesConnectingLinksIndex(i,1),1);
            y1=handles.B.CoordinatesXY(handles.B.NodesConnectingLinksIndex(i,1),2);

            x2=handles.B.CoordinatesXY(handles.B.NodesConnectingLinksIndex(i,2),1);
            y2=handles.B.CoordinatesXY(handles.B.NodesConnectingLinksIndex(i,2),2);
            
            hLinksID(i)=text((x1+x2)/2,(y1+y2)/2,handles.B.LinkNameID(i),'FontSize',FontSize);
        end
        save([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
    end

% --- Executes on button press in NodesID.
function NodesID_Callback(hObject, eventdata, handles)
% hObject    handle to NodesID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NodesID
    if exist([pwd,'\RESULTS\','hNodesID.f'])==2
        load([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');
        delete(hNodesID(:)); hNodesID=[];
        save([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');    
    end
    if exist([pwd,'\RESULTS\','hLinksID.f'])==2
        load([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
        delete(hLinksID(:)); hLinksID=[];
        save([pwd,'\RESULTS\','hLinksID.f'],'hLinksID','-mat');
    end

    if exist([pwd,'\RESULTS\','h1.f'])==2
        load([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
        for i=1:length(IndexID)
            C1='b'; C2='b';
            if sum(IndexID==handles.B.NodeReservoirIndex)
                C2='g'; C1='g';
            elseif sum(IndexID==handles.B.TankIndex)
                C2='k'; C1='k';
            end
            plot(handles.B.CoordinatesXY(IndexID,1),handles.B.CoordinatesXY(IndexID,2),'o','LineWidth',2,'MarkerEdgeColor',C1,...
            'MarkerFaceColor',C2,'MarkerSize',5);
            if h1~=1
                delete(h1(:)); h1=[];
            end
        end
        IndexID=[];
        save([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
    end
    
    FontSize = str2num(get(handles.FontsizeENplot,'String'));
    if  ~length(FontSize) || FontSize<0 || FontSize>20
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{'>>Give Font Size.'}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        return
    end
    
    
    value=get(handles.NodesID,'Value');
    if value==1 
        set(handles.LinksID,'Value',0);
        for i=1:handles.B.CountNodes
            xy{i}=handles.B.CoordinatesXY(i,:); 
            hNodesID(i)=text(xy{i}(1),xy{i}(2),char(handles.B.NodeNameID(i)),'FontSize',FontSize);
        end
        save([pwd,'\RESULTS\','hNodesID.f'],'hNodesID','-mat');
    end



function FontsizeENplot_Callback(hObject, eventdata, handles)
% hObject    handle to FontsizeENplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FontsizeENplot as text
%        str2double(get(hObject,'String')) returns contents of FontsizeENplot as a double

    if get(handles.NodesID,'Value');
        NodesID_Callback(hObject, eventdata, handles);
    elseif get(handles.LinksID,'Value');
        LinksID_Callback(hObject, eventdata, handles);
    end


% --- Executes during object creation, after setting all properties.
function FontsizeENplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FontsizeENplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in methodsScenarios.
function methodsScenarios_Callback(hObject, eventdata, handles)
% hObject    handle to methodsScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns methodsScenarios contents as cell array
%        contents{get(hObject,'Value')} returns selected item from methodsScenarios


% --- Executes during object creation, after setting all properties.
function methodsScenarios_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodsScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CreateScenarios.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to CreateScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in viewCreateScenarios.
function viewCreateScenarios_Callback(hObject, eventdata, handles)
% hObject    handle to viewCreateScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    nameFunction=get(handles.methodsScenarios,'String');
    index=get(handles.methodsScenarios,'Value');

    open([char(nameFunction(index)),'.m']);


% --- Executes on selection change in Optimization.
function Optimization_Callback(hObject, eventdata, handles)
% hObject    handle to Optimization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Optimization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Optimization


% --- Executes during object creation, after setting all properties.
function Optimization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Optimization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SolveSensorPlacement.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to SolveSensorPlacement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    nameFunction=get(handles.Optimization,'String');
    index=get(handles.Optimization,'Value');

    open([char(nameFunction(index)),'.m']);

% --- Executes on selection change in Simulate.
function Simulate_Callback(hObject, eventdata, handles)
% hObject    handle to Simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Simulate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Simulate


% --- Executes during object creation, after setting all properties.
function Simulate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runMultipleScenarios.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to runMultipleScenarios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    nameFunction=get(handles.Simulate,'String');
    index=get(handles.Simulate,'Value');

    open([char(nameFunction(index)),'.m']);
    
% --- Executes on selection change in Impacts.
function Impacts_Callback(hObject, eventdata, handles)
% hObject    handle to Impacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Impacts contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Impacts


% --- Executes during object creation, after setting all properties.
function Impacts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Impacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ComputeImpactMatrix.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeImpactMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    nameFunction=get(handles.Impacts,'String');
    index=get(handles.Impacts,'Value');

    open([char(nameFunction(index)),'.m']);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Instructions_Callback(hObject, eventdata, handles)
% hObject    handle to Instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('Instructions.html');

% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 about;

% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    LoadInputFile_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if libisloaded('epanet2')
        unloadlibrary('epanet2');
    end
    pathname=[pwd,'\RESULTS\'];
    save([pathname,'pathname.File'],'pathname','-mat');
    
    opening(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ExitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    Exit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function frameOfNet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameOfNet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in frameOfNet.
function frameOfNet_Callback(hObject, eventdata, handles)
% hObject    handle to frameOfNet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SaveNetwork.
function SaveNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to SaveNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % graphs
    set(handles.SaveNetwork,'visible','off');
    set(handles.Zoom,'visible','off');
    set(handles.NodesID,'visible','off');
    set(handles.LinksID,'visible','off');
    set(handles.FontsizeENplotText,'visible','off');
    set(handles.FontsizeENplot,'visible','off');

    f=getframe(handles.axes1);
    imwrite(f.cdata,[handles.B.InputFile(1:end-4),'.bmp'],'bmp');
    figure(1);
    imshow([handles.B.InputFile(1:end-4),'.bmp']);

    % save to pdf and bmp
    print(gcf,'-dpdf',handles.B.InputFile(1:end-4),sprintf('-r%d',150));
    
    % graphs
    set(handles.SaveNetwork,'visible','on');
    set(handles.Zoom,'visible','on');
    set(handles.NodesID,'visible','on');
    set(handles.LinksID,'visible','on');
    set(handles.FontsizeENplotText,'visible','on');
    set(handles.FontsizeENplot,'visible','on');   
    close(1);   


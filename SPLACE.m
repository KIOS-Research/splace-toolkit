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

% Last Modified by GUIDE v2.5 23-Jan-2015 02:06:41

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
if ~isdeployed
    path(path,genpath(pwd));
end

    % Choose default command line output for SPLACE
    handles.output = hObject;
    handles.ZoomIO=1;
%     if libisloaded('epanet2')
%         unloadlibrary('epanet2');
%     end
    pathname=[pwd,'\RESULTS\'];
    save([pathname,'pathname.File'],'pathname','-mat');

    % UIWAIT makes SPLACE wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    opening(hObject, eventdata, handles)
    
function opening(hObject, eventdata, handles)
        
    set(handles.figure1,'name','S-Place: Quality Sensor Placement in Water Distribution Systems');
    ScreenSize=get(0,'ScreenSize');

    position = get(handles.figure1,'Position');
    set(handles.figure1,'Position',[position(1) position(2) 206.5 54])
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
    
    try
        delete(handles.dataplots);
    catch err
    end
    try
        delete(handles.previousg);
    catch err
    end
    try
        delete(handles.logo); 
    catch err
    end
    handles.dataplots=[];
    handles.file=[];
    handles.previousg=axes('Parent',handles.axes1);
    if eventdata
        handles.logo=imshow([pwd, '\HELP\white.png'],'Parent',handles.previousg);
    else
        handles.logo=imshow([pwd, '\HELP\splace2.png'],'Parent',handles.previousg);
    end
    set(handles.SaveNetwork,'visible','off');
    set(handles.Zoom,'visible','off');
    set(handles.pan,'visible','off');
    set(handles.NodesID,'visible','off');
    set(handles.LinksID,'visible','off');
    set(handles.FontsizeENplotText,'visible','off');
    set(handles.FontsizeENplot,'visible','off');
    set(handles.flowUnits,'visible','off');
    
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
    
    [inputfile,~] = uigetfile('NETWORKS\*.inp');

%     PathFile = strcat(PathFile,inputfile);
    if inputfile~=0
%         if libisloaded('epanet2')
%            unloadlibrary('epanet2');
%         end
        col = get(handles.LoadInputFile,'backg');  % Get the background color of the figure.
        set(handles.LoadInputFile,'str','LOADING...','backg','w') % Change color of button. 
        % The pause (or drawnow) is necessary to make button changes appear.
        % To see what this means, try doing this with the pause commented out.
        pause(.1)  % FLUSH the event queue, drawnow would work too.
        % Here is where you put whatever function calls or processes that the
        % pushbutton is supposed to activate. 
        % Next we simulate some running process.  Here just sort a vector.
        
        B=epanet(['NETWORKS/',inputfile]); %clc;

        handles.B = B; warning off;
        if exist('File0.File','file')==2
            load([pwd,'\RESULTS\','File0.File'],'-mat'); 
            file0=[];
            save([pwd,'\RESULTS\','File0.File'],'file0','-mat')
        end
        if exist([pwd,'\RESULTS\','h1.f'])==2
            delete([pwd,'\RESULTS\','h1.f'],'h1','-mat');
        end
        if exist([pwd,'\RESULTS\','hNodesIhandles.B.f'])==2
            delete([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');
        end
        if exist([pwd,'\RESULTS\','hLinksIhandles.B.f'])==2
            delete([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
        end
        
        pathname=[pwd,'\RESULTS\'];
        save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');
        warning on;
        if isempty(B.errcode)% || isempty(B.NodeCount)
            opening(hObject, 1, handles);
            s = [['Could not open network "',inputfile,'".'] {'Please insert the correct filename(*.inp).'}];
            set(handles.LoadText,'Value',length(s));
            set(handles.LoadText,'String',s);
            set(handles.LoadInputFile,'str','Load Input File','backg',col);          
            return;
        end

%         set(handles.LoadText,'String',which(inputfile));
        msg=['>>Load Input File "',inputfile,'" Successful.']; 
        Getmsg=['>>Current version of EPANET:',num2str(B.Version)];
        msg=[msg;{Getmsg}];
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        set(handles.LoadText,'Value',length(msg)); 
        set(handles.LoadText,'String',msg);
        
        set(handles.LoadInputFile,'str','Load Input File','backg',col)  % Now reset the button features.
        % Update handles structure
        guidata(hObject, handles);

%         if findobj('Tag','legend'),delete(findobj('Tag','legend'));end
        try 
            cla(handles.previousg)
            handles.previousg=axes('Parent',handles.axes1);
            B.plot('axes',handles.previousg); 
        catch e
        end
        set(handles.axes1,'HighlightColor','k')
        
%         axis on
%         set(handles.axes1,'Color','w')
%         set(handles.axes1,'XTick',[])
%         set(handles.axes1,'YTick',[])

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
            
%         set(handles.frameOfNet,'Visible','off');
        set(handles.NodesID,'value',0);
        set(handles.LinksID,'value',0);
        set(handles.FontsizeENplot,'String',12);
        set(handles.SaveNetwork,'visible','on');
        set(handles.Zoom,'visible','on');
        set(handles.pan,'visible','on');
        set(handles.NodesID,'visible','on');
        set(handles.LinksID,'visible','on');  
        set(handles.FontsizeENplot,'visible','on');
        set(handles.FontsizeENplotText,'visible','on');   
        set(handles.flowUnits,'visible','on');
        set(handles.flowUnits,'string',['Flow Units: ',char(handles.B.LinkFlowUnits)]);
        
        try
            delete(handles.logo);
        catch err
        end
        guidata(hObject, handles);
        
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
                B.inputfile=handles.B.inputfile;
            end
        else
            B.inputfile=[];
        end
%         if ~strcmp(handles.B.inputfile,B.inputfile)         
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
        if exist([pathname,file0,'.0'],'file')==2
            [path, name, ext] = fileparts(file0);
        else
            ext=1;
        end
        
        if length(ext)==0
            file0=[file0,'.0'];
            if exist([pathname,file0],'file')==2 && exist([pathname,file0(1:end-1),'c0'],'file')==2
                if ~isempty(file0) 
                    load([pathname,file0],'-mat');
                else
                    B.inputfile=handles.B.inputfile;
                end
            else
                B.inputfile=[];
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
        end
%         if ~strcmp(handles.B.inputfile,B.inputfile)             
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
                B.inputfile=handles.B.inputfile;
            end
        else
            B.inputfile=[];
        end
%         if ~strcmp(handles.B.inputfile,B.inputfile)         
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
    if exist([pwd,'\RESULTS\','hNodesIhandles.B.f'])==2
        load([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');
        delete(hNodesID(:)); hNodesID=[];
        save([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');    
    end
    if exist([pwd,'\RESULTS\','hLinksIhandles.B.f'])==2
        load([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
        delete(hLinksID(:)); hLinksID=[];
        save([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
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
                if isequal(IndexID,handles.B.NodeReservoirIndex)
                    C2='g'; C1='g';
                elseif isequal(IndexID,handles.B.NodeTankIndex)
                    C2='k'; C1='k';
                end
                plot(handles.B.NodeCoordinates{1}(IndexID(i)),handles.B.NodeCoordinates{2}(IndexID(i)),'o','LineWidth',2,'MarkerEdgeColor',C1,...
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
            x{i}=handles.B.NodeCoordinates{1}(IndexID(i));
            y{i}=handles.B.NodeCoordinates{2}(IndexID(i));
        end
            
        t=1;
        for u=1:length(SensorsNodesID)
            plot(x{u}(1),y{u}(1),'o','LineWidth',2,'MarkerEdgeColor','r',...
                  'MarkerFaceColor','r',...
                  'MarkerSize',5)
            h1(t)=text(x{u}(1),y{u}(1),char(handles.B.NodeNameID(IndexID(u))),'FontSize',FontSize);
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

    str = get(handles.Zoom,'String');
    set(handles.pan,'String','Pan');
    
    if strcmp('Zoom',str) 
        try
        zoom on;
        catch err;
        end
        set(handles.Zoom,'String','Reset');
        % History
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{['>>','Zoom',' Selected']}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    end
    if strcmp('Reset',str)
        for i=1:2
        try
        zoom off;
        zoom out;
        zoom reset;
        catch err;
        end
        end
        font(hObject, eventdata, handles,1);  
        % History
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{['>>','Reset',' Selected']}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        set(handles.Zoom,'String','Zoom');
%         set(handles.Tbar,'visible','off');
    end
    % Update handles structure
    guidata(hObject, handles);
    

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

    if exist([pwd,'\RESULTS\','hNodesIhandles.B.f'])==2
        load([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');
        delete(hNodesID(:)); hNodesID=[];
        save([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');    
    end
    if exist([pwd,'\RESULTS\','hLinksIhandles.B.f'])==2
        load([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
%         if ~isnumeric(hLinksID)
%            for i=1:length(hLinksID) 
%                hLinksID(i).String='';
%            end
%         end
        delete(hLinksID(:)); hLinksID=[];
        save([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
    end

    if exist([pwd,'\RESULTS\','h1.f'])==2
        load([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
        for i=1:length(IndexID)
            C1='b'; C2='b';
            if sum(IndexID==handles.B.NodeReservoirIndex)
                C2='g'; C1='g';
            elseif sum(IndexID==handles.B.NodeTankIndex)
                C2='k'; C1='k';
            end
            plot(handles.B.NodeCoordinates{1}(IndexID(i)),handles.B.NodeCoordinates{2}(IndexID(i)),'o','LineWidth',2,'MarkerEdgeColor',C1,...
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
        
        for i=1:handles.B.LinkCount
            
            x1=handles.B.NodeCoordinates{1}(handles.B.NodesConnectingLinksIndex(i,1));
            y1=handles.B.NodeCoordinates{2}(handles.B.NodesConnectingLinksIndex(i,1));

            x2=handles.B.NodeCoordinates{1}(handles.B.NodesConnectingLinksIndex(i,2));
            y2=handles.B.NodeCoordinates{2}(handles.B.NodesConnectingLinksIndex(i,2));
            
            hLinksID(i)=text((x1+x2)/2,(y1+y2)/2,handles.B.LinkNameID(i),'FontSize',FontSize);
        end
        save([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
    end

% --- Executes on button press in NodesID.
function NodesID_Callback(hObject, eventdata, handles)
% hObject    handle to NodesID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NodesID
    if exist([pwd,'\RESULTS\','hNodesIhandles.B.f'])==2
        load([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');
        delete(hNodesID(:)); hNodesID=[];
        save([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');    
    end
    if exist([pwd,'\RESULTS\','hLinksIhandles.B.f'])==2
        load([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
        delete(hLinksID(:)); hLinksID=[];
        save([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat');
    end

    if exist([pwd,'\RESULTS\','h1.f'])==2
        load([pwd,'\RESULTS\','h1.f'],'h1','IndexID','-mat');
        for i=1:length(IndexID)
            C1='b'; C2='b';
            if sum(IndexID==handles.B.NodeReservoirIndex)
                C2='g'; C1='g';
            elseif sum(IndexID==handles.B.NodeTankIndex)
                C2='k'; C1='k';
            end
            plot(handles.B.NodeCoordinates{1}(IndexID(i)),handles.B.NodeCoordinates{2}(IndexID(i)),'o','LineWidth',2,'MarkerEdgeColor',C1,...
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
        for i=1:handles.B.NodeCount
            hNodesID(i)=text(handles.B.NodeCoordinates{1}(i),handles.B.NodeCoordinates{2}(i),char(handles.B.NodeNameID(i)),'FontSize',FontSize);
        end
        save([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');
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
    prompt={'Enter the file name:'};
    answer=inputdlg(prompt);
    
    if ~isempty(answer)
        answer=char(answer);
        f=getframe(handles.figure1);
        imwrite(f.cdata,[answer,'.bmp'],'bmp');
        figure(1);
        imshow([answer,'.bmp']);
        % save to pdf and bmp
        print(gcf,'-dpdf',answer,sprintf('-r%d',150));
        close(1);   
    end


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pan.
function pan_Callback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    str = get(handles.pan,'String');
    set(handles.Zoom,'String','Zoom');
    
    if strcmp('Pan',str) 
        try
        pan on;
        catch err
        end
        handles.PanIO=0;
        set(handles.pan,'String','Reset');
        % History
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{['>>','Pan',' Selected']}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');

    end
    if strcmp('Reset',str)
        try
        zoom out;
        zoom reset;
        pan off;
        catch err
        end
        font(hObject, eventdata, handles,1);
%         ENplotB('axes',handles.previousg);  
        % History
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{['>>','Reset',' Selected']}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        set(handles.pan,'String','Pan');
        handles.PanIO=1;
%         set(handles.Tbar,'visible','off');
    end

    % Update handles structure
    guidata(hObject, handles);

function font(hObject, eventdata, handles, arg)

    n=get(handles.NodesID,'value');
    l=get(handles.LinksID,'value');

    if n==1
        set(handles.NodesID,'value',0)
        if arg==0
            hNodesID=[];
            save([pwd,'\RESULTS\','hNodesIhandles.B.f'],'hNodesID','-mat');    
        end
        NodesID_Callback(hObject, eventdata, handles);
    end
    if l==1
        if arg==0
            hLinksID=[];
            save([pwd,'\RESULTS\','hLinksIhandles.B.f'],'hLinksID','-mat'); 
        end
        set(handles.LinksID,'value',0)
        LinksID_Callback(hObject, eventdata, handles);
    end

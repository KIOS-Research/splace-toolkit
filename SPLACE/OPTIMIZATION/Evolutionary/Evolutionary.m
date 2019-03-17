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

function varargout = Evolutionary(varargin)
% EVOLUTIONARY MATLAB code for Evolutionary.fig
%      EVOLUTIONARY, by itself, creates a new EVOLUTIONARY or raises the existing
%      singleton*.
%
%      H = EVOLUTIONARY returns the handle to a new EVOLUTIONARY or the handle to
%      the existing singleton*.
%
%      EVOLUTIONARY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EVOLUTIONARY.M with the given input arguments.
%
%      EVOLUTIONARY('Property','Value',...) creates a new EVOLUTIONARY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Evolutionary_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Evolutionary_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Evolutionary

% Last Modified by GUIDE v2.5 22-May-2013 22:30:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Evolutionary_OpeningFcn, ...
                   'gui_OutputFcn',  @Evolutionary_OutputFcn, ...
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


% --- Executes just before Evolutionary is made visible.
function Evolutionary_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Evolutionary (see VARARGIN)

    % Choose default command line output for Evolutionary
    handles.output = hObject;

    % UIWAIT makes Evolutionary wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    set(handles.figure1,'name','Solve Sensor Placement');
    position = get(handles.figure1,'Position');
%     set(handles.figure1,'Position',[103.8 26 49 31])
    
    handles.file0 = varargin{1}.file0;
    handles.B = varargin{1}.B;
    handles.LoadText = varargin{1}.LoadText;
    handles.SplaceTable = varargin{1}.SplaceTable; 
    handles.export_sensors = varargin{1}.export_sensors;
    handles.axes1 = varargin{1}.axes1;

    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    set(handles.LoadImpactMatrix,'enable','off');
    set(handles.Solve,'enable','off');
    
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
        set(handles.FileText0,'String','')
    else
        set(handles.FileText0,'String',[handles.file0,'.0'])
        if exist([pathname,handles.file0,'.w'],'file')==2
            set(handles.Solve,'enable','on');
            if exist([pathname,handles.file0,'.w'],'file')==2
                set(handles.FileTextW,'String',[handles.file0,'.w']);
            end
            set(handles.LoadImpactMatrix,'enable','on');
        else
            set(handles.LoadImpactMatrix,'enable','on');
        end
    end    
    
    handles.pp=DefaultSolveParameters(hObject,handles);
    
    % Update handles structure
    guidata(hObject, handles);
    
function pp=DefaultSolveParameters(hObject,handles)
    pp.solutionMethod=1; 
    
    pp.PopulationSize_Data=1000;
    pp.ParetoFraction_Data=0.7;
    pp.Generations_Data=100;
    
    pp.numberOfSensors='1:3';
        
    if ((exist('gamultiobj','file')==2)==1)
        set(handles.PopulationSize_Data,'enable','on');
        set(handles.ParetoFraction_Data,'enable','on');
        set(handles.Generations_Data,'enable','on');
    else
        set(handles.PopulationSize_Data,'enable','off');
        set(handles.ParetoFraction_Data,'enable','off');
        set(handles.Generations_Data,'enable','off');
        set(handles.LoadImpactMatrix,'enable','off');
        set(handles.LoadScenarios,'enable','off');
        set(handles.DefaultParameters,'enable','off');
        set(handles.numberOfSensors,'enable','off');
        set(handles.Solve,'enable','off');
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        set(handles.LoadText,'Value',1);
        msg=[msg;{'>>GAMULTIOBJ is not currenty installed in MATLAB.'}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg)); 
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    end
    
    set(handles.PopulationSize_Data,'String',pp.PopulationSize_Data);
    set(handles.ParetoFraction_Data,'String',pp.ParetoFraction_Data);
    set(handles.Generations_Data,'String',pp.Generations_Data);
    set(handles.numberOfSensors,'String',pp.numberOfSensors);

    % Update handles structure
    guidata(hObject, handles);
    
% --- Outputs from this function are returned to the command line.
function varargout = Evolutionary_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function ParetoFraction_Data_Callback(hObject, eventdata, handles)
% hObject    handle to ParetoFraction_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ParetoFraction_Data as text
%        str2double(get(hObject,'String')) returns contents of ParetoFraction_Data as a double


% --- Executes during object creation, after setting all properties.
function ParetoFraction_Data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ParetoFraction_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PopulationSize_Data_Callback(hObject, eventdata, handles)
% hObject    handle to PopulationSize_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PopulationSize_Data as text
%        str2double(get(hObject,'String')) returns contents of PopulationSize_Data as a double


% --- Executes during object creation, after setting all properties.
function PopulationSize_Data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopulationSize_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Generations_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Generations_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Generations_Data as text
%        str2double(get(hObject,'String')) returns contents of Generations_Data as a double


% --- Executes during object creation, after setting all properties.
function Generations_Data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Generations_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberOfSensors_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfSensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfSensors as text
%        str2double(get(hObject,'String')) returns contents of numberOfSensors as a double


% --- Executes during object creation, after setting all properties.
function numberOfSensors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfSensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Solve.
function Solve_Callback(hObject, eventdata, handles)
% hObject    handle to Solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [errorCode,handles.pp] = CheckForError(hObject,handles);
    if errorCode
        return;
    end
    handles.pp.numberOfSensors=get(handles.numberOfSensors,'String');
    
    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{'>>Running..'}];
    
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg)); 
    
    if sum(str2num(handles.pp.numberOfSensors)>handles.B.NodeCount)>0
        msg=[msg;{'>>Give number of sensors.'}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg)); 
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        return
    end
    set(handles.figure1,'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Method
    EvolutionaryOptimization(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    set(handles.SplaceTable,'enable','on');
    set(handles.SplaceTable,'String','');

    set(handles.LoadText,'Value',1);
    msg=[msg;{'>>Solve Sensor Placement.'}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg)); 
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');
    load([pathname,handles.file0,'.y1'],'Y', '-mat'); %Evolutionary method
    
    set(handles.SplaceTable,'Foregroundcolor','b');  
    set(handles.SplaceTable,'fontsize',8);%10
    
    w=[{'------S-PLACE------ [Evolutionary Method]'};{' '}];
    set(handles.SplaceTable,'visible','on');
    a=str2num(handles.pp.numberOfSensors);
    u=1;
    w=[w;{['------Sensors-Placement: ',num2str(a(1))]}];
    
    i=1;k=1;pp=1;
    while i<size(Y.F,1)+1
            ss=Y.xIndex{u};
        if Y.F(i,1)==a(u) 
            r=Y.F(k,:);k=k+1;
            f1=r(2);
            f2=r(3);
            if u>1
                ss1=ss(pp,:);
            else
                ss1=ss(u,pp);
            end
            Sensors=handles.B.NodeNameID{ss1};
            SensorsSS= [num2str(Sensors),''];
            if length(ss1)>1
                for t=2:length(ss1)
                    SensorsSS = [SensorsSS,'  ',num2str(handles.B.NodeNameID{ss1(t)})];
                end
            end
            w=[w;{['mean = ',num2str(sprintf('%10.2f',f1)),'       max = ',num2str(sprintf('%10.2f',f2)),'       NodesID: ',SensorsSS]}];
            warning off;
            set(handles.SplaceTable,'Value',length(w));
            set(handles.SplaceTable,'String',w);warning on;
        else
            u=u+1;
            pp=0;
            i=i-1;
            w=[w;{['------Sensors-Placement: ',num2str(a(u))]}];
        end
        i=i+1;pp=pp+1;
    end
    
    msg=[msg;{'>>Sensor solutions.'}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg));
    save([pwd,'\RESULTS\','w.report'],'w','-mat');
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    
    set(handles.export_sensors,'visible','on');
    msgbox('Evolutionary algorithm was succesfull.','Success','modal')

    
function [errorCode,pp] = CheckForError(hObject,handles)
    errorCode=0;
    pp.PopulationSize_Data=str2num(get(handles.PopulationSize_Data, 'String'));
    pp.ParetoFraction_Data=str2num(get(handles.ParetoFraction_Data, 'String'));
    pp.Generations_Data=str2num(get(handles.Generations_Data, 'String'));
    pp.numberOfSensors=str2num(get(handles.numberOfSensors,'String'));
    
    if  ~length(pp.PopulationSize_Data) || pp.PopulationSize_Data<0
        msgbox('           Give Population', 'Error', 'modal')
        errorCode=1;
        return
    end

    if ~length(pp.ParetoFraction_Data) || pp.ParetoFraction_Data<0
        msgbox('       Give Pareto Fraction', 'Error', 'modal')
        errorCode=1;
        return
    end

    if ~length(pp.Generations_Data) || pp.Generations_Data<0
        msgbox('          Give Generations', 'Error', 'modal')
        errorCode=1;
        return
    end

    if ~length(pp.numberOfSensors) || sum(pp.numberOfSensors<0) || sum((pp.numberOfSensors)>handles.B.NodeCount)>0   
    msgbox('     Give Number of Sensors', 'Error', 'modal')
    errorCode=1;
    return
    end

    % Update handles structure
    guidata(hObject, handles);

% --- Executes on button press in DefaultParameters.
function DefaultParameters_Callback(hObject, eventdata, handles)
% hObject    handle to DefaultParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    DefaultSolveParameters(hObject,handles);


% --- Executes on button press in LoadImpactMatrix.
function LoadImpactMatrix_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImpactMatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    [fileW,pathNM] = uigetfile([pathname,'*.w'],'Select the MATLAB *.w file');
    if length(pathNM)~=1
        pathname=pathNM;
    end
    fileW=fileW(1:end-2);
    if isnumeric(fileW)
        fileW=[];
    end
    if ~isempty((fileW)) 
        load([pathname,fileW,'.w'],'-mat');
        handles.fileW=fileW;
        if ~strcmp(handles.file0,handles.fileW)
            set(handles.Solve,'enable','off');
            msgbox(' Impact matrix is not on this input file','Error','modal');
            load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            msg=[msg;{['>>Wrong Impact Matrix FileW "',fileW,'"']}];
            set(handles.LoadText,'String',msg);
            set(handles.LoadText,'Value',length(msg)); 
            save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            set(handles.FileTextW,'String','')
        else
            set(handles.Solve,'enable','on');
            set(handles.FileTextW,'String',[handles.file0,'.w']);
        end
        % Update handles structure
        guidata(hObject, handles);
    end
    save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    % --- Executes on button press in LoadScenarios.
function LoadScenarios_Callback(hObject, eventdata, handles)
% hObject    handle to LoadScenarios (see GCBO)
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
        load([pathname,file0,'.0'],'-mat');%clc;
        handles.file0=file0;
        if ~strcmp(handles.B.InputFile,B.InputFile)
            set(handles.Solve,'enable','off');
            set(handles.LoadImpactMatrix,'enable','off');
            load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            msg=[msg;{['>>Wrong File0 "',file0,'"']}];
            set(handles.LoadText,'String',msg);
            set(handles.LoadText,'Value',length(msg)); 
            save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            set(handles.FileText0,'String','')
        else
            set(handles.LoadImpactMatrix,'enable','on');
            set(handles.Solve,'enable','off');
            set(handles.FileText0,'String',[handles.file0,'.0']);
        end
        handles.P=P;
        hanldes.B=B;
        % Update handles structure
        guidata(hObject, handles);
    end
    save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

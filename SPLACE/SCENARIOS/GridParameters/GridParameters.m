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

function varargout = GridParameters(varargin)
% GRIDPARAMETERS MATLAB code for GridParameters.fig
%      GRIDPARAMETERS, by itself, creates a new GRIDPARAMETERS or raises the existing
%      singleton*.
%
%      H = GRIDPARAMETERS returns the handle to a new GRIDPARAMETERS or the handle to
%      the existing singleton*.
%
%      GRIDPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRIDPARAMETERS.M with the given input arguments.
%
%      GRIDPARAMETERS('Property','Value',...) creates a new GRIDPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GridParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GridParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GridParameters

% Last Modified by GUIDE v2.5 29-May-2013 17:18:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GridParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @GridParameters_OutputFcn, ...
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


% --- Executes just before GridParameters is made visible.
function GridParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GridParameters (see VARARGIN)

% Choose default command line output for GridParameters
    handles.output = hObject;

    % UIWAIT makes GridParameters wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

    set(handles.figure1,'name','Create Scenarios (Grid)');
    set(handles.figure1,'Position',[75 15 164.5 39]);
    handles.LoadText=varargin{1}.LoadText;
    handles.B=varargin{1}.B;
    % Update handles structure
    guidata(hObject, handles);
    
    P=DefaultParameters(handles);
    
    load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
    msg=[msg;{'>>Open Create Scenario Parameters.'}];
    set(handles.LoadText,'String',msg);
    set(handles.LoadText,'Value',length(msg)); 
    save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
            
    handles.P=P;
%     handles.B=B;

    handles.release(1:handles.B.NodeCount)=true;
    handles.sensing(1:handles.B.NodeCount)=true;
    %P.SourcesNodeIndicesNonZero=find(P.SourcesNodeIndicesNonZero);
    %handles.sensing(P.NodesNonZeroDemands)=true;
    %P.SourcesNodeIndices=find(handles.release);
    %P.SensingNodeIndices=find(handles.sensing);

    % Update handles structure
    guidata(hObject, handles);

    SetGuiParameters(P,handles.B,hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = GridParameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;

    
function SetGuiParameters(P,B,hObject,handles)
    % Time Parameters
    set(handles.SimulationTime,'String',P.SimulationTime);
    set(handles.PatternTimeStep,'String',P.PatternTimeStep);

    % Contaminant
    set(handles.SourceInjectionRate,'String',P.SourceInjectionRate);
    set(handles.SourceDuration,'String',P.SourceDuration);
    set(handles.SourcePrcInj,'String',P.SourcePrc(1));
    set(handles.SourceSamplesInj,'String',P.SourceSamples(1));
    set(handles.SourcePrcDuration,'String',P.SourcePrc(2));
    set(handles.SourceSamplesDuration,'String',P.SourceSamples(2));

    set(handles.start,'String',P.SourcesInjectionTimes(1));
    set(handles.stop,'String',P.SourcesInjectionTimes(2));

    set(handles.FlowPrcPatterns,'String',P.FlowPrc(6));
    set(handles.FlowSamplesPatterns,'String',P.FlowSamples(6));

    %% B 
    if P.SourcesMaxNumber==1
        set(handles.SourcesMaxNumber1,'Value',1); %maximum number of simultaneous sources (including 1,2)
        set(handles.SourcesMaxNumber2,'Value',0);  
    elseif P.SourcesMaxNumber==2
        set(handles.SourcesMaxNumber2,'Value',1);  
        set(handles.SourcesMaxNumber1,'Value',0);  
    end

    set(handles.start,'String',P.SourcesInjectionTimes(1));
    set(handles.stop,'String',P.SourcesInjectionTimes(2));

    % Hydraulic Parameters
    LinkTableColumnName = cell(1,B.LinkCount+2);
    LinkTableColumnName(1,1)={'%'};
    LinkTableColumnName(1,2)={'Samples'};
    LinkTableColumnName(1,3:B.LinkCount+2)=B.getLinkNameID;
    set(handles.LinkTable, 'ColumnName', LinkTableColumnName);
    set(handles.LinkTable,'RowName',{'Diameters','Lengths','Roughness'});

    NodeTableColumnName(1,1)={'%'};
    NodeTableColumnName(1,2)={'Samples'};
    NodeTableColumnName(1,3:B.NodeCount+2)=B.getNodeNameID;
    set(handles.NodeTable, 'ColumnName', NodeTableColumnName);
    set(handles.NodeTable,'RowName',{'Elevations','Basedemands'});

    % Links
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:B.LinkCount+2
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.LinkTable,'ColumnEditable',str2num(ColumnEditable));

    % Diameters
    LinkTable=zeros(3,B.LinkCount+2);
    LinkTable(1,1)= P.FlowPrc{1};
    LinkTable(1,2)= P.FlowSamples{1};
    LinkTable(1,3:end)=P.Diameters;
    % Lengths
    LinkTable(2,1)= P.FlowPrc{2};
    LinkTable(2,2)= P.FlowSamples{2};
    LinkTable(2,3:end)=P.Lengths;
    % Roughness
    LinkTable(3,1)= P.FlowPrc{3};
    LinkTable(3,2)= P.FlowSamples{3};
    LinkTable(3,3:end)=P.Roughness;
    set(handles.LinkTable,'data',LinkTable);

    % Nodes
    % Column Edit Table
    ColumnEditable='true ';
    for i=1:B.NodeCount+2
        ColumnEditable = strcat({ColumnEditable},' true');
        ColumnEditable = ColumnEditable{1,1};
    end
    set(handles.NodeTable,'ColumnEditable',str2num(ColumnEditable));

    % Elevations
    NodeTable=zeros(2,B.NodeCount+2);
    NodeTable(1,1)= P.FlowPrc{4};
    NodeTable(1,2)= P.FlowSamples{4};
    NodeTable(1,3:end)=P.Elevation;
    % Basedemands
    NodeTable(2,1)= P.FlowPrc{5};
    NodeTable(2,2)= P.FlowSamples{5};
    if isnumeric(P.BaseDemand)
        NodeTable(2,3:end)=P.BaseDemand;
    else
        NodeTable(2,3:end)=P.BaseDemand{1};
    end
    set(handles.NodeTable,'data',NodeTable);

    tmpr=false(1,handles.B.NodeCount);
    tmpr(find(P.SourcesNodeIndices))=true;
    handles.release=tmpr;
    tmps=false(1,handles.B.NodeCount);
    tmps(find(P.SensingNodeIndices))=true;
    handles.sensing=tmps;

    % Update handles structure
    guidata(hObject, handles);


function SourceInjectionRate_Callback(hObject, eventdata, handles)
% hObject    handle to SourceInjectionRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourceInjectionRate as text
%        str2double(get(hObject,'String')) returns contents of SourceInjectionRate as a double


% --- Executes during object creation, after setting all properties.
function SourceInjectionRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceInjectionRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SourceDuration_Callback(hObject, eventdata, handles)
% hObject    handle to SourceDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourceDuration as text
%        str2double(get(hObject,'String')) returns contents of SourceDuration as a double


% --- Executes during object creation, after setting all properties.
function SourceDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SourcePrcInj_Callback(hObject, eventdata, handles)
% hObject    handle to SourcePrcInj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourcePrcInj as text
%        str2double(get(hObject,'String')) returns contents of SourcePrcInj as a double


% --- Executes during object creation, after setting all properties.
function SourcePrcInj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourcePrcInj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SourceSamplesInj_Callback(hObject, eventdata, handles)
% hObject    handle to SourceSamplesInj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourceSamplesInj as text
%        str2double(get(hObject,'String')) returns contents of SourceSamplesInj as a double


% --- Executes during object creation, after setting all properties.
function SourceSamplesInj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceSamplesInj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function SimulationTime_Callback(hObject, eventdata, handles)
% hObject    handle to SimulationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SimulationTime as text
%        str2double(get(hObject,'String')) returns contents of SimulationTime as a double


% --- Executes during object creation, after setting all properties.
function SimulationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SimulationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PatternTimeStep_Callback(hObject, eventdata, handles)
% hObject    handle to PatternTimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PatternTimeStep as text
%        str2double(get(hObject,'String')) returns contents of PatternTimeStep as a double


% --- Executes during object creation, after setting all properties.
function PatternTimeStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PatternTimeStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Methodgrid.
function Methodgrid_Callback(hObject, eventdata, handles)
% hObject    handle to Methodgrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Methodgrid


% --- Executes on button press in Methodrandom.
function Methodrandom_Callback(hObject, eventdata, handles)
% hObject    handle to Methodrandom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Methodrandom



function SourceSamplesDuration_Callback(hObject, eventdata, handles)
% hObject    handle to SourceSamplesDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourceSamplesDuration as text
%        str2double(get(hObject,'String')) returns contents of SourceSamplesDuration as a double


% --- Executes during object creation, after setting all properties.
function SourceSamplesDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceSamplesDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SourcePrcDuration_Callback(hObject, eventdata, handles)
% hObject    handle to SourcePrcDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SourcePrcDuration as text
%        str2double(get(hObject,'String')) returns contents of SourcePrcDuration as a double


% --- Executes during object creation, after setting all properties.
function SourcePrcDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourcePrcDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FlowSamplesPatterns_Callback(hObject, eventdata, handles)
% hObject    handle to FlowSamplesPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FlowSamplesPatterns as text
%        str2double(get(hObject,'String')) returns contents of FlowSamplesPatterns as a double


% --- Executes during object creation, after setting all properties.
function FlowSamplesPatterns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FlowSamplesPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FlowPrcPatterns_Callback(hObject, eventdata, handles)
% hObject    handle to FlowPrcPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FlowPrcPatterns as text
%        str2double(get(hObject,'String')) returns contents of FlowPrcPatterns as a double


% --- Executes during object creation, after setting all properties.
function FlowPrcPatterns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FlowPrcPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function basedemandsamples_Callback(hObject, eventdata, handles)
% hObject    handle to basedemandsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of basedemandsamples as text
%        str2double(get(hObject,'String')) returns contents of basedemandsamples as a double


% --- Executes during object creation, after setting all properties.
function basedemandsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basedemandsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Patterns_Callback(hObject, eventdata, handles)
% hObject    handle to Patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Patterns as text
%        str2double(get(hObject,'String')) returns contents of Patterns as a double


% --- Executes during object creation, after setting all properties.
function Patterns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Basedemand_Callback(hObject, eventdata, handles)
% hObject    handle to Basedemand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Basedemand as text
%        str2double(get(hObject,'String')) returns contents of Basedemand as a double


% --- Executes during object creation, after setting all properties.
function Basedemand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Basedemand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function elevationsamples_Callback(hObject, eventdata, handles)
% hObject    handle to elevationsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elevationsamples as text
%        str2double(get(hObject,'String')) returns contents of elevationsamples as a double


% --- Executes during object creation, after setting all properties.
function elevationsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elevationsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roughnesssamples_Callback(hObject, eventdata, handles)
% hObject    handle to roughnesssamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roughnesssamples as text
%        str2double(get(hObject,'String')) returns contents of roughnesssamples as a double


% --- Executes during object creation, after setting all properties.
function roughnesssamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roughnesssamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Elevation_Callback(hObject, eventdata, handles)
% hObject    handle to Elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Elevation as text
%        str2double(get(hObject,'String')) returns contents of Elevation as a double


% --- Executes during object creation, after setting all properties.
function Elevation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Elevation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Roughness_Callback(hObject, eventdata, handles)
% hObject    handle to Roughness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Roughness as text
%        str2double(get(hObject,'String')) returns contents of Roughness as a double


% --- Executes during object creation, after setting all properties.
function Roughness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Roughness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lengthsamples_Callback(hObject, eventdata, handles)
% hObject    handle to lengthsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lengthsamples as text
%        str2double(get(hObject,'String')) returns contents of lengthsamples as a double


% --- Executes during object creation, after setting all properties.
function lengthsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lengthsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diametersamples_Callback(hObject, eventdata, handles)
% hObject    handle to diametersamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diametersamples as text
%        str2double(get(hObject,'String')) returns contents of diametersamples as a double


% --- Executes during object creation, after setting all properties.
function diametersamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diametersamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Length_Callback(hObject, eventdata, handles)
% hObject    handle to Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Length as text
%        str2double(get(hObject,'String')) returns contents of Length as a double


% --- Executes during object creation, after setting all properties.
function Length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Diameter_Callback(hObject, eventdata, handles)
% hObject    handle to Diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Diameter as text
%        str2double(get(hObject,'String')) returns contents of Diameter as a double


% --- Executes during object creation, after setting all properties.
function Diameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Create.
function Create_Callback(hObject, eventdata, handles)
% hObject    handle to Create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    errorCode = CheckForError(handles);
    if errorCode
        return;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Methods
    P=gridmethod(handles);
    P.Method='grid';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    B=handles.B;
    [file0,pathname] = uiputfile([pwd,'\RESULTS\','*.0']);
    
    if isnumeric(file0)
        file0=[];
    end
    if ~isempty((file0)) 
        save([pathname,file0],'P','B','-mat');
        save([pwd,'\RESULTS\','File0.File'],'file0','-mat');
        save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');
        set(handles.figure1,'Visible','off');
        if exist([file0(1:end-2),'.w'],'file')==2
            delete([pathname,file0(1:end-2),'.w']);
        end
        load([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        msg=[msg;{['>>Scenario Parameters created in file "',file0,'".']}];
        set(handles.LoadText,'String',msg);
        set(handles.LoadText,'Value',length(msg));
        save([pwd,'\RESULTS\','ComWind.messsages'],'msg','-mat');
        guidata(hObject, handles);
    end

function errorCode = CheckForError(handles)
    errorCode=0;

    PatternTimeStep=str2num(get(handles.PatternTimeStep, 'String'));
    if ~length(PatternTimeStep) || PatternTimeStep<0
        msgbox('     Give Pattern Time Step', 'Error', 'modal')
        errorCode=1;
        return
    end

    % contaminant
    SourceInjectionRate=str2num(get(handles.SourceInjectionRate, 'String'));
    if ~length(SourceInjectionRate) || SourceInjectionRate<0
        msgbox('     Give Injection Concentration', 'Error', 'modal')
        errorCode=1;
        return
    end

    SourceDuration=str2num(get(handles.SourceDuration,'String'));
    if ~length(SourceDuration) || SourceDuration<0 
        msgbox('       Give Source Duration', 'Error', 'modal')
        errorCode=1;
        return
    end
    
    SimulationTime=str2num(get(handles.SimulationTime, 'String'));
    if  ~length(SimulationTime) || SimulationTime<0 %|| SimulationTime-SourceDuration<=0
        msgbox('       Give Simulation Time', 'Error', 'modal')
        errorCode=1;
        return
    end
    
    start=str2num(get(handles.start, 'String'));
    if  ~length(start) || start<0
        msgbox('Give Start Time of contaminant event', 'Error', 'modal')
        errorCode=1;
        return
    end

    stop=str2num(get(handles.stop, 'String'));
    if  ~length(stop) || stop<0
        msgbox('  Give Stop Time of contaminant event', 'Error', 'modal')
        errorCode=1;
        return
    end

    % variance
    SourcePrcInj=(str2double(get(handles.SourcePrcInj, 'String')));
    if isnan(SourcePrcInj) || SourcePrcInj<0
        msgbox('     Give percent of Injection', 'Error', 'modal')
        errorCode=1;
        return
    end 

    SourcePrcDuration=(str2double(get(handles.SourcePrcDuration, 'String')));
    if isnan(SourcePrcDuration) || SourcePrcDuration<0
        msgbox('     Give percent of Duration', 'Error', 'modal')
        errorCode=1;
        return
    end

    FlowPrcPatterns=(str2double(get(handles.FlowPrcPatterns, 'String')));
    if isnan(FlowPrcPatterns) || FlowPrcPatterns<0
        msgbox('    Give percent of Patterns', 'Error', 'modal')
        errorCode=1;
        return
    end

    % samples 
    SourceSamplesInj=str2num(char(get(handles.SourceSamplesInj, 'String')));
    if ~length(SourceSamplesInj) || SourceSamplesInj<0
        msgbox('   Give Samples of Injection', 'Error', 'modal')
        errorCode=1;
        return
    end 

    SourceSamplesDuration=str2num(char(get(handles.SourceSamplesDuration, 'String')));
    if ~length(SourceSamplesDuration) || SourceSamplesDuration<0
        msgbox('   Give Samples of Duration', 'Error', 'modal')
        errorCode=1;
        return
    end

    FlowSamplesPatterns=str2num(char(get(handles.FlowSamplesPatterns, 'String')));
    if ~length(FlowSamplesPatterns) || FlowSamplesPatterns<0
        msgbox('     Give Samples of Pattern', 'Error', 'modal')
        errorCode=1;
        return
    end

%     % methods
%     grid=get(handles.Methodgrid, 'Value'); 
%     random=get(handles.Methodrandom, 'Value');
%     if  grid && random || ~grid && ~random 
%         msgbox('         Select one Method', 'Error', 'modal')
%         errorCode=1; 
%         return
%     end

% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    [file0,pathname] = uigetfile([pathname,'*.0'],'Select the MATLAB *.0 file');
    if isnumeric(file0)
        file0=[];
    end
    if ~isempty((file0)) 
        load([pathname,file0],'-mat');

        if strcmp(handles.B.inputfile,B.inputfile)
            SetGuiParameters(P,B,hObject,handles);
        else
            msgbox('  Scenarios are not on this input file','Error','modal');
        end
    end
    save([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');


% --- Executes when entered data in editable cell(s) in LinkTable.
function LinkTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to LinkTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

    LinkTable = get(handles.LinkTable,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    % Column1 %
    if d==1 && col==1 && edit>-1  
        LinkTable(row,col)= new;
        set(handles.LinkTable,'data',LinkTable);
    elseif col==1
        LinkTable(row,col)=previous;
        set(handles.LinkTable,'data',LinkTable);
    end

    % Column2 Samples
    if d==1 && col==2 && edit>0  
        LinkTable(row,col)= new;
        set(handles.LinkTable,'data',LinkTable);
    elseif col==2
        LinkTable(row,col)=previous;
        set(handles.LinkTable,'data',LinkTable);
    end

    % Column3...ColumnN Links
    if d==1 && col>2 && edit>-1  
        LinkTable(row,col)= new;
        set(handles.LinkTable,'data',LinkTable);
    elseif col>2
        LinkTable(row,col)=previous;
        set(handles.LinkTable,'data',LinkTable);
    end


% --- Executes when entered data in editable cell(s) in NodeTable.
function NodeTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to NodeTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

    NodeTable = get(handles.NodeTable,'data');

    row = eventdata.Indices(1);
    col = eventdata.Indices(2);
    edit = eventdata.EditData;
    previous = eventdata.PreviousData;
    new = eventdata.NewData;

    edit = str2num(edit);
    d = length(edit);

    % Column1 %
    if d==1 && col==1 && edit>-1  
        NodeTable(row,col)= new;
        set(handles.NodeTable,'data',NodeTable);
    elseif col==1
        NodeTable(row,col)=previous;
        set(handles.NodeTable,'data',NodeTable);
    end

    % Column2 Samples
    if d==1 && col==2 && edit>0  
        NodeTable(row,col)= new;
        set(handles.NodeTable,'data',NodeTable);
    elseif col==2
        NodeTable(row,col)=previous;
        set(handles.NodeTable,'data',NodeTable);
    end

    % Column3...ColumnN Nodes
    if d==1 && col>2 && edit>-1  
        NodeTable(row,col)= new;
        set(handles.NodeTable,'data',NodeTable);
    elseif col>2
        NodeTable(row,col)=previous;
        set(handles.NodeTable,'data',NodeTable);
    end


% --- Executes on selection change in SourcesMaxNumber.
function SourcesMaxNumber_Callback(hObject, eventdata, handles)
% hObject    handle to SourcesMaxNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SourcesMaxNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourcesMaxNumber


% --- Executes during object creation, after setting all properties.
function SourcesMaxNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourcesMaxNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in releaseLocation.
function releaseLocation_Callback(hObject, eventdata, handles)
% hObject    handle to releaseLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    for i=1:handles.B.NodeCount
        data{i,1} = handles.B.getNodeNameID{i};
        data{i,2}= handles.release(i);
    end

    set(0,'userdata',data);


    ReleaseLocation(handles.B);
    uiwait(ReleaseLocation)

    SomeDataShared=get(0,'userdata');

    for i=1:handles.B.NodeCount
        handles.release(i)=SomeDataShared{i,2} ;
    end
    guidata(hObject, handles);

function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stop as text
%        str2double(get(hObject,'String')) returns contents of stop as a double


% --- Executes during object creation, after setting all properties.
function stop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start as text
%        str2double(get(hObject,'String')) returns contents of start as a double


% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in defaultbutton.
function defaultbutton_Callback(hObject, eventdata, handles)
% hObject    handle to defaultbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    button = questdlg('Do you want to continue?',...
    'Default','Yes','No','No');

    button = strcmp(button,'Yes');

    if button==1
        P=DefaultParameters(handles);
        handles.P=P;
        handles.release(1:handles.B.NodeCount)=true;
        P.SourcesNodeIndices=handles.release;
        % Update handles structure
        guidata(hObject, handles);

        SetGuiParameters(P,handles.B,hObject,handles);
    end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
	delete(hObject);


% --- Executes on button press in SourcesMaxNumber1.
function SourcesMaxNumber1_Callback(hObject, eventdata, handles)
% hObject    handle to SourcesMaxNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SourcesMaxNumber1

    value = get(handles.SourcesMaxNumber1,'Value');

    if value==1
        set(handles.SourcesMaxNumber1,'Value',1); 
        set(handles.SourcesMaxNumber2,'Value',0);  
    else 
        set(handles.SourcesMaxNumber2,'Value',1);  
        set(handles.SourcesMaxNumber1,'Value',0);  
    end


% --- Executes on button press in SourcesMaxNumber2.
function SourcesMaxNumber2_Callback(hObject, eventdata, handles)
% hObject    handle to SourcesMaxNumber2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SourcesMaxNumber2
    value = get(handles.SourcesMaxNumber2,'Value');

    if value==1
        set(handles.SourcesMaxNumber2,'Value',1); 
        set(handles.SourcesMaxNumber1,'Value',0);  
    else 
        set(handles.SourcesMaxNumber1,'Value',1);  
        set(handles.SourcesMaxNumber2,'Value',0);  
    end


% --- Executes on button press in SensingLocation.
function SensingLocation_Callback(hObject, eventdata, handles)
% hObject    handle to SensingLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    for i=1:handles.B.NodeCount
        data{i,1} = handles.B.NodeNameID{i};
        data{i,2}= handles.sensing(i);
    end

    set(0,'userdata',data);
    
    SensingLocation(handles.B,handles.sensing);
    uiwait(SensingLocation)

    SomeDataShared=get(0,'userdata');

    for i=1:handles.B.NodeCount
        handles.sensing(i)=SomeDataShared{i,2} ;
    end
    guidata(hObject, handles);
    

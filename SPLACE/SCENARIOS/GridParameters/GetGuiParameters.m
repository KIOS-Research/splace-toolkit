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

function P=GetGuiParameters(varargin)
    % varargin{1}...handles.
    B=varargin{1}.B;

    % Time Parameters
    P.SimulationTime = str2num(get(varargin{1}.SimulationTime,'String'));
    P.PatternTimeStep = str2num(get(varargin{1}.PatternTimeStep,'String'));

    % CONTAMINANT (A)
    P.SourcePrc={};
    P.SourceSamples={};
    P.SourceInjectionRate = str2num(get(varargin{1}.SourceInjectionRate,'String'));
    P.SourceDuration = str2num(get(varargin{1}.SourceDuration,'String'));
    P.SourcePrc{1} = str2double(get(varargin{1}.SourcePrcInj,'String'));
    P.SourceSamples{1} = str2double(get(varargin{1}.SourceSamplesInj,'String'));
    P.SourcePrc{2} = str2double(get(varargin{1}.SourcePrcDuration,'String'));
    P.SourceSamples{2} = str2double(get(varargin{1}.SourceSamplesDuration,'String'));
    P.SourceParameters={'SourceInjectionRate','SourceDuration'};
    P.SourceValues={P.SourceInjectionRate, P.SourceDuration};

    % CONTAMINANT (B)
    v=get(varargin{1}.SourcesMaxNumber1,'Value'); %maximum number of simultaneous sources (including 1,2..)
    if v==1
        P.SourcesMaxNumber=1;
    else
        P.SourcesMaxNumber=2;
    end

    P.SourcesInjectionTimes(1)=str2num(get(varargin{1}.start,'String'));
    P.SourcesInjectionTimes(2)=str2num(get(varargin{1}.stop,'String'));

    % Reslease Location
    P.SourcesNodeIndices(1:B.CountNodes)=0;
    for i=1:varargin{1}.B.CountNodes
        P.SourcesNodeIndices(i)=varargin{1}.release(i);
        if P.SourcesNodeIndices(i)~=0
            P.SourcesNodeIndices(i)=i;%u=u+1;
        end
    end
    % Sensing Location
    P.SensingNodeIndices(1:B.CountNodes)=0;
    for i=1:varargin{1}.B.CountNodes
        P.SensingNodeIndices(i)=varargin{1}.sensing(i);
        if P.SensingNodeIndices(i)~=0
            P.SensingNodeIndices(i)=i;%u=u+1;
        end
    end
    
    % Hydraulic Parameters

    % Links
    % Diameters
    LinkTable=get(varargin{1}.LinkTable,'data');
    P.FlowPrc={};
    P.FlowSamples={};

    P.FlowPrc{1}=LinkTable(1,1);
    P.FlowSamples{1}=LinkTable(1,2);
    P.Diameters=LinkTable(1,3:end);
    % Lengths
    P.FlowPrc{2}=LinkTable(2,1);
    P.FlowSamples{2}=LinkTable(2,2);
    P.Lengths=LinkTable(2,3:end);
    % Roughness
    P.FlowPrc{3}=LinkTable(3,1);
    P.FlowSamples{3}=LinkTable(3,2);
    P.Roughness=LinkTable(3,3:end);

    % Nodes
    % Elevations
    NodeTable=get(varargin{1}.NodeTable,'data');
    P.FlowPrc{4}=NodeTable(1,1);
    P.FlowSamples{4}=NodeTable(1,2);
    P.Elevation=NodeTable(1,3:end);
    % Basedemands
    P.FlowPrc{5}=NodeTable(2,1);
    P.FlowSamples{5}=NodeTable(2,2);
    P.BaseDemand=NodeTable(2,3:end);
    % Patterns
    P.Patterns=B.getPattern;
    P.FlowPrc{6}=str2double(get(varargin{1}.FlowPrcPatterns,'String'));
    P.FlowSamples{6} = str2double(get(varargin{1}.FlowSamplesPatterns,'String'));

    P.FlowParameters={'Diameters', 'Lengths','Roughness',...
        'Elevation','BaseDemand','Patterns'};
    P.FlowValues={P.Diameters, P.Lengths, P.Roughness,...
        P.Elevation, P.BaseDemand, P.Patterns};
end
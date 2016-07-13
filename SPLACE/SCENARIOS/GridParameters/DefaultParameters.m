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

function P=DefaultParameters(varargin)
    if isstruct(varargin{1})
        B=varargin{1}.B;
    else
        B=varargin{1};
    end
    disp('Create Scenario Parameters')

    P.Method='grid';
    P.MethodParameter=NaN;

    %TIMES
    P.PatternTimeStep=B.getTimePatternStep;
    P.SimulationTime=48; %e.g.48 in Hours


    %CONTAMINANT (A)
    P.SourceInjectionRate=10; %mg/L (Concentration), instead of mg/minute
    P.SourceDuration=2; %hours
    P.SourceParameters={'SourceInjectionRate','SourceDuration'};
    P.SourceValues={P.SourceInjectionRate, P.SourceDuration};
    P.SourcePrc={0, 0}; %EDITABLE
    P.SourceSamples={1,1}; %EDITABLE

    %CONTAMINANT (B)
    P.SourcesMaxNumber=1; % maximum number of simultaneous sources (including 1,2..)
    P.SourcesInjectionTimes=[0 24]; %from...to in hours
    %P.SourcesInjectionTimes=[4 5]; %from...to in hours
    P.SourcesNodeIndices=1:B.NodeCount;
    P.SensingNodeIndices=1:B.NodeCount;
    %P.SourcesNodeIndices=[3 10];
    %P.SourcesNodeIndices=89;

    %AFFECTING FLOWS
    P.Diameters=B.getLinkDiameter;
    P.Lengths=B.getLinkLength;
    P.Roughness=B.getLinkRoughnessCoeff;
    P.Elevation=B.getNodeElevations;
    P.BaseDemand=B.getNodeBaseDemands{1};
    %P.SourcesNodeIndicesNonZero=P.BaseDemand~=0;
    P.NodesNonZeroDemands=find(P.BaseDemand>0);
    P.Patterns=B.getPattern;

    P.FlowParameters={'Diameters', 'Lengths','Roughness',...
        'Elevation','BaseDemand','Patterns'};
    P.FlowValues={P.Diameters, P.Lengths, P.Roughness,...
        P.Elevation, P.BaseDemand, P.Patterns};
    P.FlowPrc={0,0,0,0,0,5};
    P.FlowSamples={1,1,1,1,1,1};
end
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

function [P,B]=gridmethod(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isstruct(varargin{1})
        P=GetGuiParameters(varargin{1});
        B=varargin{1}.B;
    else
        P=DefaultParameters(varargin{1});
        B=varargin{1};
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    FlowScenarioSets={};
    ContamScenarioSets={};

    %compute scenarios affecting flows
    for i=1:length(P.FlowParameters)
        P.FlowParamScenarios{i}=linspaceNDim((P.FlowValues{i}-(P.FlowPrc{i}/100).*P.FlowValues{i})', (P.FlowValues{i}+(P.FlowPrc{i}/100).*P.FlowValues{i})', P.FlowSamples{i});
        if find(strcmp(P.FlowParameters{i},'Patterns'))
            if (size(P.Patterns,1)==1)
                FlowScenarioSets{i}=1:size(P.FlowParamScenarios{i},2);
            else
                FlowScenarioSets{i}=1:size(P.FlowParamScenarios{i},3);
            end
        else
            FlowScenarioSets{i}=1:size(P.FlowParamScenarios{i},2);
        end
    end
    %compute scenarios affecting contamination sources
    for i=1:length(P.SourceParameters)
        P.SourceParamScenarios{i}=linspaceNDim((P.SourceValues{i}-(P.SourcePrc{i}/100).*P.SourceValues{i})', (P.SourceValues{i}+(P.SourcePrc{i}/100).*P.SourceValues{i})', P.SourceSamples{i});
        ContamScenarioSets{i}=1:size(P.SourceParamScenarios{i},1);
    end   
    %compute all source locations
    k=1;
    for i=1:P.SourcesMaxNumber
        tmp=combnk(P.SourcesNodeIndices,i);
        for j=1:size(tmp,1)
            T(k)={tmp(j,:)};
            k=k+1;
        end
    end
    P.SourceLocationScenarios=T;
    ContamScenarioSets{size(ContamScenarioSets,2)+1}=1:size(P.SourceLocationScenarios,2);
  
    tmpsteps=(P.SourcesInjectionTimes(2)-P.SourcesInjectionTimes(1))*3600/P.PatternTimeStep;
    psim=double(P.SimulationTime);
    pts=double(P.PatternTimeStep);
    P.SourceTimes=min(find(pts/3600*(0:(psim-(pts/3600)))>=P.SourcesInjectionTimes(1))):max(find(pts/3600*(0:(psim-(pts/3600)))<=P.SourcesInjectionTimes(2)));
    ContamScenarioSets{size(ContamScenarioSets,2)+1}=1:length(P.SourceTimes);
    
    P.FlowScenarioSets=FlowScenarioSets;
    P.ContamScenarioSets=ContamScenarioSets;
    P.ScenariosFlowIndex=cartesianProduct(FlowScenarioSets);
    P.ScenariosContamIndex=cartesianProduct(ContamScenarioSets);
    P.TotalScenarios=size(P.ScenariosFlowIndex,1)*size(P.ScenariosContamIndex,1);        
    P.newTotalofScenarios=P.TotalScenarios;
    if ~isstruct(varargin{1})
        file0='file0';
        save([pwd,'\RESULTS\',file0,'.0'],'P','B','-mat');
    end
end
    
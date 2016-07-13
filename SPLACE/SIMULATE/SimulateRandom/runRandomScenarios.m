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

function [P]=runRandomScenarios(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isstruct(varargin{1}) 
        file0=varargin{1}.file0;
        T=varargin{1}.T;
        EditNofSce=varargin{1}.EditNofSce;
    else
        B=varargin{1};
        P=varargin{2};
        file0=varargin{3};
        EditNofSce=varargin{4};
        T=100; %save every 1000 scenarios
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');

    load([pathname,file0,'.0'],'-mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %P.ScenariosContamIndex=P.ScenariosContamIndex(1:EditNofSce/size(P.ScenariosFlowIndex,1),:);
%     P.ScenariosContamIndex=P.ScenariosContamIndex(randi(size(P.ScenariosContamIndex,1),EditNofSce,1),:);
    P.ScenariosFlowIndex=P.ScenariosFlowIndex(randi(size(P.ScenariosFlowIndex,1),size(P.ScenariosFlowIndex,1),1),:);
    P.ScenariosContamIndex=P.ScenariosContamIndex(randi(size(P.ScenariosContamIndex,1),(EditNofSce)/(size(P.ScenariosFlowIndex,1)),1),:);
    a=mod((EditNofSce),(size(P.ScenariosFlowIndex,1)));
    if a~=0
        P.ScenariosFlowIndex=[P.ScenariosFlowIndex;P.ScenariosFlowIndex(randi(size(P.ScenariosFlowIndex,1),a,1),:)];
        P.ScenariosContamIndex=[P.ScenariosContamIndex;P.ScenariosContamIndex(randi(size(P.ScenariosContamIndex,1),a,1),:)];
    end
    B.setQualityType('chem','mg/L')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    B.setTimeSimulationDuration(P.SimulationTime*3600);

%     disp('Create Hydraulic files')
    for i=1:size(P.ScenariosFlowIndex,1)
        B.setLinkDiameter(P.FlowParamScenarios{1}(:, P.ScenariosFlowIndex(i,1))')
        B.setLinkLength(P.FlowParamScenarios{2}(:, P.ScenariosFlowIndex(i,2))')
        B.setLinkRoughnessCoeff(P.FlowParamScenarios{3}(:, P.ScenariosFlowIndex(i,3))')
        B.setNodeElevations(P.FlowParamScenarios{4}(:, P.ScenariosFlowIndex(i,4))')
        B.setNodeBaseDemands(P.FlowParamScenarios{5}(:, P.ScenariosFlowIndex(i,5))')
        if size(P.Patterns,1)==1
            B.setPatternMatrix(P.FlowParamScenarios{6}(:,P.ScenariosFlowIndex(i,6))')
        else
            B.setPatternMatrix(P.FlowParamScenarios{6}(:,:,P.ScenariosFlowIndex(i,6))')
        end
        B.solveCompleteHydraulics;
        B.saveHydraulicFile([pathname,file0,'.h',num2str(i)]);
    end
    
%     disp('Create Quality files')
    pstep=double(B.getTimePatternStep);
    B.setTimeQualityStep(pstep);
    zeroNodes=zeros(1,B.NodeCount);
    B.setNodeInitialQuality(zeroNodes);
    B.setLinkBulkReactionCoeff(zeros(1,B.LinkCount));
    B.setLinkWallReactionCoeff(zeros(1,B.LinkCount));
    for i=1:B.NodeCount
        B.setNodeSourceType(i,'SETPOINT');
    end
    patlen=(P.SimulationTime)*3600/pstep;
    sizeflowscenarios=size(P.ScenariosFlowIndex,1);
    sizecontscenarios=size(P.ScenariosContamIndex,1);
%     disp(['Hydraulic Scenarios: ', num2str(sizeflowscenarios), ', Quality Scenarios:',num2str(sizecontscenarios)])

%     SensingNodeIndices_NodeBaseDemands=unique([find(P.SensingNodeIndices),find(B.NodeBaseDemands)]);
    SensingNodeIndices_NodeBaseDemands=unique([find(P.SensingNodeIndices),find(B.NodeBaseDemands{1})]);
    
    l=0;
    t0=1;
    k=1;pp=1;
    for j=1:(sizeflowscenarios*sizecontscenarios)
        if mod(j,sizecontscenarios)==1
            l=l+1;
            tmphydfile=[pathname,file0,'.h',num2str(l)];
            B.useHydraulicFile(tmphydfile);
            disp(['Hydraulic Scenario ',num2str(l)])
            st2=0;
            avtime=inf;
            D{l}=B.getComputedQualityTimeSeries('time','demandSensingNodes',SensingNodeIndices_NodeBaseDemands);
            i=1;
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isstruct(varargin{1}) 
            if mod(pp,100)==1
                nload=pp/(sizeflowscenarios*sizecontscenarios); 
                varargin{1}.color=char('red');
                progressbar(varargin{1},nload)
            end
            pp=pp+1;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        disp(['Scenario: ',num2str(i)])
        t1=tic;
        tmppat=zeros(1,patlen);
        tmpstartstep=P.SourceTimes(P.ScenariosContamIndex(i,4));
        tmpendstep=tmpstartstep+round(P.SourceParamScenarios{2}(P.ScenariosContamIndex(i,2))*3600/pstep)-1;
        tmppat(tmpstartstep:tmpendstep)=1;
        tmp1=B.addPattern('CONTAMINANT',tmppat);
        tmpinjloc=P.SourceLocationScenarios{P.ScenariosContamIndex(i,3)};
        tmp2=zeroNodes;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if tmpinjloc~=0
            tmp2(tmpinjloc)=tmp1;
            B.setNodeSourcePatternIndex(tmp2);
            tmp2 = zeroNodes;
            tmp2(tmpinjloc)=P.SourceParamScenarios{1}(P.ScenariosContamIndex(i,1));
            B.setNodeSourceQuality(tmp2)
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        C{k}=B.getComputedQualityTimeSeries('qualitySensingNodes',SensingNodeIndices_NodeBaseDemands);
        d(k)=l;
        t2=toc(t1);
        st2=st2+t2;
        avtime=st2/i;
        i=i+1;  
        if mod(j,T)==0;
            save([pathname,file0,'.c',num2str(t0)],'C','t0','d','-mat');
            t0=t0+1;
            clear C;
            clear d;
            k=1;
        else
            k=k+1;
        end
    end
    try
        save([pathname,file0,'.c',num2str(t0)],'C','t0','d','-mat');
        clear C;
    catch err
    end
    P.newTotalofScenarios=EditNofSce;
    save([pathname,file0,'.0'],'P','B','-mat');
    save([pathname,file0,'.c0'],'D','T','l','t0', '-mat');    
    SimulateMethod='random';
    save([pathname,'Simulate.Method'],'SimulateMethod','-mat');
end
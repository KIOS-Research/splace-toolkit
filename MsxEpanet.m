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

classdef MsxEpanet <handle 
    % The MSX EPANET class v.1.04
    properties %(Attributes)
        MsxFile;
        MsxPathFile;
        errorCode;
        CountSpeciesMsx;
        CountConstantsMsx;
        CountParametersMsx;
        CountPatternsMsx;
        
        ConstantNameIDMsx;
        ConstantValueMsx;
        
        ParameterNameIDMsx;
        ParametersIndexMsx;
        NodeParameterValueMsx;
        LinkParameterValueMsx;

        PatternIDMsx;
        PatternIndexMsx;
        PatternLengthsMsx;
                
        SpeciesNameIDMsx;
        SpeciesTypeMsx;
        SpeciesUnitsMsx;
        SpeciesAtolMsx;
        SpeciesRtolMsx;
        
        NodeInitqualValueMsx;
        LinkInitqualValueMsx;
        
        SourceTypeMsx;
        SourceLevelMsx;
        SourcePatternIndexMsx; 
        SourcePatternIDMsx;
    
    end
    methods
%         B = Epanet('Net2_Rossman2000.inp');
        function obj =  MsxEpanet(B,pathfile,varargin)
            if nargin==3
                msxfile=varargin{1};
                obj.MsxPathFile=pathfile;
            elseif nargin==2
                msxfile=pathfile;
                obj.MsxPathFile=which(pathfile);
            end
            
            %MSXMatlabSetup  
            MSXMatlabSetup('epanetmsx','epanetmsx.h');
            
            %MSXopen  
            [obj.errorCode] = MSXopen(obj.MsxPathFile);
            obj.MsxFile=msxfile;

            %MSXgetcount  
            [obj.errorCode, obj.CountSpeciesMsx] = MSXgetcount(3);
            [obj.errorCode, obj.CountConstantsMsx] = MSXgetcount(6);
            [obj.errorCode, obj.CountParametersMsx] = MSXgetcount(5);
            [obj.errorCode, obj.CountPatternsMsx] = MSXgetcount(7);
            
            for i=1:obj.CountSpeciesMsx
                %MSXgetIDlen
                [obj.errorCode,len] = MSXgetIDlen(3,i);
                %MSXgetID 
                [obj.errorCode,obj.SpeciesNameIDMsx{i}] = MSXgetID(3,i,len);
                %MSXgetspecies
                [obj.errorCode,obj.SpeciesTypeMsx{i},obj.SpeciesUnitsMsx{i},obj.SpeciesAtolMsx(i),obj.SpeciesRtolMsx(i)] = MSXgetspecies(i);
            end
               
            %MSXgetconstant
            for i=1:obj.CountConstantsMsx
                [obj.errorCode, len] = MSXgetIDlen(6,i);
                [obj.errorCode, obj.ConstantNameIDMsx{i}] = MSXgetID(6,i,len);
                [obj.errorCode, obj.ConstantValueMsx(i)] = MSXgetconstant(i);
            end
          
            % MSXgetparameter
            for i=1:obj.CountParametersMsx
                [obj.errorCode, len] = MSXgetIDlen(5,i);
                [obj.errorCode, obj.ParameterNameIDMsx{i}] = MSXgetID(5,i,len); 
                %MSXgetindex
                [obj.errorCode, obj.ParametersIndexMsx(i)] = MSXgetindex(obj,5,obj.ParameterNameIDMsx{i}); 
            end
            for i=1:B.CountNodes
                for j=1:obj.CountParametersMsx
                   [obj.errorCode, obj.NodeParameterValueMsx{i}(j)] = MSXgetparameter(0,i,j);   
                end
            end
            for i=1:B.CountLinks
                for j=1:obj.CountParametersMsx
                   [obj.errorCode, obj.LinkParameterValueMsx{i}(j)] = MSXgetparameter(1,i,j);   
                end
            end
            %MSXgetpatternlen
            for i=1:obj.CountPatternsMsx
                [obj.errorCode, len] = MSXgetIDlen(7,i);
                [obj.errorCode, obj.PatternIDMsx{i}] = MSXgetID(7,i,len);
                [obj.errorCode, obj.PatternIndexMsx(i)] = MSXgetindex(obj,7,obj.PatternIDMsx{i});
                [obj.errorCode, obj.PatternLengthsMsx(i)] = MSXgetpatternlen(i);
            end

            %MSXgetinitqual
            for i=1:B.CountNodes
                for j=1:obj.CountSpeciesMsx
                   [obj.errorCode, obj.NodeInitqualValueMsx{i}(j)] = MSXgetinitqual(0,i,j);   
                end
            end
            for i=1:B.CountLinks
                for j=1:obj.CountSpeciesMsx
                   [obj.errorCode, obj.LinkInitqualValueMsx{i}(j)] = MSXgetinitqual(1,i,j);   
                end
            end

            %MSXgetsource
            for i=1:B.CountNodes
                for j=1:obj.CountSpeciesMsx 
                   [obj.errorCode, obj.SourceTypeMsx{i}{j},obj.SourceLevelMsx{i}(j),obj.SourcePatternIndexMsx{i}(j)] = MSXgetsource(i,j);  
                   [obj.errorCode, len] = MSXgetIDlen(7,i);
                   obj.SourcePatternIDMsx{i}(j) = MSXgetID(7,obj.SourcePatternIndexMsx{i}(j),len);
                end
            end

        end
        
        %%%%%%%%%%%%%%%%% SOLVE FUNCTIONS %%%%%%%%%%%%%%%%%
        %MSXsolveH
        function solveCompleteHydraulicsMsx(obj)
            [obj.errorCode] = MSXsolveH();
        end
        
        %MSXsolveQ
        function solveCompleteQualityMsx(obj)
            [obj.errorCode] = MSXsolveQ();
        end
        
        %%%%%%%%%%%%%%%%% ADD FUNCTIONS %%%%%%%%%%%%%%%%%
        
        %MSXaddpattern
        function valueIndex = addPattern(obj,varargin)
            valueIndex=-1;
            if nargin==2
                [obj.errorCode] = MSXaddpattern(varargin{1});
                [obj.errorCode, valueIndex] = MSXgetindex(obj,7,varargin{1}); 
            elseif nargin==3
                [obj.errorCode] = MSXaddpattern(varargin{1});
                [obj.errorCode, valueIndex] = MSXgetindex(obj,7,varargin{1}); 
                setPattern(obj,valueIndex,varargin{2});
            end
        end
        
        
        %%%%%%%%%%%%%%%%% SET FUNCTIONS %%%%%%%%%%%%%%%%%
               
        %ENsetlinkvalue
        function setLinkDiameter(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 0, value(i));
            end
        end
%         function setLinkDiameter(obj,index, value)
%             [obj.errorCode] = ENsetlinkvalue(index, 0, value);
%         end
        function setLinkLength(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 1, value(i));
            end
        end
        function setLinkRoughness(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 2, value(i));
            end
        end
        function setLinkMinorLossCoeff(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 3, value(i));
            end
        end
        function setLinkInitialStatus(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 4, value(i));
            end
        end
        function setLinkInitialSettings(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 5, value(i));
            end
        end
        function setLinkBulkReactionCoeff(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 6, value(i));
            end
        end
        function setLinkWallReactionCoeff(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 7, value(i));
            end
        end
        function setLinkStatus(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 11, value(i));
            end
        end
        function setLinkSettings(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetlinkvalue(i, 12, value(i));
            end
        end
        
        
        %ENsetnodevalue
        function setNodeElevation(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 0, value(i));
            end
%             [obj.errorCode, obj.NodeElevations(index)] = ENgetnodevalue(index, 0);
        end
        function setNodeBaseDemand(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 1, value(i));
            end
            %[obj.errorCode, obj.NodeBaseDemands(index)] = ENgetnodevalue(index, 1);
        end
        function setNodeDemandPatternIndex(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 2, value(i));
            end
        end
        function setNodeEmitterCoeff(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 3, value(i));
            end
        end
        function setNodeInitialQuality(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 4, value(i));
            end
        end
        function setTankLevelInitial(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 8, value(i));
            end
        end
        
        %ENsetoption
        function setOptionTrial(obj,value)
            [obj.errorCode] = ENsetoption(0,value);
            [obj.errorCode, obj.OptionsTrials] = ENgetoption(0);
        end
        function setOptionAccuracy(obj,value)
            [obj.errorCode] = ENsetoption(1,value);
            [obj.errorCode, obj.OptionsAccuracy] = ENgetoption(1);
        end
        function setOptionTolerance(obj,value)
            [obj.errorCode] = ENsetoption(2,value);
            [obj.errorCode, obj.OptionsTolerance] = ENgetoption(2);
        end
        function setOptionEmitterExponent(obj,value)
            [obj.errorCode] = ENsetoption(3,value);
            [obj.errorCode, obj.OptionsEmmiterExponent] = ENgetoption(3);
        end
        function setOptionDemandMult(obj,value)
            [obj.errorCode] = ENsetoption(4,value);
            [obj.errorCode, obj.OptionsDemandMult] = ENgetoption(4);
        end
        
        %ENsettimeparam
        function setTimeSimulationDuration(obj,value)
            [obj.errorCode] = ENsettimeparam(0,value);
            [obj.errorCode, obj.TimeSimulationDuration] = ENgettimeparam(0);
            
        end
        function setTimeHydraulicStep(obj,value)
            [obj.errorCode] = ENsettimeparam(1,value);
            [obj.errorCode, obj.TimeHydraulicStep] = ENgettimeparam(1);
        end
        function setTimeQualityStep(obj,value)
            [obj.errorCode] = ENsettimeparam(2,value);
            [obj.errorCode, obj.TimeQualityStep] = ENgettimeparam(2);
        end
        function setTimePatternStep(obj,value)
            [obj.errorCode] = ENsettimeparam(3,value);
            [obj.errorCode, obj.TimePatternStep] = ENgettimeparam(3);
        end
        function setTimePatternStart(obj,value)
            [obj.errorCode] = ENsettimeparam(4,value);
            [obj.errorCode, obj.TimePatternStart] = ENgettimeparam(4);
        end
        function setTimeReportingStep(obj,value)
            [obj.errorCode] = ENsettimeparam(5,value);
            [obj.errorCode, obj.TimeReportingStep] = ENgettimeparam(5);
        end
        function setTimeReportingStart(obj,value)
            [obj.errorCode] = ENsettimeparam(6,value);
            [obj.errorCode, obj.TimeReportingStart] = ENgettimeparam(6);
        end
        
        function setTimeStatistics(obj,value)
            %'NONE','AVERAGE','MINIMUM','MAXIMUM', 'RANGE'
            tmpindex=find(strcmpi(obj.TYPESTATS,value)==1)-1;
            [obj.errorCode] = ENsettimeparam(8,tmpindex);
            [obj.errorCode, obj.TimeStatisticsIndex] = ENgettimeparam(8);
        end
        
        %MSXsetpattern
        function setPattern(obj,index,patternVector)
            nfactors=length(patternVector);
            [obj.errorCode] = MSXsetpattern(index, patternVector, nfactors);
        end
        function setPatternMatrix(obj,patternMatrix)
            nfactors=size(patternMatrix,2);
            for i=1:size(patternMatrix,1)
                [obj.errorCode] = MSXsetpattern(i, patternMatrix(i,:), nfactors);
            end
        end
        %MSXsetpatternvalue
        function setPatternValue(obj,index, patternTimeStep, patternFactor)
            [obj.errorCode] = MSXsetpatternvalue(index, patternTimeStep, patternFactor);
        end
        
        
        function setQualityType(obj,varargin)
            qualcode=0;
            chemname='';
            chemunits='';
            tracenode='';
            if find(strcmpi(varargin,'none')==1)
                [obj.errorCode] = ENsetqualtype(qualcode,chemname,chemunits,tracenode);
            elseif find(strcmpi(varargin,'age')==1)
                qualcode=2;
                [obj.errorCode] = ENsetqualtype(qualcode,chemname,chemunits,tracenode);
            elseif find(strcmpi(varargin,'chem')==1)
                qualcode=1;
                chemname=varargin{1};
                chemunits=varargin{2};
                [obj.errorCode] = ENsetqualtype(qualcode,chemname,chemunits,tracenode);
            elseif find(strcmpi(varargin,'trace')==1)
                qualcode=3;
                tracenode=varargin{2};
                [obj.errorCode] = ENsetqualtype(qualcode,chemname,chemunits,tracenode);
            end
        end
        
        %ENresetreport
        function setReportFormatReset(obj)
            [obj.errorCode]=ENresetreport();
        end
        
        %ENsetstatusreport
        function setReportStatus(obj,value) %'yes','no','full'
            statuslevel=find(strcmpi(obj.TYPEREPORT,value)==1)-1;
            [obj.errorCode] = ENsetstatusreport(statuslevel);
        end
        
        %ENsetreport
        function setReport(obj,value)
            [obj.errorCode] = ENsetreport(value);
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %%%%%%%%%%%%%%%%% GET FUNCTIONS %%%%%%%%%%%%%%%%%
        
        function value = getControls(obj)
            for i=1:obj.getCountControls
                [obj.errorCode, obj.ControlTypeIndex(i),obj.ControlLink(i),obj.ControlSeetting(i),obj.ControlNodeIndex(i),obj.ControlLevel(i)] = ENgetcontrol(i);
                obj.ControlType(i)=obj.TYPECONTROL(obj.ControlTypeIndex(i)+1);
            end
            obj.ControlAll={obj.ControlType,obj.ControlTypeIndex,obj.ControlLink,obj.ControlSeetting,obj.ControlNodeIndex,obj.ControlLevel};
            value=obj.ControlAll;
        end
        
        %ENgetcount
        function value  =  getCountNodes(obj)
            % Nodes, Tanks/Reservoirs, Links, Patterns, Curves, Controls
            [obj.errorCode, value] = ENgetcount(0);
        end
        function value  =  getCountTanksReservoirs(obj)
            [obj.errorCode, value] = ENgetcount(1);
        end
        function value  =  getCountLinks(obj)
            [obj.errorCode, value] = ENgetcount(2);
        end
        function value  =  getCountPatterns(obj)
            [obj.errorCode, value] = ENgetcount(3);
        end
        function value  =  getCountCurves(obj)
            [obj.errorCode, value] = ENgetcount(4);
        end
        function value  =  getCountControls(obj)
            [obj.errorCode, value] = ENgetcount(5);
        end
        
        
        %ENgeterror
        function value = getError(obj,errcode)
            [obj.errorCode, value] = ENgeterror(errcode);
        end
        
        %ENgetflowunits
        function value = getFlowUnits(obj)
            [obj.errorCode, obj.UnitsCode] = ENgetflowunits();
            obj.UnitsType=obj.TYPEUNITS(obj.UnitsCode+1);
            value=obj.UnitsType;
        end
        
        %ENgetlinkid
        function value = getLinkID(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountLinks
                    [obj.errorCode, value{i}]=ENgetlinkid(i);
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, value{k}]=ENgetlinkid(i);
                    k=k+1;
                end
            end
        end
        
        %ENgetlinkindex
        function value = getLinkIndex(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountLinks;
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = ENgetlinkindex(varargin{1}{j});
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                [obj.errorCode, value] = ENgetlinkindex(varargin{1});
            end
        end
        
        %ENgetlinknodes
        function value = getLinkNodes(obj)
            for i=1:obj.getCountNodes
                [obj.errorCode,linkFromNode,linkToNode] = ENgetlinknodes(i);
                value(i,:)= [linkFromNode,linkToNode];
            end
        end
        
        %ENgetlinktype
        function value = getLinkType(obj)
            for i=1:obj.CountLinks
                [obj.errorCode,obj.LinkTypeIndex(i)] = ENgetlinktype(i);
                if obj.LinkTypeIndex(i)>2
                    obj.LinkTypeIndex(i)=9; %Valve  
                elseif obj.LinkTypeIndex(i)==1
                    obj.LinkTypeIndex(i)=1; %cvpipe pipe
                end
                value(i)=obj.TYPELINK(obj.LinkTypeIndex(i)+1);
            end
        end
        
        %ENgetlinkvalue
        function value = getLinkDiameter(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,0);
            end
        end
        function value = getLinkLength(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,1);
            end
        end
        function value = getLinkRoughness(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,2);
            end
        end
        function value = getLinkMinorLossCoeff(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,3);
            end
        end
        function value = getLinkInitialStatus(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,4);
            end
        end
        function value = getLinkInitialSettings(obj)
            %Roughness for pipes,initial speed for pumps,initial setting
            %for valves
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,5);
            end
        end
        function value = getLinkBulkReactionCoeff(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,6);
            end
        end
        function value = getLinkWallReactionCoeff(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,7);
            end
        end
        function value = getLinkFlows(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,8);
            end
        end
        function value = getLinkVelocity(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,9);
            end
        end
        function value = getLinkHeadloss(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,10);
            end
        end
        function value = getLinkStatus(obj)
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,11);
            end
        end
        function value = getLinkSettings(obj) %Roughness for pipes, actual speed for pumps, actual setting for valves
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,12);
            end
        end
        function value = getLinkEnergy(obj) %in kwatts
            value=zeros(1,obj.CountLinks);
            for i=1:obj.CountLinks
                [obj.errorCode, value(i)] = ENgetlinkvalue(i,13);
            end
        end
        
        
        %ENgetnodeid
        function value = getNodeID(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountNodes
                    [obj.errorCode, value{i}]=ENgetnodeid(i);
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, value{k}]=ENgetnodeid(i);
                    k=k+1;
                end
            end
        end
        
        %ENgetnodeindex
        function value = getNodeIndex(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountNodes;
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = ENgetnodeindex(varargin{1}{j});
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                [obj.errorCode, value] = ENgetnodeindex(varargin{1});
            end
        end
        
        %ENgetnodetype
        function value = getNodeType(obj)
            for i=1:obj.getCountNodes
                [obj.errorCode,obj.NodeTypeIndex(i)] = ENgetnodetype(i);
                value(i)=obj.TYPENODE(obj.NodeTypeIndex(i)+1);
            end
        end
        
        %ENgetnodevalue
        function value = getNodeElevation(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,0);
            end
        end
        function value = getNodeBaseDemand(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,1);
            end
        end
        function value = getNodeDemandPatternIndex(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,2);
            end
        end
        function value = getNodeEmitterCoeff(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,3);
            end
        end
        function value = getNodeInitialQuality(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,4);
            end
        end
        
        
        
        function value = getTankLevelInitial(obj)
            value=nan(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,8);
            end
        end
        
        function value = getNodeActualDemand(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,9);
            end
        end
        function value = getNodeActualDemandSensingNodes(obj,varargin)
            value=zeros(1,obj.getCountNodes);
            for i=1:length(varargin{1})
                [obj.errorCode, value(varargin{1}(i))] = ENgetnodevalue(varargin{1}(i),12);
            end
        end
        function value = getNodeHydaulicHead(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,10);
            end
        end
        function value = getNodePressure(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,11);
            end
        end
        function value = getNodeActualQuality(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,12);
            end
        end
        function value = getNodeMassFlowRate(obj) %Mass flow rate per minute of a chemical source
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.CountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,13);
            end
        end
        function value = getNodeActualQualitySensingNodes(obj,varargin)
            value=zeros(1,obj.getCountNodes);
            for i=1:length(varargin{1})
                [obj.errorCode, value(varargin{1}(i))] = ENgetnodevalue(varargin{1}(i),12);
            end
        end
        
        %ENgetoption
        function value = getOptionTrial(obj)
            [obj.errorCode, value] = ENgetoption(0);
        end
        function value = getOptionAccuracy(obj)
            [obj.errorCode, value] = ENgetoption(1);
        end
        function value = getOptionTolerance(obj)
            [obj.errorCode, value] = ENgetoption(2);
        end
        function value = getOptionEmitterExponent(obj)
            [obj.errorCode, value] = ENgetoption(3);
        end
        function value = getOptionDemandMult(obj)
            [obj.errorCode, value] = ENgetoption(4);
        end
        
        
        
        %ENgetpatternid
        function value = getPatternID(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountPatterns
                    [obj.errorCode, value{i}]=ENgetpatternid(i);
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, value{k}]=ENgetpatternid(i);
                    k=k+1;
                end
            end
        end
        
        %Pattern Index
        function value = getPatternIndexMsx(obj,varargin)
            if isempty(varargin)
                value=1:obj.CountPatterns;
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = ENgetpatternindex(varargin{1}{j});
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                [obj.errorCode, value] = ENgetpatternindex(varargin{1});
            end
        end
        
        %ENgetpatternlen
        function value = getPatternLength(obj,varargin)
            if isempty(varargin)
                tmpPatterns=1:obj.getCountPatterns;
                for i=tmpPatterns
                    [obj.errorCode, value(i)]=ENgetpatternlen(i);
                end
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = ENgetpatternlen(obj.getPatternIndex(varargin{1}{j}));
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                [obj.errorCode, value] = ENgetpatternlen(obj.getPatternIndex(varargin{1}));
            elseif isa(varargin{1},'numeric')
                k=1;
                for i=varargin{1}
                    [obj.errorCode, value(k)]=ENgetpatternlen(i);
                    k=k+1;
                end
            end
        end
        
        %ENgetpatternvalue
        function value = getPattern(obj) %Mass flow rate per minute of a chemical source
            tmpmaxlen=max(obj.getPatternLength);
            value=nan(obj.getCountPatterns,tmpmaxlen);
            for i=1:obj.getCountPatterns
                tmplength=obj.getPatternLength(i);
                for j=1:tmplength
                    [obj.errorCode, value(i,j)] = ENgetpatternvalue(i, j);
                end
                if tmplength<tmpmaxlen
                    for j=(tmplength+1):tmpmaxlen
                        value(i,j)=value(i,j-tmplength);
                    end
                end
                    
            end
        end
        
        %ENgetpatternvalue
        function value = getPatternValue(obj,patternIndex, patternStep) %Mass flow rate per minute of a chemical source
            [obj.errorCode, value] = ENgetpatternvalue(patternIndex, patternStep);
        end
        
        
        %ENgetqualtype
        function value = getQualityType(obj)
            [obj.errorCode, obj.QualityCode,obj.QualityTraceNodeIndex] = ENgetqualtype();
            value=obj.TYPEQUALITY(obj.QualityCode+1);
        end
        
        
        %ENgettimeparam
        function value = getTimeSimulationDuration(obj)
            [obj.errorCode, value] = ENgettimeparam(0);
        end
        function value = getTimeHydraulicStep(obj)
            [obj.errorCode, value] = ENgettimeparam(1);
        end
        function value = getTimeQualityStep(obj)
            [obj.errorCode, value] = ENgettimeparam(2);
        end
        function value = getTimePatternStep(obj)
            [obj.errorCode, value] = ENgettimeparam(3);
        end
        function value = getTimePatternStart(obj)
            [obj.errorCode, value] = ENgettimeparam(4);
        end
        function value = getTimeReportingStep(obj)
            [obj.errorCode, value] = ENgettimeparam(5);
        end
        function value = getTimeReportingStart(obj)
            [obj.errorCode, value] = ENgettimeparam(6);
        end
        function value = getTimeStatistics(obj)
            [obj.errorCode, obj.TimeStatisticsIndex] = ENgettimeparam(8);
            %tmpStats={'NONE','AVERAGE','MINIMUM','MAXIMUM', 'RANGE'};
            value=obj.TYPESTATS(obj.TimeStatisticsIndex+1);
        end
        function value = getTimeReportingPeriods(obj)
            [obj.errorCode, value] = ENgettimeparam(9);
        end
        
        
        
        %ENreport
        function getReport(obj)
            [obj.errorCode]=ENreport();
        end
        
        function value=getVersion(obj)
            [obj.errorCode, value] = ENgetversion();
        end
        
         function value=getComputedHydraulicTimeSeries(obj)
            obj.openHydraulicAnalysis;
            obj.initializeHydraulicAnalysis
            tstep=1; 
            totalsteps=obj.getTimeSimulationDuration/obj.getTimeHydraulicStep+1;
            initnodematrix=zeros(totalsteps, obj.getCountNodes);
            initlinkmatrix=zeros(totalsteps, obj.getCountLinks);
            value.Time=zeros(totalsteps,1); 
            value.Pressure=initnodematrix;
            value.Demand=initnodematrix; 
            value.Head=initnodematrix; 
            value.Flow=initlinkmatrix;
            value.Velocity=initlinkmatrix; 
            value.HeadLoss=initlinkmatrix; 
            value.Status=initlinkmatrix; 
            value.Setting=initlinkmatrix; 
            value.Energy=initlinkmatrix;
            k=1;
            while (tstep>0)
                t=obj.runHydraulicAnalysis;
                value.Time(k,:)=t; 
                value.Pressure(k,:)=obj.getNodePressure;
                value.Demand(k,:)=obj.getNodeActualDemand; 
                value.Head(k,:)=obj.getNodeHydaulicHead; 
                value.Flow(k,:)=obj.getLinkFlows;
                value.Velocity(k,:)=obj.getLinkVelocity; 
                value.HeadLoss(k,:)=obj.getLinkHeadloss; 
                value.Status(k,:)=obj.getLinkStatus; 
                value.Setting(k,:)=obj.getLinkSettings; 
                value.Energy(k,:)=obj.getLinkEnergy;   
                tstep = obj.nextHydraulicAnalysisStep;
                k=k+1;

            end
            obj.closeHydraulicAnalysis;
        end       
        
        
        
        function value=getComputedQualityTimeSeries(obj,varargin)
            obj.openQualityAnalysis
            obj.initializeQualityAnalysis
            tleft=1; 
            totalsteps=obj.getTimeSimulationDuration/obj.getTimeQualityStep;
            initnodematrix=zeros(totalsteps, obj.getCountNodes);
            if size(varargin,2)==0
                varargin={'time', 'quality', 'mass'};
            end
            if find(strcmpi(varargin,'time'))
                value.Time=zeros(totalsteps,1);
            end
            if find(strcmpi(varargin,'quality'))
                value.Quality=initnodematrix;
            end
            if find(strcmpi(varargin,'mass'))
                value.MassFlowRate=initnodematrix;
            end
            if find(strcmpi(varargin,'demand'))
                value.Demand=initnodematrix;
            end
            if find(strcmpi(varargin,'qualitySensingNodes'))
                value.Demand=initnodematrix;
            end
            k=1;
            while (tleft>0)
                t=obj.runQualityAnalysis;
                if find(strcmpi(varargin,'time'))
                    value.Time(k,:)=t;
                end
                if find(strcmpi(varargin,'quality'))
                    value.Quality(k,:)=obj.getNodeActualQuality;
                end
                if find(strcmpi(varargin,'mass'))
                    value.MassFlowRate(k,:)=obj.getNodeMassFlowRate;
                end
                if find(strcmpi(varargin,'demand'))
                    value.Demand(k,:)=obj.getNodeActualDemand;
                end
                if find(strcmpi(varargin,'qualitySensingNodes'))
                    value.Quality(k,:)=obj.getNodeActualQualitySensingNodes(varargin{2});
                end
                tleft = obj.stepQualityAnalysisTimeLeft;
                %tstep=obj.nextQualityAnalysisStep;
                k=k+1;
            end
            obj.closeQualityAnalysis;
        end
        
        
        %%%%%%%%%%%%%%%%% OPERATIONS %%%%%%%%%%%%%%%%%%%
        
        %ENclose & ENMatlabCleanup
        function unload(varargin)
            ENclose;
            ENMatlabCleanup;
        end
        
        
        %ENcloseH
        function closeHydraulicAnalysis(obj)
            [obj.errorCode] = ENcloseH();
        end
        
        %ENcloseQ
        function closeQualityAnalysis(obj)
            [obj.errorCode] = ENcloseQ();
        end
        
        
        
        %ENsavehydfile
        function saveHydraulicFile(obj,hydname)
            [obj.errorCode]=ENsavehydfile(hydname);
        end
        
        
        %ENusehydfile
        function useHydraulicFile(obj,hydname)
            [obj.errorCode]=ENusehydfile(hydname);
        end
        
        
        %ENinitH
        function initializeHydraulicAnalysis(obj)
            [obj.errorCode] = ENinitH(1);
        end
        
        %ENinitQ
        function initializeQualityAnalysis(obj)
            [obj.errorCode] = ENinitQ(1);
        end
        
        %ENnextH
        function tstep = nextHydraulicAnalysisStep(obj)
            [obj.errorCode, tstep] = ENnextH();
        end
        
        %ENnextQ
        function tstep = nextQualityAnalysisStep(obj)
            [obj.errorCode, tstep] = ENnextQ();
        end
        
        %ENopenH
        function openHydraulicAnalysis(obj)
            [obj.errorCode] = ENopenH();
        end
        
        %ENopenQ
        function openQualityAnalysis(obj)
            [obj.errorCode] = ENopenQ();
        end
        
        %ENrunH
        function tstep = runHydraulicAnalysis(obj)
            [obj.errorCode, tstep] = ENrunH();
        end
        
        %ENrunQ
        function tstep = runQualityAnalysis(obj)
            [obj.errorCode, tstep] = ENrunQ();
        end
        
        
        %ENsaveH
        function saveHydraulicsOutputReportingFile(obj)
            [obj.errorCode] = ENsaveH();
        end
        
        
        %ENstepQ
        function tleft=stepQualityAnalysisTimeLeft(obj)
            [obj.errorCode, tleft] = ENstepQ();
        end
        
        %ENsaveinpfile
        function saveInputFile(obj,inpname)
            [obj.errorCode] = ENsaveinpfile(inpname);
        end
        
        %ENwriteline
        function writeLineInReportFile(obj, line)
            [obj.errorCode] = ENwriteline (line);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function value = getNodeSourceQuality(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,5);
            end
        end
        function setNodeSourceQuality(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 5, value(i));
            end
        end
        function value = getNodeSourcePatternIndex(obj)
            value=zeros(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, value(i)] = ENgetnodevalue(i,6);
            end
        end
    end
    
end

function [errcode] = MSXclose()
    [errcode] = calllib('epanetmsx','MSXclose');
    if errcode 
        MSXerror(errcode); 
    end
end

function [e] = MSXerror(errcode)    
    e=0; len=80;
    errstring=char(32*ones(1,len+1));
    [e,errstring] = calllib('epanetmsx','MSXgeterror',errcode,errstring,len);
    disp(errstring);
end

function [errcode, count] = MSXgetcount(code)
    count=0;
    [errcode,count] = calllib('epanetmsx','MSXgetcount',code,count);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, index] = MSXgetindex(obj,varargin)
    index =0;
    [errcode,id,index]=calllib('epanetmsx','MSXgetindex',varargin{1},varargin{2},index);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, id] = MSXgetID(type,index,len)
    id=char(32*ones(1,len+1));
    [errcode,id]=calllib('epanetmsx','MSXgetID',type,index,id,len);
    id=id(1:len);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, len] = MSXgetIDlen(type,index)
    len=0;
    [errcode,len]=calllib('epanetmsx','MSXgetIDlen',type,index,len);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, type, units, atol, rtol] = MSXgetspecies(index)
    type=0; rtol=0; atol=0;
    units=char(32*ones(1,16));
    [errcode,type,units,atol,rtol]=calllib('epanetmsx','MSXgetspecies',index,type,units,atol,rtol);
    switch type   
    case 0
        type='BULK';   % for a bulk water species
    case 1
        type='WALL';   % for a pipe wall surface species
    end
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, value] = MSXgetconstant(index)
    value=0;
    [errcode,value]=calllib('epanetmsx','MSXgetconstant',index,value);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, value] = MSXgetparameter(obj,index,param)
    value=0;
    [errcode,value]=calllib('epanetmsx','MSXgetparameter',obj,index,param,value);
    if errcode 
        MSXerror(errcode);
    end
end

function [errcode, patlen] = MSXgetpatternlen(patindex)
    patlen=0;
    [errcode,patlen]=calllib('epanetmsx','MSXgetpatternlen',patindex,patlen);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, value] = MSXgetinitqual(obj,index,species)
    value=0;
    [errcode,value]=calllib('epanetmsx','MSXgetinitqual',obj,index,species,value);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, type, level, pat] = MSXgetsource(node,species)
    type=0;
    level=0;
    pat=0;
    [errcode,type,level,pat]=calllib('epanetmsx','MSXgetsource',node,species,type,level,pat);
    switch type     % type codes 
        case -1
            type='NOSOURCE';  % for no source
        case 0
            type='CONCEN';    % for a concentration source
        case 1
            type='MASS';      % for a mass booster source
        case 2
            type='SETPOINT';  % for a setpoint source
        case 3
            type='FLOWPACED'; % for a flow paced source  
    end     
    if errcode 
        MSXerror(errcode); 
    end
end

function ENMatlabCleanup(DLLname)
    global ENDLLNAME;
    if nargin == 1
        ENDLLNAME=DLLname;
    end;
    % Load library
    if libisloaded(ENDLLNAME)
        unloadlibrary(ENDLLNAME);
    else
        errstring =['Library ', ENDLLNAME, '.dll was not loaded'];
        disp(errstring);
    end;
end

function [] = MSXMatlabSetup(DLLname,Hname)
    if ~libisloaded(DLLname)
       loadlibrary(DLLname,Hname);
    end
end

function [errcode] = MSXopen(msxname)
    [errcode] = calllib('epanetmsx','MSXopen',msxname);
    if errcode 
        MSXerror(errcode); 
    end
    if (errcode == 520)
       disp('current MSX project will be closed and the new project will be opened');
       [errcode] = MSXclose(); 
       if errcode 
           MSXerror(errcode); 
       else 
           [errcode] = calllib('epanetmsx','MSXopen',msxname);
           if errcode 
               MSXerror(errcode); 
           end 
       end
    end
end

function [errcode] = ENsavehydfile(fname)
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENsavehydfile',fname);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsaveinpfile(inpname)
    global ENDLLNAME;
    errcode=calllib(ENDLLNAME,'ENsaveinpfile',inpname);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsetnodevalue(index, paramcode, value)
    global ENDLLNAME;
    index=int32(index);
    paramcode=int32(paramcode);
    value=single(value);
    [errcode]=calllib(ENDLLNAME,'ENsetnodevalue',index, paramcode, value);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = MSXsetpattern(index, factors, nfactors)
    [errcode]=calllib('epanetmsx','MSXsetpattern',index,factors,nfactors);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXsetpatternvalue(index, period, value)
    [errcode]=calllib('epanetmsx','MSXsetpatternvalue',pat,period,value);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXsolveQ()
    [errcode]=calllib('epanetmsx','MSXsolveQ');
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXsolveH()
    [errcode]=calllib('epanetmsx','MSXsolveH');
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXaddpattern(patid)
    [errcode]=calllib('epanetmsx','MSXaddpattern',patid);
    if errcode 
        MSXerror(errcode); 
    end
end


function [errcode] = ENusehydfile(hydfname)
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENusehydfile',hydfname);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, value] = ENgetpumptype(index)
    global ENDLLNAME;
    value=single(0);
    index=int32(index);
    [errcode, value]=calllib(ENDLLNAME,'ENgetpumptype',index, value);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, value] = ENgetheadcurve(index)
    global ENDLLNAME;
    value='';
    index=int32(index);
    [errcode, value]=calllib(ENDLLNAME,'ENgetheadcurve',index, value);
    if errcode 
        ENerror(errcode); 
    end
end


% function [errcode, nValues, xValues, yValues] = ENgetcurve(curveIndex)
%     global ENDLLNAME;    
%     xValues=single(0);
%     yValues=single(0);
%     nValues=int32(0);
%     [errcode, nValues, xValues, yValues] =	calllib(ENDLLNAME,'ENgetcurve', curveIndex, nValues, xValues, yValues);
% end


% ENplot 

function CoordinatesXY=ENplot(obj,varargin)

    % Initiality
    highlightnode=0;
    highlightlink=0;
    highlightnodeindex=[];
    highlightlinkindex=[];
    Node=char('no');
    Link=char('no');
    fontsize=10;margin=10;
    
    for i=1:(nargin/2)
        argument =lower(varargin{2*(i-1)+1});
        switch argument
            case 'nodes' % Nodes
                if ~strcmp(lower(varargin{2*i}),'yes') && ~strcmp(lower(varargin{2*i}),'no')
                    warning('EPANET:warning','Invalid argument.');
                    return
                end
                Node=varargin{2*i};
            case 'links' % Links
                if ~strcmp(lower(varargin{2*i}),'yes') && ~strcmp(lower(varargin{2*i}),'no')
                    warning('EPANET:warning','Invalid argument.');
                    return
                end
                Link=varargin{2*i};
            case 'highlightnode' % Highlight Node
                highlightnode=varargin{2*i};
            case 'highlightlink' % Highlight Link
                highlightlink=varargin{2*i};
            case 'fontsize' % font size
                margin=varargin{2*i};
                fontsize=char({['\fontsize{',num2str(margin),'}']});
            otherwise
                warning('EPANET:warning','Invalid property found.');
                return
        end
    end

    cla
    % Get node names and x, y coordiantes
    CoordinatesXY = Getnodeinfo(obj);

    if isa(highlightnode,'cell')       
        for i=1:length(highlightnode)
            n = strcmp(obj.getNodeID,highlightnode{i});
            if sum(n)==0
                warning('EPANET:warning','Undefined node with id "%s" in function call therefore the index is zero.', char(highlightnode{i})); 
            else
                highlightnodeindex(i) = strfind(n,1);
            end
        end
    end

    if isa(highlightlink,'cell') 
        for i=1:length(highlightlink)
            n = strcmp(obj.getLinkID,highlightlink{i});
            if sum(n)==0
                warning('EPANET:warning','Undefined link with id "%s" in function call therefore the index is zero.', char(highlightlink{i})); 
            else
                highlightlinkindex(i) = strfind(n,1);
            end
        end
    end

    % Coordinates for node FROM
    for i=1:obj.CountNodes
        [x] = double(CoordinatesXY(i,1));
        [y] = double(CoordinatesXY(i,2));

        hh=strfind(highlightnodeindex,i);
        h(:,1)=plot(x, y,'o','LineWidth',2,'MarkerEdgeColor','b',...
                      'MarkerFaceColor','b',...
                      'MarkerSize',5);
        legendString{1}= char('Junctions');

        % Plot Reservoirs
        if sum(strfind(obj.NodeReservoirIndex,i))
            colornode = 'g';
            if length(hh)
                colornode = 'r';
            end
            h(:,2)=plot(x,y,'s','LineWidth',2,'MarkerEdgeColor','r',...
                      'MarkerFaceColor','g',...
                      'MarkerSize',13);
            plot(x,y,'s','LineWidth',2,'MarkerEdgeColor','r',...
                      'MarkerFaceColor',colornode,...
                      'MarkerSize',13);
                  
           legendString{2} = char('Reservoirs');
        end
        % Plot Tanks
        if sum(strfind(obj.TankIndex,i)) 
            colornode = 'k';
            if length(hh)
                colornode = 'r';
            end
            h(:,3)=plot(x,y,'p','LineWidth',2,'MarkerEdgeColor','r',...
              'MarkerFaceColor','k',...
              'MarkerSize',16);
          
            plot(x,y,'p','LineWidth',2,'MarkerEdgeColor','r',...
                      'MarkerFaceColor',colornode,...
                      'MarkerSize',16);

            legendString{3} = char('Tanks');
        end

        % Show Node id
        if (strcmp(lower(Node),'yes') && ~length(hh))
            text(x,y,[fontsize,obj.getNodeID(i)])%'BackgroundColor',[.7 .9 .7],'Margin',margin/4);
        end

        if length(hh) 
            plot(x, y,'o','LineWidth',2,'MarkerEdgeColor','r',...
                      'MarkerFaceColor','r',...
                      'MarkerSize',10)

            text(x,y,['\fontsize{12}',obj.getNodeID(i)])%'BackgroundColor',[.7 .9 .7],'Margin',margin/4);
        end
        hold on
    end

    for i=1:obj.CountLinks
        
        if obj.NodesConnectingLinksIndex(:,1) 
            x1 = double(CoordinatesXY(obj.NodesConnectingLinksIndex(i,1),1));
            y1 = double(CoordinatesXY(obj.NodesConnectingLinksIndex(i,1),2));
        end

        if obj.NodesConnectingLinksIndex(:,2) 
            x2 = double(CoordinatesXY(obj.NodesConnectingLinksIndex(i,2),1));
            y2 = double(CoordinatesXY(obj.NodesConnectingLinksIndex(i,2),2));
        end
        
        hh=strfind(highlightlinkindex,i);

        h(:,4)=line([x1,x2],[y1,y2],'LineWidth',1);
        legendString{4} = char('Pipes');
        % Plot Pumps
        if sum(strfind(obj.LinkPumpIndex,i)) 
            colornode = 'b';
            if length(hh)
                colornode = 'r';
            end
            h(:,5)=plot((x1+x2)/2,(y1+y2)/2,'bv','LineWidth',2,'MarkerEdgeColor','b',...
                      'MarkerFaceColor','b',...
                      'MarkerSize',5);
            plot((x1+x2)/2,(y1+y2)/2,'bv','LineWidth',2,'MarkerEdgeColor',colornode,...
                      'MarkerFaceColor',colornode,...
                      'MarkerSize',5);
                  
           legendString{5} = char('Pumps');
        end

        % Plot Valves
        if sum(strfind(obj.ValveIndex,i)) 
            h(:,6)=plot((x1+x2)/2,(y1+y2)/2,'b*','LineWidth',2,'MarkerEdgeColor','b',...
                      'MarkerFaceColor','b',...
                      'MarkerSize',7);
            legendString{6} = char('Valves');
        end

        % Show Link id
        if (strcmp(lower(Link),'yes') && ~length(hh))
            text((x1+x2)/2,(y1+y2)/2,[fontsize,obj.getLinkID(i)],'BackgroundColor',[.7 .9 .7],'Margin',margin/2);
        end

        if length(hh) 
            line([x1,x2],[y1,y2],'LineWidth',2,'Color','g');
            text((x1+x2)/2,(y1+y2)/2,[fontsize,obj.getLinkID(i)],'BackgroundColor',[.7 .9 .7],'Margin',margin/2);
        end
        hold on
    end

    % Legend Plots
    u=1;
    for i=1:length(h)
        if h(i)~=0
            String{u} = legendString{i};
            hh(:,u) = h(i);
            u=u+1;
        end
    end

    legend(hh,String);
    % Axis OFF and se Background
    [yxmax,~]=max(CoordinatesXY);
    [yxmin,~]=min(CoordinatesXY);
    xmax=yxmax(1); ymax=yxmax(2);
    xmin=yxmin(1); ymin=yxmin(2);
    
    xlim([xmin-((xmax-xmin)*.1),xmax+((xmax-xmin)*.1)])
    ylim([ymin-(ymax-ymin)*.1,ymax+(ymax-ymin)*.1])
    axis off
    whitebg('w')
end


function CoordinatesXY = Getnodeinfo(obj)
    fid = fopen(obj.InputFile, 'r');
    breakS=0;t=1;ee=0;
    while ~feof(fid)
        tline = fgetl(fid);
        if tline==-1
            warning('EPANET:warning','Cannot find error.');
            CoordinatesXY(:)=0;
            return
        end
        a = regexp(tline, '\s*','split');
        for i=1:length(a) 
            rr = regexp(a,'\w*[\w*]\w*','split');
            check_brackets = rr{:};
            ch1 = strcmp(check_brackets,'[');
            ch2 = strcmp(check_brackets,']');

            if strcmp(char(a{i}),'[COORDINATES]')   
                breakS=1; 
            elseif ch1(1)==1 && ch2(2)==1 && breakS==1
                if (isempty(a{i})&& breakS==1) break; end
                ee=1;
            end
            if strcmp(a{i},'[END]') && breakS==0
                warning('EPANET:warning','No coordinates.');
                warning('EPANET:warning','Define temporary coordinate.');
                u=1;
                for t=1:obj.CountNodes
                    CoordinatesXY(t,1) = 100 + 10*rand(1,1);
                    CoordinatesXY(t,2) = 30 + 10*rand(1,1);
                    u=u+5;
                end
                return
            end
        end
        
        if breakS==1
            coord{t}=tline;
            t=t+1;
        end        
        if ee==1 
            break; 
        end
    end
    fclose(fid); 

    i=0;u=1;r=1;
    for t = 1:length(coord)
        c = coord{t};
        a = regexp(c, '\s*','split');
        y=1;
        while y < length(a)+1
            j(y) = isempty(a{y});
            y=y+1;
        end
        j = sum(j);
        if j == length(a)
            % skip
        elseif isempty(c)
            % skip
        elseif strfind(c,'[')
            % skip
        elseif strfind(c, ';')
            % skip 
        else
            i=i+1;
            if isempty(a{r})
                r=r+1;
            end
            CoordinatesXY(u,1) = str2double(a(r+1));
            CoordinatesXY(u,2) = str2double(a(r+2));
            u=u+1;
        end
    end
end



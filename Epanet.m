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

classdef Epanet <handle 
    % The EPANET class v.1.04
    properties %(Attributes)
        InputFile;
        PathFile;
        CountNodes;
        CountTanksReservoirs;
        CountLinks;
        CountPatterns;
        CountCurves;
        CountControls;
        CountReservoirs;
        CountJunctions;
        CountTanks;
        CountPipes;
        CountPumps;
        CountValves;
        ControlType;
        ControlLink;
        ControlSeetting;
        ControlNodeIndex;
        ControlTypeIndex;
        ControlLevel;
        ControlAll;
        CoordinatesXY;
        UnitsCode;
        UnitsType;
        LinkNameID;
        LinkIndex;
        LinkTypeIndex;
        LinkPipeNameID;
        LinkPipeIndex;
        LinkPumpNameID;
        LinkPumpIndex;
        LinkTypeID;
        LinkDiameter;
        LinkRoughness;
        LinkMinorLossCoef;
        LinkInitialStatus;
        LinkInitialSetting;
        LinkBulkReactionCoeff;
        LinkWallReactionCoeff;
        LinkLength;
        NodeNameID;
        NodeIndex;
        NodeTypeIndex;
        NodeJunctionNameID;
        NodeJunctionIndex;
        NodeReservoirNameID;
        NodeReservoirIndex;
        NodeTypeID;
        NodeElevations;
        NodeBaseDemands;
        NodeDemandPatternIndex;
        NodeEmitterCoeff;
        NodeInitialQuality;
        NodeSourceQuality;
        NodeSourcePatternIndex;
        NodeSourceTypeIndex;
        NodesConnectingLinksIndex;
        NodesConnectingLinksID;
        TankNameID;
        TankIndex;
        TankInitialLevel;
        TankInitialWaterVolume;
        TankMixingModelCode;
        TankMixZoneVolume;
        TankDiameter;
        TankMinimumWaterVolume;
        TankVolumeCurveIndex;
        TankMinimumWaterLevel;
        TankMaximumWaterLevel;
        TankMinimumFraction;
        TankBulkReactionCoeff;
        TankMixingModelType;
        OptionsTrials;
        OptionsAccuracy;
        OptionsTolerance;
        OptionsEmmiterExponent;
        OptionsDemandMult;
        PatternID;
        PatternIndex;
        PatternLengths;
        QualityCode;
        QualityType;
        QualityTraceNodeIndex;
        TimeSimulationDuration;
        TimeHydraulicStep;
        TimeQualityStep;
        TimePatternStep;
        TimePatternStart;
        TimeReportingStart;
        TimeReportingStep;
        TimeRuleControlStep;
        TimeStatisticsIndex;
        TimeStatisticsType;
        TimeReportingPeriods;
        Version;
        ValveNameID;
        ValveIndex;
        errorCode;
        TYPECONTROL={'LOWLEVEL','HILEVEL', 'TIMER', 'TIMEOFDAY'};
        TYPEUNITS={'CFS', 'GPM', 'MGD', 'IMGD', 'AFD', 'LPS', 'LPM', 'MLD', 'CMH', 'CMD'};
        TYPELINK={'CVPIPE', 'PIPE', 'PUMP', 'PRV', 'PSV', 'PBV', 'FCV', 'TCV', 'GPV', 'VALVE'};
        TYPENODE={'JUNCTION','RESERVOIR', 'TANK'};
        TYPEMIXMODEL={'MIX1','MIX2', 'FIFO','LIFO'};
        TYPEQUALITY={'NONE', 'CHEM', 'AGE', 'TRACE', 'MULTIS'};
        TYPESTATS={'NONE','AVERAGE','MINIMUM','MAXIMUM', 'RANGE'};
        TYPESOURCE={'CONCEN','MASS', 'SETPOINT', 'FLOWPACED'};
        TYPEREPORT={'YES','NO','FULL'};
        TYPEPUMP={'CONSTANT_HORSEPOWER', 'POWER_FUNCTION', 'CUSTOM'};
    end
    
    methods
        function obj =  Epanet(pathfile,varargin)
            if nargin==2
                inpfile=varargin{1};
                obj.PathFile=pathfile;
            elseif nargin==1
                inpfile=pathfile;
                obj.PathFile=which(pathfile);
            end
                
            
            %ENMatlabSetup  
            [obj.errorCode]=ENMatlabSetup('epanet2','epanet2.h');
            
            %ENopen  
            [obj.errorCode] = ENopen(obj.PathFile, strcat(inpfile,'.rpt'), strcat(inpfile,'.out'));
            obj.InputFile=inpfile;

            %ENgetcount  
            [obj.errorCode, obj.CountNodes] = ENgetcount(0);
            [obj.errorCode, obj.CountTanksReservoirs] = ENgetcount(1);
            [obj.errorCode, obj.CountLinks] = ENgetcount(2);
            [obj.errorCode, obj.CountPatterns] = ENgetcount(3);
            [obj.errorCode, obj.CountCurves] = ENgetcount(4);
            [obj.errorCode, obj.CountControls] = ENgetcount(5);
            tmpNodeTypes=obj.getNodeType;
            tmpLinkTypes=obj.getLinkType;
            
            obj.NodeReservoirIndex = find(strcmp(tmpNodeTypes,'RESERVOIR'));
            obj.TankIndex = find(strcmp(tmpNodeTypes,'TANK'));
            obj.NodeJunctionIndex = find(strcmp(tmpNodeTypes,'JUNCTION'));
            obj.LinkPipeIndex = find(strcmp(tmpLinkTypes,'PIPE'));
            obj.LinkPumpIndex = find(strcmp(tmpLinkTypes,'PUMP'));
            obj.ValveIndex = find(strcmp(tmpLinkTypes,'VALVE'));
            
            obj.CountReservoirs=sum(strcmp(tmpNodeTypes,'RESERVOIR'));
            obj.CountTanks=sum(strcmp(tmpNodeTypes,'TANK'));
            obj.CountJunctions=sum(strcmp(tmpNodeTypes,'JUNCTION'));
            obj.CountPipes=sum(strcmp(tmpLinkTypes,'PIPE'))+sum(strcmp(tmpLinkTypes,'CVPIPE'));
            obj.CountPumps=sum(strcmp(tmpLinkTypes,'PUMP'));
            obj.CountValves=obj.CountLinks - (obj.CountPipes + obj.CountPumps);
         
            
            %ENgetcontrol
            if obj.CountControls
                obj.ControlType{obj.CountControls}=[];
                obj.ControlTypeIndex(obj.CountControls)=NaN;
                obj.ControlLink(obj.CountControls)=NaN;
                obj.ControlSeetting(obj.CountControls)=NaN;
                obj.ControlNodeIndex(obj.CountControls)=NaN;
                obj.ControlLevel(obj.CountControls)=NaN;
            end
            %tmpControlType={'LOWLEVEL','HILEVEL', 'TIMER', 'TIMEOFDAY'};
            for i=1:obj.CountControls
                [obj.errorCode, obj.ControlTypeIndex(i),obj.ControlLink(i),obj.ControlSeetting(i),obj.ControlNodeIndex(i),obj.ControlLevel(i)] = ENgetcontrol(i);
                obj.ControlType(i)=obj.TYPECONTROL(obj.ControlTypeIndex(i)+1);
            end
            obj.ControlAll={obj.ControlType,obj.ControlTypeIndex,obj.ControlLink,obj.ControlSeetting,obj.ControlNodeIndex,obj.ControlLevel};
            
            %ENgetflowunits
            [obj.errorCode, obj.UnitsCode] = ENgetflowunits();
            %tmpUnits={'CFS', 'GPM', 'MGD', 'IMGD', 'AFD', 'LPS', 'LPM', 'MLD', 'CMH', 'CMD'};
            obj.UnitsType=obj.TYPEUNITS(obj.UnitsCode+1);
            
            
            %tmpLinkType={'CVPIPE', 'PIPE', 'PUMP', 'PRV', 'PSV', 'PBV', 'FCV', 'TCV', 'GPV'};
            obj.LinkTypeID={};
            obj.NodesConnectingLinksID={};
            for i=1:obj.CountLinks
                %ENgetlinkid
                [obj.errorCode, obj.LinkNameID{i}] = ENgetlinkid(i);
                %ENgetlinkindex
                [obj.errorCode, obj.LinkIndex(i)] = ENgetlinkindex(obj.LinkNameID{i});
                %ENgetlinknodes
                [obj.errorCode,linkFromNode,linkToNode] = ENgetlinknodes(i);
                obj.NodesConnectingLinksIndex(i,:)= [linkFromNode,linkToNode];
                obj.NodesConnectingLinksID(i,1) = obj.getLinkID(linkFromNode);
                obj.NodesConnectingLinksID(i,2) = obj.getLinkID(linkToNode);
                %ENgetlinktype
                [obj.errorCode,obj.LinkTypeIndex(i)] = ENgetlinktype(i);
                obj.LinkTypeID(i)=obj.TYPELINK(obj.LinkTypeIndex(i)+1);
                %ENgetlinkvalue
                [obj.errorCode, obj.LinkDiameter(i)] = ENgetlinkvalue(i,0);
                [obj.errorCode, obj.LinkLength(i)] = ENgetlinkvalue(i,1);
                [obj.errorCode, obj.LinkRoughness(i)] = ENgetlinkvalue(i,2);
                [obj.errorCode, obj.LinkMinorLossCoef(i)] = ENgetlinkvalue(i,3);
                [obj.errorCode, obj.LinkInitialStatus(i)] = ENgetlinkvalue(i,4);
                [obj.errorCode, obj.LinkInitialSetting(i)] = ENgetlinkvalue(i,5);
                [obj.errorCode, obj.LinkBulkReactionCoeff(i)] = ENgetlinkvalue(i,6);
                [obj.errorCode, obj.LinkWallReactionCoeff(i)] = ENgetlinkvalue(i,7);
            end
            
            %tmpNodeType={'JUNCTION','RESERVOIR', 'TANK'};
            %tmpSourceType={'CONCEN','MASS', 'SETPOINT', 'FLOWPACED'};
            obj.NodeTypeID={};
            for i=1:obj.CountNodes
                %ENgetnodeid
                [obj.errorCode, obj.NodeNameID{i}] = ENgetnodeid(i);
                %ENgetnodeindex
                [obj.errorCode, obj.NodeIndex(i)] = ENgetnodeindex(obj.NodeNameID{i});
                %ENgetnodetype
                [obj.errorCode, obj.NodeTypeIndex(i)] = ENgetnodetype(i);
                obj.NodeTypeID(i)=obj.TYPENODE(obj.NodeTypeIndex(i)+1);
                %ENgetnodevalue
                [obj.errorCode, obj.NodeElevations(i)] = ENgetnodevalue(i, 0);
                [obj.errorCode, obj.NodeBaseDemands(i)] = ENgetnodevalue(i, 1);
                [obj.errorCode, obj.NodeDemandPatternIndex(i)] = ENgetnodevalue(i, 2);
                [obj.errorCode, obj.NodeEmitterCoeff(i)] = ENgetnodevalue(i, 3);
                [obj.errorCode, obj.NodeInitialQuality(i)] = ENgetnodevalue(i, 4);
                [obj.errorCode, obj.NodeSourceQuality(i)] = ENgetnodevalue(i, 5);
                [obj.errorCode, obj.NodeSourcePatternIndex(i)] = ENgetnodevalue(i, 6);
                [obj.errorCode, obj.NodeSourceTypeIndex(i)] = ENgetnodevalue(i, 7);
            end
                        
            obj.NodeReservoirNameID=obj.NodeNameID(obj.NodeReservoirIndex);
            obj.TankNameID=obj.NodeNameID(obj.TankIndex);
            obj.NodeJunctionNameID=obj.NodeNameID(obj.NodeJunctionIndex);
            obj.LinkPipeNameID=obj.LinkNameID(obj.LinkPipeIndex);            
            obj.LinkPumpNameID=obj.LinkNameID(obj.LinkPumpIndex);            
            obj.ValveNameID=obj.LinkNameID(obj.ValveIndex);   
            
            
            %ENgetnodevalue (for Tanks)
            obj.TankInitialLevel=nan(1,obj.CountNodes);
            obj.TankInitialWaterVolume=nan(1,obj.CountNodes);
            obj.TankMixingModelCode=nan(1,obj.CountNodes);
            obj.TankMixZoneVolume=nan(1,obj.CountNodes);
            obj.TankDiameter=nan(1,obj.CountNodes);
            obj.TankMinimumWaterVolume=nan(1,obj.CountNodes);
            obj.TankVolumeCurveIndex=nan(1,obj.CountNodes);
            obj.TankMinimumWaterLevel=nan(1,obj.CountNodes);
            obj.TankMaximumWaterLevel=nan(1,obj.CountNodes);
            obj.TankMinimumFraction=nan(1,obj.CountNodes);
            obj.TankBulkReactionCoeff=nan(1,obj.CountNodes);
            tmpTanks=find(strcmpi(obj.NodeTypeID,'TANK')==1);
            %tmpMixModel={'MIX1','MIX2', 'FIFO','LIFO'};
            obj.TankMixingModelType={};
            for i=tmpTanks
                [obj.errorCode, obj.TankInitialLevel(i)] = ENgetnodevalue(i, 8);
                [obj.errorCode, obj.TankInitialWaterVolume(i)] = ENgetnodevalue(i, 14);
                [obj.errorCode, obj.TankMixingModelCode(i)] = ENgetnodevalue(i, 15);
                obj.TankMixingModelType(i)=obj.TYPEMIXMODEL(obj.TankMixingModelCode(i)+1);
                [obj.errorCode, obj.TankMixZoneVolume(i)] = ENgetnodevalue(i, 16);
                [obj.errorCode, obj.TankDiameter(i)] = ENgetnodevalue(i, 17);
                [obj.errorCode, obj.TankMinimumWaterVolume(i)] = ENgetnodevalue(i, 18);
                [obj.errorCode, obj.TankVolumeCurveIndex(i)] = ENgetnodevalue(i, 19);
                [obj.errorCode, obj.TankMinimumWaterLevel(i)] = ENgetnodevalue(i, 20);
                [obj.errorCode, obj.TankMaximumWaterLevel(i)] = ENgetnodevalue(i, 21);
                [obj.errorCode, obj.TankMinimumFraction(i)] = ENgetnodevalue(i, 22);
                [obj.errorCode, obj.TankBulkReactionCoeff(i)] = ENgetnodevalue(i, 23);
            end
            
            %ENgetoption
            [obj.errorCode, obj.OptionsTrials] = ENgetoption(0);
            [obj.errorCode, obj.OptionsAccuracy] = ENgetoption(1);
            [obj.errorCode, obj.OptionsTolerance] = ENgetoption(2);
            [obj.errorCode, obj.OptionsEmmiterExponent] = ENgetoption(3);
            [obj.errorCode, obj.OptionsDemandMult] = ENgetoption(4);
            
            
            obj.PatternID={};
            for i=1:obj.getCountPatterns
                %ENgetpatternid
                [obj.errorCode, obj.PatternID{i}] = ENgetpatternid(i);
                %ENgetpatterindex
                [obj.errorCode, obj.PatternIndex(i)] = ENgetpatternindex(obj.PatternID{i});
                %Engetpatternlen
                [obj.errorCode, obj.PatternLengths(i)] = ENgetpatternlen(i);
            end
            
            %ENgetqualtype
            %tmpQuality={'NONE', 'CHEM', 'AGE', 'TRACE', 'MULTIS'};
            [obj.errorCode, obj.QualityCode,obj.QualityTraceNodeIndex] = ENgetqualtype();
            obj.QualityType=obj.TYPEQUALITY(obj.QualityCode+1);
            
            %ENgettimeparam
            [obj.errorCode, obj.TimeSimulationDuration] = ENgettimeparam(0);
            [obj.errorCode, obj.TimeHydraulicStep] = ENgettimeparam(1);
            [obj.errorCode, obj.TimeQualityStep] = ENgettimeparam(2);
            [obj.errorCode, obj.TimePatternStep] = ENgettimeparam(3);
            [obj.errorCode, obj.TimePatternStart] = ENgettimeparam(4);
            [obj.errorCode, obj.TimeReportingStep] = ENgettimeparam(5);
            [obj.errorCode, obj.TimeReportingStart] = ENgettimeparam(6);
            [obj.errorCode, obj.TimeRuleControlStep] = ENgettimeparam(7);
            [obj.errorCode, obj.TimeStatisticsIndex] = ENgettimeparam(8);
            %tmpStats={'NONE','AVERAGE','MINIMUM','MAXIMUM', 'RANGE'};
            obj.TimeStatisticsType=obj.TYPESTATS(obj.TimeStatisticsIndex+1);
            [obj.errorCode, obj.TimeReportingPeriods] = ENgettimeparam(9);
            
            %ENgetVersion
            [obj.errorCode, obj.Version] = ENgetversion();
                                    
        end
        
        %%%%%%%%%%%%%%%%% ADD FUNCTIONS %%%%%%%%%%%%%%%%%
        %ENsolveH
        function solveCompleteHydraulics(obj)
            [obj.errorCode] = ENsolveH();
        end
        
        %ENsolveQ
        function solveCompleteQuality(obj)
            [obj.errorCode] = ENsolveQ();
        end
        
        
        %CONTROLS: EPANET cannot add new controls
        
        %%%%%%%%%%%%%%%%% ADD FUNCTIONS %%%%%%%%%%%%%%%%%
        
        %ENaddpattern
        function valueIndex = addPattern(obj,varargin)
            valueIndex=-1;
            if nargin==2
                [obj.errorCode] = ENaddpattern(varargin{1});
                valueIndex = getPatternIndex(obj,varargin{1});
            elseif nargin==3
                [obj.errorCode] = ENaddpattern(varargin{1});
                valueIndex = getPatternIndex(obj,varargin{1});
                setPattern(obj,valueIndex,varargin{2});
            end
        end
        
        
        %%%%%%%%%%%%%%%%% SET FUNCTIONS %%%%%%%%%%%%%%%%%
        
        
        %ENsetcontrol
        function setControl(obj,controlRuleIndex,controlTypeIndex,linkIndex,controlSettingValue,nodeIndex,controlLevel)
            % Example: d.setControl(1,1,13,1,11,150)
            % controlRuleIndex must exist
            if controlRuleIndex<=obj.getCountControls
                [obj.errorCode] = ENsetcontrol(controlRuleIndex,controlTypeIndex,linkIndex,controlSettingValue,nodeIndex,controlLevel);
                obj.ControlType={};
                for i=1:obj.getCountControls
                    [obj.errorCode, obj.ControlTypeIndex(i),obj.ControlLink(i),obj.ControlSeetting(i),obj.ControlNodeIndex(i),obj.ControlLevel(i)] = ENgetcontrol(i);
                    obj.ControlType(i)=obj.TYPECONTROL(obj.ControlTypeIndex(i)+1);
                end
                obj.ControlAll={obj.ControlType,obj.ControlTypeIndex,obj.ControlLink,obj.ControlSeetting,obj.ControlNodeIndex,obj.ControlLevel};
            else
                disp('New rules cannot be added in this version')
            end
        end
        
        %setLinkID --- not exist
        
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
        
        %ENsetpattern
        function setPattern(obj,index,patternVector)
            nfactors=length(patternVector);
            [obj.errorCode] = ENsetpattern(index, patternVector, nfactors);
        end
        function setPatternMatrix(obj,patternMatrix)
            nfactors=size(patternMatrix,2);
            for i=1:size(patternMatrix,1)
                [obj.errorCode] = ENsetpattern(i, patternMatrix(i,:), nfactors);
            end
        end
        %ENsetpatternvalue
        function setPatternValue(obj,index, patternTimeStep, patternFactor)
            [obj.errorCode] = ENsetpatternvalue(index, patternTimeStep, patternFactor);
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
        
        %ENgetpatternindex
        function value = getPatternIndex(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountPatterns;
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
        function setNodeSourcePatternIndex(obj, value)
            for i=1:length(value)
                [obj.errorCode] = ENsetnodevalue(i, 6, value(i));
            end
        end
        function value = getNodeSourceType(obj)
            %value=zeros(1,obj.getCountNodes);
            value=cell(1,obj.getCountNodes);
            for i=1:obj.getCountNodes
                [obj.errorCode, temp] = ENgetnodevalue(i,7);
                if ~isnan(temp)
                    value(i)=obj.TYPESOURCE(temp+1);
                end
            end
        end
        function setNodeSourceType(obj, index, value)
            value=find(strcmpi(obj.TYPESOURCE,value)==1)-1;
            [obj.errorCode] = ENsetnodevalue(index, 7, value);
        end
        function value = getTimeRuleControlStep(obj)
            [obj.errorCode, value] = ENgettimeparam(7);
        end
        function setTimeRuleControlStep(obj,value)
            [obj.errorCode] = ENsettimeparam(7,value);
            [obj.errorCode, obj.TimeRuleControlStep] = ENgettimeparam(7);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function value=getPumpType(obj)
            tmpLinkTypes=obj.getLinkType;
            indices=find(strcmp(tmpLinkTypes,'PUMP')==1);
            value=cell(1,length(tmpLinkTypes));
            for index=indices
                [obj.errorCode, v] = ENgetpumptype(index);
                value(index)=obj.TYPEPUMP(v+1);
            end
        end
        
        
        function value=getCurveID(obj)
            tmpLinkTypes=obj.getLinkType;
            indices=find(strcmp(tmpLinkTypes,'PUMP')==1);
            value=cell(1,length(tmpLinkTypes));
            for index=indices
                [obj.errorCode, value{index}] = ENgetheadcurve(index);
            end
        end
        
%         %% FOR FUTURE VERSIONS
%         function value=getCurves(obj)
%             tmpLinkTypes=obj.getLinkType;
%             indices=find(strcmp(tmpLinkTypes,'PUMP')==1);
%             value=cell(1,length(tmpLinkTypes));
%             for index=indices
%                 [errcode, nValues, xValues, yValues] = ENgetcurve(index);
%                 value(index)=[nValues, xValues, yValues];
%             end
%         end        
       
        % ENplot
        function plot(obj,varargin)    
            obj.CoordinatesXY=ENplot(obj,varargin{:});
        end
        
        function CoordinatesXY = getCoordinates(inpname)
            [errcode,vx,vy,vertx,verty]  = Getnodeinfo(inpname);
            CoordinatesXY{1} = vx;
            CoordinatesXY{2} = vy;
            CoordinatesXY{3} = vertx;
            CoordinatesXY{4} = verty;
        end
        
    end
    
end



function [errcode] = ENwriteline (line)
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENwriteline',line);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENaddpattern(patid)
    global ENDLLNAME;
    errcode=calllib(ENDLLNAME,'ENaddpattern',patid);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENclose()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENclose');
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENcloseH()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENcloseH');
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, value] = ENgetnodevalue(index, paramcode)
    global ENDLLNAME;
    value=single(0);
    index=int32(index);
    paramcode=int32(paramcode);
    [errcode, value]=calllib(ENDLLNAME,'ENgetnodevalue',index, paramcode, value);
    if errcode==240
        value=NaN;
    end
end

function [errcode] = ENcloseQ()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENcloseQ');
    if errcode 
        ENerror(errcode); 
    end
end



function [e] = ENerror(errcode)    
    global ENDLLNAME;
    errstring=char(32*ones(1,80));
    errcode=int32(errcode);
    len=int32(80);
    [e,errstring] = calllib(ENDLLNAME,'ENgeterror',errcode,errstring,len);
    disp(errstring);
end


function [errcode,from,to] = ENgetalllinknodes()
    global ENDLLNAME;
    global EN_SIZE;
    fval1=int32(0);
    fval2=int32(0);
    p1=libpointer('int32Ptr',fval1);
    p2=libpointer('int32Ptr',fval2);
    from=int32(zeros(EN_SIZE.nlinks,1));
    to=int32(zeros(EN_SIZE.nlinks,1));
    for i=1:EN_SIZE.nlinks
        [errcode]=calllib(ENDLLNAME,'ENgetlinknodes',i,p1,p2);
        if errcode 
            ENerror(errcode); 
        end
        from(i)=get(p1,'Value');
        to(i)=get(p2,'Value');
    end
end


function [errcode, ctype,lindex,setting,nindex,level] = ENgetcontrol(cindex)
    global ENDLLNAME;
    ctype=int32(0);
    lindex=int32(0);
    setting=single(0);
    nindex=int32(0);
    level=single(0);
    cindex=int32(cindex);
    pctype=libpointer('int32Ptr',ctype);
    plindex=libpointer('int32Ptr',lindex);
    psetting=libpointer('singlePtr',setting);
    pnindex=libpointer('int32Ptr',nindex);
    plevel=libpointer('singlePtr',level);
    [errcode]=calllib(ENDLLNAME,'ENgetcontrol',cindex,pctype,plindex,psetting,pnindex,plevel);
    if errcode 
        ENerror(errcode); 
    end
    ctype=get(pctype,'Value');
    lindex=get(plindex,'Value');
    setting=get(psetting,'Value');
    nindex=get(pnindex,'Value');
    level=get(plevel,'Value');
end

function [errcode, count] = ENgetcount(countcode)
    global ENDLLNAME;
    count=int32(0);
    pcount=libpointer('int32Ptr',count);
    countcode=int32(countcode);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',countcode,pcount);
    if errcode 
        ENerror(errcode); 
    end
    count=get(pcount,'Value');
end

function [e, errmsg] = ENgeterror(errcode)    
    global ENDLLNAME;
    errmsg = char(32*ones(1,80));
    len=int32(80);
    errcode=int32(errcode);
    [e,errmsg] = calllib(ENDLLNAME,'ENgeterror',errcode,errmsg,len);
    if e 
        ENerror(e); 
    end
end

function [errcode,unitscode] = ENgetflowunits()
    global ENDLLNAME;
    unitscode=int32(0);
    [errcode, unitscode]=calllib(ENDLLNAME,'ENgetflowunits',unitscode);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode,id] = ENgetlinkid(index)
    global ENDLLNAME;
    id=char(32*ones(1,17));
    index=int32(index);
    [errcode,id]=calllib(ENDLLNAME,'ENgetlinkid',index,id);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode,index] = ENgetlinkindex(id)
    global ENDLLNAME;
    index=int32(0);
    [errcode,~,index]=calllib(ENDLLNAME,'ENgetlinkindex',id,index);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode,from,to] = ENgetlinknodes(index)
    global ENDLLNAME;
    from=int32(0);
    to=int32(0);
    index=int32(index);
    [errcode,from,to]=calllib(ENDLLNAME,'ENgetlinknodes',index,from,to);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, type] = ENgetlinktype(index)
    global ENDLLNAME;
    type=int32(0);
    index=int32(index);
    [errcode,type]=calllib(ENDLLNAME,'ENgetlinktype',index,type);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode, value] = ENgetlinkvalue(index, paramcode)
    global ENDLLNAME;
    value=single(0);
    index=int32(index);
    paramcode=int32(paramcode);
    [errcode,value]=calllib(ENDLLNAME,'ENgetlinkvalue',index, paramcode, value);
    if errcode 
        ENerror(errcode); 
    end
end


function [nnodes,ntanks,nlinks,npats,ncurves,ncontrols,errcode] = ENgetnetsize()
    global ENDLLNAME;
    nnodes=int32(0);
    p=libpointer('int32Ptr',nnodes);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',0,p);
    if errcode 
        ENerror(errcode); 
    end
    nnodes=get(p,'Value');
    ntanks=int32(0);
    p=libpointer('int32Ptr',ntanks);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',1,p);
    if errcode 
        ENerror(errcode); 
    end
    ntanks=get(p,'Value');
    nlinks=int32(0);
    p=libpointer('int32Ptr',nlinks);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',2,p);
    if errcode 
        ENerror(errcode); 
    end
    nlinks=get(p,'Value');
    npats=int32(0);
    p=libpointer('int32Ptr',npats);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',3,p);
    if errcode 
        ENerror(errcode); 
    end
    npats=get(p,'Value');
    ncurves=int32(0);
    p=libpointer('int32Ptr',ncurves);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',4,p);
    if errcode 
        ENerror(errcode); 
    end
    ncurves=get(p,'Value');
    ncontrols=int32(0);
    p=libpointer('int32Ptr',ncontrols);
    [errcode]=calllib(ENDLLNAME,'ENgetcount',5,p);
    if errcode 
        ENerror(errcode); 
    end
    ncontrols=get(p,'Value');
end

function [errcode,id] = ENgetnodeid(index)
    global ENDLLNAME;
    id=char(32*ones(1,17));
    index=int32(index);
    [errcode,id]=calllib(ENDLLNAME,'ENgetnodeid',index,id);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode,index] = ENgetnodeindex(id)
    global ENDLLNAME;
    index=int32(0);
    [errcode, ~, index]=calllib(ENDLLNAME,'ENgetnodeindex',id,index);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, type] = ENgetnodetype(index)
    global ENDLLNAME;
    type=int32(0);
    p=libpointer('int32Ptr',type);
    index=int32(index);
    [errcode]=calllib(ENDLLNAME,'ENgetnodetype',index,p);
    if errcode 
        ENerror(errcode); 
    end
    type=get(p,'Value');
end


function [errcode, value] = ENgetoption(optioncode)
    global ENDLLNAME;
    value=single(0);
    pvalue=libpointer('singlePtr',value);
    optioncode=int32(optioncode);
    [errcode]=calllib(ENDLLNAME,'ENgetoption',optioncode,pvalue);
    if errcode 
        ENerror(errcode); 
    end
    value=get(pvalue,'Value');
end


function [errcode, id] = ENgetpatternid(index)
    global ENDLLNAME;
    id=char(32*ones(1,31));
    index=int32(index);
    [errcode,id]=calllib(ENDLLNAME,'ENgetpatternid',index,id);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, index] = ENgetpatternindex(id)
    global ENDLLNAME;
    index=int32(0);
    [errcode,~, index]=calllib(ENDLLNAME,'ENgetpatternindex',id,index);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, len] = ENgetpatternlen(index)
    global ENDLLNAME;
    index=int32(index);
    len=int32(0);
    [errcode,len]=calllib(ENDLLNAME,'ENgetpatternlen',index,len);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, value] = ENgetpatternvalue(index, period)
    global ENDLLNAME;
    value=single(0);
    p=libpointer('singlePtr',value);
    index=int32(index);
    period=int32(period);
    [errcode]=calllib(ENDLLNAME,'ENgetpatternvalue',index, period, p);
    if errcode 
        ENerror(errcode); 
    end
    value=get(p,'Value');
end


function [errcode,qualcode,tracenode] = ENgetqualtype()
    global ENDLLNAME;
    qualcode=int32(0);
    tracenode=int32(0);
    [errcode,qualcode,tracenode]=calllib(ENDLLNAME,'ENgetqualtype',qualcode,tracenode);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode, timevalue] = ENgettimeparam(paramcode)
    global ENDLLNAME;
    timevalue=int32(0);
    paramcode=int32(paramcode);
    [errcode,timevalue]=calllib(ENDLLNAME,'ENgettimeparam',paramcode,timevalue);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode, version] = ENgetversion()
    global ENDLLNAME;
    version=int32(0);
    [errcode,version]=calllib(ENDLLNAME,'ENgetversion',version);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENinitH(flag)
    global ENDLLNAME;
    flag=int32(flag);
    [errcode]=calllib(ENDLLNAME,'ENinitH',flag);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENinitQ(saveflag)
    global ENDLLNAME;
    saveflag=int32(saveflag);
    [errcode]=calllib(ENDLLNAME,'ENinitQ',saveflag);
    if errcode 
        ENerror(errcode); 
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

function [errcode] = ENMatlabSetup(DLLname,Hname)
    global ENDLLNAME;
    %currentversion = 20012;
    % Load library
    ENDLLNAME=DLLname;
    ENHNAME=Hname;
    if ~libisloaded(ENDLLNAME)
        loadlibrary(ENDLLNAME,ENHNAME);
    end
    % Check version of EPANET DLL
    [errcode, version] = ENgetversion();
    %if version ~= currentversion
    %    errcode = 1;
    versionString = ['Current version of EPANET:',num2str(version)];
    disp(versionString);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode, tstep] = ENnextH()
    global ENDLLNAME;
    tstep=int32(0);
    [errcode,tstep]=calllib(ENDLLNAME,'ENnextH',tstep);
    if errcode 
        ENerror(errcode); 
    end
end
function [errcode, tstep] = ENnextQ()
    global ENDLLNAME;
    tstep=int32(0);
    [errcode,tstep]=calllib(ENDLLNAME,'ENnextQ',tstep);
    if errcode 
        ENerror(errcode); 
    end
    tstep = double(tstep);
end

function [errcode] = ENopen(inpname,repname,binname)
    global ENDLLNAME;
%     global EN_SIZE;
    
    repname='';
    binname='';
    
    errcode=calllib(ENDLLNAME,'ENopen',inpname,repname,binname);
%     if errcode 
        while errcode~=0
            try
                errcode=calllib(ENDLLNAME,'ENopen',inpname,repname,binname);
            catch err
            end
        end
%         ENerror(errcode); 
%     end
%     [nnodes,ntanks,nlinks,npats,ncurves,ncontrols,errcode] = ENgetnetsize();
%     if errcode 
%         ENerror(errcode); 
%     end
%     delete(repname,binname);
%     EN_SIZE = struct(...
%         'nnodes', nnodes,...
%         'ntanks', ntanks,...
%         'nlinks', nlinks,...
%         'npats',  npats,...
%         'ncurves',ncurves,...
%         'ncontrols',ncontrols);
end



function [errcode] = ENopenH()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENopenH');
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENopenQ()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENopenQ');
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENreport()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENreport');
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode] = ENresetreport()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENresetreport');
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode, t] = ENrunH()
    global ENDLLNAME;
    t=int32(0);
    [errcode,t]=calllib(ENDLLNAME,'ENrunH',t);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode, t] = ENrunQ()
    global ENDLLNAME;
    t=int32(0);
    [errcode,t]=calllib(ENDLLNAME,'ENrunQ',t);
    if errcode 
        ENerror(errcode); 
    end
    t = double(t);
end

function [errcode] = ENsaveH()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENsaveH');
    if errcode 
        ENerror(errcode); 
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

function [errcode] = ENsetcontrol(cindex,ctype,lindex,setting,nindex,level)
    global ENDLLNAME;
    ctype=int32(ctype);
    lindex=int32(lindex);
    setting=single(setting);
    nindex=int32(nindex);
    level=single(level);
    [errcode]=calllib(ENDLLNAME,'ENsetcontrol',cindex,ctype,lindex,setting,nindex,level);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode] = ENsetlinkvalue(index, paramcode, value)
    global ENDLLNAME;
    index=int32(index);
    paramcode=int32(paramcode);
    value=single(value);
    [errcode]=calllib(ENDLLNAME,'ENsetlinkvalue',index, paramcode, value);
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

function [errcode] = ENsetoption(optioncode,value)
    global ENDLLNAME;
    optioncode=int32(optioncode);
    value=single(value);
    [errcode]=calllib(ENDLLNAME,'ENsetoption',optioncode,value);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsetpattern(index, factors, nfactors)
    global ENDLLNAME;
    index=int32(index);
    nfactors=int32(nfactors);
    p=libpointer('singlePtr',factors);
    [errcode]=calllib(ENDLLNAME,'ENsetpattern',index,p,nfactors);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsetpatternvalue(index, period, value)
    global ENDLLNAME;
    index=int32(index);
    period=int32(period);
    value=single(value);
    [errcode]=calllib(ENDLLNAME,'ENsetpatternvalue',index, period, value);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode] = ENsetqualtype(qualcode,chemname,chemunits,tracenode)
    global ENDLLNAME;
    qualcode=int32(qualcode);
    [errcode]=calllib(ENDLLNAME,'ENsetqualtype',qualcode,chemname,chemunits,tracenode);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsetreport(command)
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENsetreport',command);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsetstatusreport(statuslevel)
    global ENDLLNAME;
    statuslevel=int32(statuslevel);
    [errcode]=calllib(ENDLLNAME,'ENsetstatusreport',statuslevel);
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode] = ENsettimeparam(paramcode, timevalue)
    global ENDLLNAME;
    paramcode=int32(paramcode);
    timevalue=int32(timevalue);
    [errcode]=calllib(ENDLLNAME,'ENsettimeparam',paramcode,timevalue);
    if errcode 
        ENerror(errcode); 
    end
end


function [errcode] = ENsolveH()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENsolveH');
    if errcode 
        ENerror(errcode); 
    end
end



function [errcode] = ENsolveQ()
    global ENDLLNAME;
    [errcode]=calllib(ENDLLNAME,'ENsolveQ');
    if errcode 
        ENerror(errcode); 
    end
end

function [errcode, tleft] = ENstepQ()
    global ENDLLNAME;
    tleft=int32(0);
    [errcode,tleft]=calllib(ENDLLNAME,'ENstepQ',tleft);
    if errcode 
        ENerror(errcode); 
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
    CoordinatesXY = getCoordinates(obj);

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
        [x] = double(CoordinatesXY{1}(i));
        [y] = double(CoordinatesXY{2}(i));

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
            x1 = double(CoordinatesXY{1}(obj.NodesConnectingLinksIndex(i,1)));
            y1 = double(CoordinatesXY{2}(obj.NodesConnectingLinksIndex(i,1)));
        end

        if obj.NodesConnectingLinksIndex(:,2) 
            x2 = double(CoordinatesXY{1}(obj.NodesConnectingLinksIndex(i,2)));
            y2 = double(CoordinatesXY{2}(obj.NodesConnectingLinksIndex(i,2)));
        end
        
        hh=strfind(highlightlinkindex,i);

%         h(:,4)=line([x1,x2],[y1,y2],'LineWidth',1);
        h(:,4)=line([x1 CoordinatesXY{3}{i} x2],[y1 CoordinatesXY{4}{i} y2],'LineWidth',1);
        
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
    [xmax,~]=max(CoordinatesXY{1});
    [xmin,~]=min(CoordinatesXY{1});
    [ymax,~]=max(CoordinatesXY{2});
    [ymin,~]=min(CoordinatesXY{2});

%     xmax=yxmax(1); ymax=yxmax(2);
%     xmin=yxmin(1); ymin=yxmin(2);
    
    xlim([xmin-((xmax-xmin)*.1),xmax+((xmax-xmin)*.1)])
    ylim([ymin-(ymax-ymin)*.1,ymax+(ymax-ymin)*.1])
    axis off
    whitebg('w')
end


function [errcode,vx,vy,vertx,verty] = Getnodeinfo(obj)
    % Initialize 
    vx = NaN(obj.CountNodes,1);
    vy = NaN(obj.CountNodes,1);
    vertx = cell(obj.CountLinks,1);
    verty = cell(obj.CountLinks,1);
    nvert = zeros(obj.CountLinks,1);

    % Open epanet input file
    [fid,message]=open(obj.InputFile,'rt');
    if fid < 0
        disp(message)
        return
    end

    sect = 0;
    % Read each line from input file.
    while 1
        tline = fgetl(fid);
        if ~ischar(tline),   break,   end

        % Get first token in the line
        tok = strtok(tline);

        % Skip blank lines and comments
        if isempty(tok), continue, end
        if (tok(1) == ';'), continue, end

        % Check if at start of a new COOR or VERT section
        if (tok(1) == '[')
            % [COORDINATES] section
            if strcmpi(tok(1:5),'[COOR')
                sect = 1;
                continue;
            % [VERTICES] section
            elseif strcmpi(tok(1:5),'[VERT')
                sect = 2;
                continue;
            % [END]
            elseif strcmpi(tok(1:4),'[END')
                break;
            else
                sect = 0;
                continue;
            end
        end

        if sect == 0
            continue;

        % Coordinates
        elseif sect == 1
            A = textscan(tline,'%s %f %f');
            % get the node index
            [errcode,index] = ENgetnodeindex(char(A{1}));
            if errcode ~=0 
                return; 
            end
            vx(index) = A{2};
            vy(index) = A{3};

        % Vertices
        elseif sect == 2
            A = textscan(tline,'%s %f %f');
            [errcode,index] = ENgetlinkindex(char(A{1}));
            if errcode ~=0 
                return; 
            end
            nvert(index) = nvert(index) + 1;
            vertx{index}(nvert(index)) = A{2};
            verty{index}(nvert(index)) = A{3};
        end
    end
end



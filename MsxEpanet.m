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
        
        CountNodes;
        CountLinks;
        
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
        SpeciesIndexMsx;
        SpeciesTypeMsx;
        SpeciesUnitsMsx;
        SpeciesAtolMsx;
        SpeciesRtolMsx;

        NodeInitqualValueMsx;
        LinkInitqualValueMsx;
        
        SourceTypeMsx;
        SourceLevelMsx;
        SourceIDMsx;
        SourcePatternIndexMsx; 
        SourcePatternIDMsx;
        SourceSpeciesNameIDMsx;
    
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
            obj.CountNodes = B.CountNodes;
            obj.CountLinks = B.CountLinks;

            %MSXgetcount  
            [obj.errorCode, obj.CountSpeciesMsx] = MSXgetcount(3);
            [obj.errorCode, obj.CountConstantsMsx] = MSXgetcount(6);
            [obj.errorCode, obj.CountParametersMsx] = MSXgetcount(5);
            [obj.errorCode, obj.CountPatternsMsx] = MSXgetcount(7);
            
            obj.SpeciesIndexMsx=1:obj.CountSpeciesMsx;
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
            for i=1:obj.CountNodes
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
            for i=1:obj.CountNodes
                for j=1:obj.CountSpeciesMsx
                   [obj.errorCode, obj.NodeInitqualValueMsx{i}(j)] = MSXgetinitqual(0,i,j);   
                end
            end
            for i=1:obj.CountLinks
                for j=1:obj.CountSpeciesMsx
                   [obj.errorCode, obj.LinkInitqualValueMsx{i}(j)] = MSXgetinitqual(1,i,j);   
                end
            end

            %MSXgetsource
            for i=1:obj.CountNodes
                for j=1:obj.CountSpeciesMsx 
                   [obj.errorCode, obj.SourceTypeMsx{i}{j},obj.SourceLevelMsx{i}(j),obj.SourcePatternIndexMsx{i}(j)] = MSXgetsource(i,j);
                   [obj.errorCode, len] = MSXgetIDlen(7,j);
                   [obj.errorCode,obj.SourcePatternIDMsx{i}{j}] = MSXgetID(7,obj.SourcePatternIndexMsx{i}(j),len);
                   obj.SourceIDMsx{i}(j) = B.NodeNameID(i);
                   [obj.errorCode, len] = MSXgetIDlen(3,j);
                   [obj.errorCode,obj.SourceSpeciesNameIDMsx{i}{j}] = MSXgetID(3,j,len);
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
        function valueIndex = addPatternMsx(obj,varargin)
            valueIndex=-1;
            if nargin==2
                [obj.errorCode] = MSXaddpattern(varargin{1});
                [obj.errorCode, valueIndex] = MSXgetindex(obj,7,varargin{1}); 
            elseif nargin==3
                [obj.errorCode] = MSXaddpattern(varargin{1});
                [obj.errorCode, valueIndex] = MSXgetindex(obj,7,varargin{1}); 
                setPatternMsx(obj,valueIndex,varargin{2});
            end
        end
        
        %%%%%%%%%%%%%%%%% SET FUNCTIONS %%%%%%%%%%%%%%%%%
    
        %MSXsetconstant  	
        function setConstantValueMsx(obj, value)
            for i=1:length(value)
                [obj.errorCode] = MSXsetconstant(i, value(i));
            end
        end
        
        %MSXsetpattern
        function setPatternMsx(obj,index,patternVector)
            nfactors=length(patternVector);
            [obj.errorCode] = MSXsetpattern(index, patternVector, nfactors);
        end
        function setPatternMatrixMsx(obj,patternMatrix)
            nfactors=size(patternMatrix,2);
            for i=1:size(patternMatrix,1)
                [obj.errorCode] = MSXsetpattern(i, patternMatrix(i,:), nfactors);
            end
        end
        %MSXsetpatternvalue
        function setPatternValueMsx(obj,index, patternTimeStep, patternFactor)
            [obj.errorCode] = MSXsetpatternvalue(index, patternTimeStep, patternFactor);
        end
     
        %%%%%%%%%%%%%%%%% GET FUNCTIONS %%%%%%%%%%%%%%%%%
        
        %MSXgetconstant
        function value = getConstantValueMsx(obj)
            for i=1:obj.getCountConstantsMsx
                [obj.errorCode, len] = MSXgetIDlen(6,i);
                [obj.errorCode, obj.ConstantNameIDMsx{i}] = MSXgetID(6,i,len);
                [obj.errorCode, value(i)] = MSXgetconstant(i);
            end
        end
            
        %MSXgetcount
        function value  =  getCountSpeciesMsx(obj)
            % Species, Constants, Parameters, Patterns 
            [obj.errorCode, value] = MSXgetcount(3);
        end
        function value  =  getCountConstantsMsx(obj)
            [obj.errorCode, value] = MSXgetcount(6);
        end
        function value  =  getCountParametersMsx(obj)
            [obj.errorCode, value] = MSXgetcount(5);
        end
        function value  =  getCountPatternsMsx(obj)
            [obj.errorCode, value] = MSXgetcount(7);
        end        
        
        %MSXgeterror
        function value = getErrorMsx(obj,errcode)
            [obj.errorCode, value] = MSXgeterror(errcode);
        end
               
        %Species ID
        function value = getSpeciesIDMsx(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountSpeciesMsx
                    [obj.errorCode, len] = MSXgetIDlen(3,i);
                    [obj.errorCode, value{i}]=MSXgetID(3,i,len);
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, len] = MSXgetIDlen(3,i);
                    [obj.errorCode, value{k}]=MSXgetID(3,i,len);
                    k=k+1;
                end
            end
        end
        
        %Constants ID
        function value = getConstantsIDMsx(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountConstantsMsx
                    [obj.errorCode, len] = MSXgetIDlen(6,i);
                    [obj.errorCode, value{i}]=MSXgetID(6,i,len);
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, len] = MSXgetIDlen(6,i);
                    [obj.errorCode, value{k}]=MSXgetID(6,i,len);
                    k=k+1;
                end
            end
        end
        
        %Parameters ID
        function value = getParametersIDMsx(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountParametersMsx
                    [obj.errorCode, len] = MSXgetIDlen(5,i);
                    [obj.errorCode, value{i}]=MSXgetID(5,i,len);
                end
                if ~obj.getCountParametersMsx
                    value=0;
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, len] = MSXgetIDlen(5,i);
                    [obj.errorCode, value{k}]=MSXgetID(5,i,len);
                    k=k+1;
                end
            end
        end
        
        %Patterns ID
        function value = getPatternsIDMsx(obj,varargin)
            if isempty(varargin)
                for i=1:obj.getCountPatternsMsx
                    [obj.errorCode, len] = MSXgetIDlen(7,i);
                    [obj.errorCode, value{i}]=MSXgetID(7,i,len);
                end
                if ~obj.getCountPatternsMsx
                    value=0;
                end
            else
                k=1;
                for i=varargin{1}
                    [obj.errorCode, len] = MSXgetIDlen(7,i);
                    [obj.errorCode, value{k}]=MSXgetID(7,i,len);
                    k=k+1;
                end
            end
        end
        
        %Species Index
        function value = getSpeciesIndexMsx(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountSpeciesMsx;
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = MSXgetindex(3,varargin{1}{j});
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                   [obj.errorCode, value] = MSXgetindex(3,varargin{1});
            end
        end
        
        %Constant Index
        function value = getConstantsIndexMsx(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountConstantsMsx;
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = MSXgetindex(6,varargin{1}{j});
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                   [obj.errorCode, value] = MSXgetindex(6,varargin{1});
            end
        end
        
        %Parameter Index
        function value = getParametersIndexMsx(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountParametersMsx;
                if ~length(value)
                    value=0;
                end
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = MSXgetindex(5,varargin{1}{j});
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                   [obj.errorCode, value] = MSXgetindex(5,varargin{1});
            end
        end
        
        %Pattern Index
        function value = getPatternIndexMsx(obj,varargin)
            if isempty(varargin)
                value=1:obj.getCountPatternsMsx;
                if ~length(value)
                    value=0;
                end
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, len] = MSXgetIDlen(7,j);
                    [obj.errorCode, value{k}] = MSXgetID(7, obj.PatternIndexMsx,len);
                    if obj.errorCode
                        value{k}=0;
                    end
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                [obj.errorCode, obj.PatternIndexMsx] = MSXgetindex(obj,7,varargin{1});
                [obj.errorCode, len] = MSXgetIDlen(7,obj.PatternIndexMsx);
                [obj.errorCode, value] = MSXgetID(7, obj.PatternIndexMsx,len);
                if obj.errorCode
                    value=0;
                end
            end
        end
        
        %MSXgetpatternlen
        function value = getPatternLengthMsx(obj,varargin)
            if isempty(varargin)
                tmpPatterns=1:obj.getCountPatternsMsx;
                if length(tmpPatterns)==0
                    value=0;
                end
                for i=tmpPatterns
                    [obj.errorCode, value(i)]=MSXgetpatternlen(i);
                end
            elseif isa(varargin{1},'cell')
                k=1;
                for j=1:length(varargin{1})
                    [obj.errorCode, value(k)] = MSXgetpatternlen(obj.getPatternIndexMsx(varargin{1}{j}));
                    k=k+1;
                end
            elseif isa(varargin{1},'char')
                [obj.errorCode, value] = MSXgetpatternlen(obj.getPatternIndexMsx(varargin{1}));
            elseif isa(varargin{1},'numeric')
                k=1;
                for i=varargin{1}
                    [obj.errorCode, value(k)]=MSXgetpatternlen(i);
                    k=k+1;
                end
            end
        end
        
        %MSXgetpatternvalue
        function value = getPatternMsx(obj) %Mass flow rate per minute of a chemical source
            tmpmaxlen=max(obj.getPatternLengthMsx);
            value=nan(obj.getCountPatternsMsx,tmpmaxlen);
            for i=1:obj.getCountPatternsMsx
                tmplength=obj.getPatternLengthMsx(i);
                for j=1:tmplength
                    [obj.errorCode, value(i,j)] = MSXgetpatternvalue(i, j);
                end
                if tmplength<tmpmaxlen
                    for j=(tmplength+1):tmpmaxlen
                        value(i,j)=value(i,j-tmplength);
                    end
                end
                    
            end
        end
        
        %MSXgetpatternvalue
        function value = getPatternValueMsx(obj,patternIndex, patternStep) %Mass flow rate per minute of a chemical source
            [obj.errorCode, value] = MSXgetpatternvalue(patternIndex, patternStep);
        end
        
        %MSXreport
        function getReportMsx(obj)
            [obj.errorCode]=MSXreport();
        end
               
        function value=getComputedQualityNodeMsx(obj)
            for i=1:obj.CountNodes
                % Obtain a hydraulic solution
                obj.solveCompleteHydraulicsMsx();
                % Run a step-wise water quality analysis
                % without saving results to file
                obj.initializeQualityAnalysisMsx(0);

                [t, tleft]=obj.stepQualityAnalysisTimeLeftMsx();

                % Retrieve species concentration at node
                k=1;
                while(tleft>0 && obj.errorCode==0)
                    [t, tleft]=obj.stepQualityAnalysisTimeLeftMsx();
                    value.Time(k,:)=t;
                    for j=1:obj.getCountSpeciesMsx
                        value.Quality{i}(k,:)=obj.getSpeciesConcentration(0, i, j);%node code0
                    end
                    k=k+1;
                end
            end
        end
        
        function value=getComputedQualityLinkMsx(obj)
            for i=1:obj.CountLinks
                % Obtain a hydraulic solution
                obj.solveCompleteHydraulicsMsx();
                % Run a step-wise water quality analysis
                % without saving results to file
                obj.initializeQualityAnalysisMsx(0);

                [t, tleft]=obj.stepQualityAnalysisTimeLeftMsx();

                % Retrieve species concentration at node
                k=1;
                while(tleft>0 && obj.errorCode==0)
                    [t, tleft]=obj.stepQualityAnalysisTimeLeftMsx();
                    value.Time(k,:)=t;
                    for j=1:obj.getCountSpeciesMsx
                        value.Quality{i}(k,:)=obj.getSpeciesConcentration(1, i, j);%node code0
                    end
                    k=k+1;
                end
            end
        end
        
        %%%%%%%%%%%%%%%%% OPERATIONS %%%%%%%%%%%%%%%%%%%
        
        %MSXclose & MSXMatlabCleanup
        function unloadMsx(varargin)
            MSXclose;
            MSXMatlabCleanup;
        end
        
        %MSXsaveoutfile
        function saveQualityFileMsx(obj,outfname)
            [obj.errorCode]=MSXsaveoutfile(outfname);
        end
        
        
        %MSXusehydfile
        function useHydraulicFileMsx(obj,hydname)
            [obj.errorCode]=MSXusehydfile(hydname);
        end
        
        %MSXinit 
        function initializeQualityAnalysisMsx(obj,flag)
            [obj.errorCode] = MSXinit(flag);
        end
        
        %MSXstep
        function [t, tleft]=stepQualityAnalysisTimeLeftMsx(obj)
            [obj.errorCode, t, tleft] = MSXstep();
        end
        
        %MSXgetqual
        function value=getSpeciesConcentration(obj, type, index, species)
            [obj.errorCode, value] = MSXgetqual(type, index, species);
        end
        
        %MSXsavemsxfile
        function saveMsxFile(obj,msxname)
            [obj.errorCode] = MSXsavemsxfile(msxname);
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

function [errcode, value] = MSXgetpatternvalue(patindex,period)
    value=0;
    [errcode,value]=calllib('epanetmsx','MSXgetpatternvalue',patindex,period,value);
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

function MSXMatlabCleanup()
    % Unload library
    if libisloaded('epanetmsx')
        unloadlibrary('epanetmsx');
    else
        errstring =['Library ', 'epanetmsx', '.dll was not loaded'];
        disp(errstring);
    end;
end

function MSXMatlabSetup(DLLname,Hname)
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

function [errcode] = MSXsaveoutfile(outfname)
    [errcode] = calllib('epanetmsx','MSXsaveoutfile',outfname);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXsavemsxfile(msxname)
    [errcode] = calllib('epanetmsx','MSXsavemsxfile',msxname);
    if errcode 
        MSXerror(errcode);
    end
end

function [errcode] = MSXsetconstant(index, value)
    [errcode]=calllib('epanetmsx','MSXsetconstant',index,value);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXsetpattern(index, factors, nfactors)
    [errcode]=calllib('epanetmsx','MSXsetpattern',index,factors,nfactors);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXsetpatternvalue(pat, period, value)
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


function [errcode] = MSXusehydfile(hydfname)
    [errcode]=calllib('epanetmsx','MSXusehydfile',hydfname);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode, t, tleft] = MSXstep()
    t=0;
    tleft=0;
    [errcode,t,tleft]=calllib('epanetmsx','MSXstep',t,tleft);
    if errcode 
        MSXerror(errcode); 
    end
end

function [errcode] = MSXinit(flag)
    [errcode]=calllib('epanetmsx','MSXinit',flag);
    if errcode 
        MSXerror(errcode); 
    end
end


function [errcode] = MSXreport()
    [errcode] = calllib('epanetmsx','MSXreport');
    if errcode 
        MSXerror(errcode); 
    end
end

function [e, errmsg] = MSXgeterror(errcode)    
    errmsg = char(32*ones(1,80));
    len=80;
    [e,errmsg] = calllib('epanetmsx','MSXgeterror',errcode,errmsg,len);
    if e 
        MSXerror(e); 
    end
end

function [errcode, value] = MSXgetqual(type, index, species)
    value=0;
    [errcode,value]=calllib('epanetmsx','MSXgetqual',type,index,species,value);
    if errcode 
        MSXerror(errcode); 
    end
end

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

function EvolutionaryOptimization(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isstruct(varargin{1}) 
        file0=varargin{1}.file0;
        PopulationSize_Data=varargin{1}.pp.PopulationSize_Data;
        ParetoFraction_Data=varargin{1}.pp.ParetoFraction_Data;
        Generations_Data=varargin{1}.pp.Generations_Data;
        numberOfSensors=str2num(varargin{1}.pp.numberOfSensors);
        load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');
    else
        file0=varargin{1};
        PopulationSize_Data=1000;
        ParetoFraction_Data=0.7;
        Generations_Data=100;
        numberOfSensors=1:5;
        pathname=[pwd,'\RESULTS\'];
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([pathname,file0,'.0'],'-mat');
    load([pathname,file0,'.w'],'-mat');
    
    if exist('gamultiobj','file')==2
        Y.x=[];
        Y.F=[];u=1;
        W{1}=W{1}(:,find(P.SensingNodeIndices));
        for i=numberOfSensors
            %[x,fval,exitflag,output,population,score]=multiObjectiveOptimization(W,length(numberOfSensors),PopulationSize_Data,ParetoFraction_Data,Generations_Data);
            [x,fval,exitflag,output,population,score]=multiObjectiveOptimization(...
                W,i,PopulationSize_Data,ParetoFraction_Data,Generations_Data);
            [xIdx tmp]=unique(sort(round(x),2),'rows');
            fval=fval(tmp,:);
            
            a=find(P.SensingNodeIndices);
            Y.xIndex{u}=a(xIdx);

%             Y.xIndex{u}=xIdx;
            for j=1:size(xIdx,1)
                zer=logical(zeros(1,B.NodeCount));
                zer(xIdx(j,:))=1;
                Y.x(size(Y.x,1)+1,:)=zer;
                Y.F(size(Y.F,1)+1,:)=[i,fval(j,:)];
            end
            u=u+1;
        end
        save([pathname,file0,'.y1'],'Y', '-mat');
    else
        disp('GAMULTIOBJ is not currenty installed in MATLAB')
    end
    
end


function [x,fval,exitflag,output,population,score] = multiObjectiveOptimization(W,nvars,PopulationSize_Data,ParetoFraction_Data,Generations_Data)
    % This is an auto generated M-file from Optimization Tool.
    % Start with the default options
    options = gaoptimset;
    % Modify options setting
    %options = gaoptimset(options,'PopulationType', 'bitstring');
    options = gaoptimset(options,'PopulationSize', PopulationSize_Data);
    options = gaoptimset(options,'ParetoFraction', ParetoFraction_Data);
    options = gaoptimset(options,'Generations', Generations_Data);
    options = gaoptimset(options,'CreationFcn', @gacreationuniform);
    options = gaoptimset(options,'CrossoverFcn', @crossoverscattered);
    options = gaoptimset(options,'MutationFcn', @mutationadaptfeasible);
    options = gaoptimset(options,'Display', 'iter');
    options = gaoptimset(options,'PlotFcns', { @gaplotpareto });
    options = gaoptimset(options,'OutputFcns', { [] });
    lb=ones(1,nvars);
    ub=size(W{1},2).*ones(1,nvars);
    [x,fval,exitflag,output,population,score] = ...
    gamultiobj(@(x)multiobjectiveFunctions(x,W),nvars,[],[],[],[],lb,ub,options);
end

function f = multiobjectiveFunctions(x,W)
    x=(round(x));
    if sum(x)~=0
        f(1)=mean(min(W{1}(:,x),[],2));
        f(2)=max(min(W{1}(:,x),[],2));
    else
        f=[inf inf];
    end
end
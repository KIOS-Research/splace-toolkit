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

function ExhaustiveOptimization(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isstruct(varargin{1}) 
        file0=varargin{1}.file0;
        numberOfSensors=str2num(varargin{1}.pp.numberOfSensors);
        load([pwd,'\RESULTS\','pathname.File'],'pathname','-mat');
    else
        file0=varargin{1};
        numberOfSensors=varargin{2};%         numberOfSensors=1:5;
%         B=varargin{3};%         numberOfSensors=1:5;
%         P=varargin{4};%         numberOfSensors=1:5;
        pathname=[pwd,'\RESULTS\'];
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([pathname,file0,'.0'],'-mat');
    load([pathname,file0,'.w'],'-mat');
    
    disp('Solve Sensor Placement')

    F1=[];
    F2=[];
    k=1;
    Y.x=[];
    Y.F=[];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isstruct(varargin{1}) 
        progressbar('Solve with exhaustive method..')
        for j=numberOfSensors
            total(j) = nchoosek(length(1:B.NodeCount),j);
        end
        total=sum(total);pp=1;
    end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j=numberOfSensors
        numberCombinations=nchoosek(length(1:B.NodeCount),j);
        population=combnk(find(P.SensingNodeIndices),j);
        score=inf*ones(size(population,1),2); 
        for i=1:size(population,1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if isstruct(varargin{1}) 
                if mod(pp,100)==1
                    nload=pp/total;
                    progressbar(nload);
                end
                pp=pp+1;
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            score(i,:) = multiobjectiveFunctions(population(i,:),W);
        end
        PS{j}=paretofront(score);

        %mean2=0;
        %max2=0;
        %numberCombinations = nchoosek(length(1:B.NodeCount),j);
        %X=combnk(1:B.NodeCount,j);
        %tic
        %for i=1:size(X,1)
            % THIS TAKES SOME TIME TO CALCULATE for each scenario
       %     mean2(i)=mean(min(W{1}(:,X(i,:)),[],2));
       %     max2(i)=max(min(W{1}(:,X(i,:)),[],2));
       % end
       % y=[mean2; max2]';
       % PS{j}=paretofront(y);
       % toc;
        %because the pareto front does not return solutions with
        %the same values
        tmp=find(PS{j}==1);
        for l=1:length(tmp)
            for ll=2:size(population,1)
                if sum((score(tmp(l),:)-score(ll,:)).^2)<10^-20
                    PS{j}(ll)=1;
                end
            end
        end
        sols=find(PS{j}==1);
        Y.xIndex{k}=population(sols,:);
        for i=1:size(Y.xIndex{k},1)
            x=logical(zeros(1,B.NodeCount));
            x(Y.xIndex{k}(i,:))=1;
            Y.x=[Y.x; x];
        end
        y=[j*ones(size(score,1),1) score];
        Y.F=[Y.F; y(sols,:)];
        k=k+1;
    end
    save([pathname,file0,'.y0'],'Y', '-mat');
    progressbar(1);

    %%%%%%%%%%%%%%%%
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
   
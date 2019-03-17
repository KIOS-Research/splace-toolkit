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

%% S-PLACE
function Y=TestSplace
    addpath(genpath(pwd));
    clear
    clc
    file0='file0'; % in gidmethod
    B=epanet('Net1_Rossman2000.inp');
    P=gridmethod(B);
    runMultipleScenarios(file0, 1); %file0 name & 1=use binary or 0=without binary
    ComputeImpactMatrices(file0);
    
    numberofSensors=3;
    ExhaustiveOptimization(file0,numberofSensors); %EvolutionaryOptimization
    load('file0.y0','-mat');
    
    B.unload
end

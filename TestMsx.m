%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; clear class;

% EXAMPLE 1
B = Epanet('example.inp');
C = MsxEpanet(B,'example.msx');

% EXAMPLE 2
% B = Epanet('Net2_Rossman2000.inp');
% C = MsxEpanet(B,'Net2_Rossman2000.msx');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      
                           
% Hydraulic analysis
C.getCountSpeciesMsx     
C.getCountConstantsMsx            
C.getCountParametersMsx           
C.getCountPatternsMsx 

C.solveCompleteHydraulicsMsx;
C.useHydraulicFileMsx('test.hyd');
C.solveCompleteQualityMsx;
C.saveQualityFileMsx('test.bin');

% Patterns
C.addPatternMsx('testpat',[2 .3 .4 6 5 2 4]);
C.getPatternLengthMsx
C.getPatternIndexMsx
C.getPatternsIDMsx                 

C.setPatternMatrixMsx([.1 .2 .5 .2 1 .9]);
C.getPatternMsx 

C.setPatternValueMsx(1,1,2);
C.getPatternMsx 

C.setPatternMsx(1,[1 0.5 0.8 2 1.5]);
C.getPatternMsx 
C.getPatternValueMsx(1,5)%1.5

% Sources
% SourceTypeMsx,SourceLevelMsx,SourcePatternIndexMsx,SourceNodeIDMsx
v=C.getSourcesMsx
node = 1;
spec=1;
type = 0;
level=0.2;
pat = 1;
C.setSourceMsx(node, spec, type, level, pat)
v=C.getSourcesMsx

% Species
C.getSpeciesIndexMsx
C.getSpeciesIDMsx
% C.getSpeciesConcentration(type, index, species)
C.getSpeciesConcentration(0,1,1)

% Constants
C.getConstantValueMsx     
value = [2 10 8];%index[1 2 3]
C.setConstantValueMsx(value);
C.getConstantValueMsx     
C.getConstantsIDMsx                                         
C.getConstantsIndexMsx 

% Parameters
C.getParametersIDMsx              
C.getParametersIndexMsx 

C.getParameterPipeValueMsx        
C.getParameterTankValueMsx        

% C.setParameterPipeValueMsx(pipeIndex,value) 
C.setParameterPipeValueMsx(1,[1.5 2]) 
C.getParameterPipeValueMsx{1}        

C.TankIndex
C.setParameterTankValueMsx(C.TankIndex(1),100)  
C.getParameterTankValueMsx{C.TankIndex(1)}       

% Initial Quality
C.getInitqualLinkValueMsx         
C.getInitqualNodeValueMsx   
C.setInitqualLinkValueMsx(1,1000)     
C.getInitqualLinkValueMsx         

C.setInitqualNodeValueMsx(2,1500)
C.getInitqualNodeValueMsx   

C.getErrorMsx(501)

C.saveMsxFile('msxsavedtest.msx');                  
 

C.getReportMsx   

l = C.getComputedQualityLinkMsx                                  
n = C.getComputedQualityNodeMsx                                                
                    
C.unloadMsx 


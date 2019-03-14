<a href="http://www.kios.ucy.ac.cy"><img src="http://www.kios.ucy.ac.cy/templates/favourite/images/kios_logo_hover.png"/><a>

[![DOI](https://zenodo.org/badge/DOI/10.1016/j.proeng.2014.02.066.svg)](https://doi.org/10.1016/j.proeng.2014.02.066)


Sensor Placement (S-PLACE) Toolkit
==============

The `Sensor Placement (S-PLACE) Toolkit' is used for computing at which locations to install contaminant sensors in water distribution systems to reduce the impact risks. The S-PLACE Toolkit is build on the mathematical framework previously proposed (Eliades and Polycarpou, 2010) and it has been designed to be user-friendly and modular, suitable for both the professional and the research community. The Toolkit is programmed in Matlab utilizing the EPANET libraries. The modular software architecture allows each module to be accessed independently through stand-alone functions. Furthermore, the Toolkit allows the user to add, modify or remove methods and network elements, as well as to program new functions. The use of the software is illustrated using benchmark networks which capture different types of real network topologies, such as looped and branched networks. 

## Table of Contents

- [How to cite](#how-to-cite)
- [Requirements](#requirements)
- [Licenses](#Licenses)
- [EPANET](#EPANET)
- [Instructions](#Instructions)

## How to cite

```
@proceedings{eliades_demetrios_g_2014_1252756,
  title        = {{Sensor Placement in Water Distribution Systems 
                   Using the S-PLACE Toolkit}},
  year         = 2014,
  publisher    = {Zenodo},
  month        = apr,
  doi          = {10.1016/j.proeng.2014.02.066},
  url          = {https://doi.org/10.1016/j.proeng.2014.02.066}
}
```

* Eliades, D. G., Kyriakou, M., and Polycarpou, M. M. (2014). Sensor placement in water distribution systems using the S-PLACE Toolkit. Proc12th International Conference on Computing and Control for the Water Industry, CCWI2013, Procedia Engineering, Elsevier, 70, pp. 602-611. (https://doi.org/10.1016/j.proeng.2014.02.066)

&uparrow; [Back to top](#table-of-contents)

## Requirements

* [Matlab](http://www.mathworks.com/)
* [EPANET v2.1](https://github.com/OpenWaterAnalytics/EPANET)

&uparrow; [Back to top](#table-of-contents)

## Licenses

S-PLACE Toolkit


Copyright 2013 KIOS Research Center for Intelligent Systems and Networks, University of Cyprus (www.kios.org.cy)

Licensed under the EUPL, Version 1.1 or - as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
- You may not use this work except in compliance with the Licence.
- You may obtain a copy of the Licence at: (http://ec.europa.eu/idabc/eupl)

Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the Licence for the specific language governing permissions and limitations under the Licence.

&uparrow; [Back to top](#table-of-contents)

## EPANET

EPANET is public domain software that may be freely copied and distributed. 

## Instructions

The Toolkit works with your 32-bit Matlab version, and can work with 64-bit computers by using a suitable epanet.dll

1. To download, press here: https://github.com/KIOS-Research/splace-toolkit/archive/master.zip

2. Unzip this file in a folder, and set this folder as the "active" matlab path.

3. Next, you just run the SPLACE.m file. This will load the GUI. From there, you can load any *.inp files. 

4. Next, you need to select and run a series of algorithms, to solve the sensor placement. You first need to create a parameter set for all scenarios (GridParameters). Next, simulate the scenarios (SimulateAll). Next, compute the impact matrix e.g. with metric the contaminated water consumption volume (CWCV) and  finally, solve the optimization (Exhaustive or Evolutionary). Depending on whether you have the evolutionary toolkit, the evolutionary multi-objective algorithm might not work, but you can use whatever optimization you prefer.   

5. All algorithms are modular, i.e. they all read/create certain files with certain structure. If you want to create a new algorithm e.g. for optimization, just copy/paste one of the existing algorithms, change its name and change the code accordingly, the toolkit will automatically recognize the new functions.

&uparrow; [Back to top](#table-of-contents)

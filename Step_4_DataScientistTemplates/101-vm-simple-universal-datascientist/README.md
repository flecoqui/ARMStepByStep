# Deployment of a VM (Linux or Windows) installing DLIB pre-requisites (c++,python,...)

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_4_DataScientistTemplates%2F101-vm-simple-universal-datascientist%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fflecoqui%2FARMStepByStep%2Fmaster%2FStep_4_DataScientistTemplates%2F101-vm-simple-universal-datascientist%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


The objective of this template is to automate the creation of a VM (Linux or Windows) to generate DLIB components and to test those components from a python script. </p>
Once the VM is deployed the DLIB source code is avaialble under:</p>
### Linux
```bash
/git/dlib
```

### Windows
```PowerShell
c:\git\dlib
```

</p>
So far this template allows you to deploy a simple VM running: </p>

1. **Debian**: Apache, g++, cmake, Anaconda3, DLIB source code and samples (C++,Python).
2. **Ubuntu**: Apache, g++, cmake, Anaconda3, DLIB source code and samples (C++,Python).
3. **Centos**: Apache, g++, cmake, Anaconda3, DLIB source code and samples (C++,Python).
4. **Red Hat**: Apache, g++, cmake, Anaconda3, DLIB source code and samples (C++,Python).
5. **Windows** Server 2016: IIS, VC++, cmake, Anaconda3, DLIB source code and samples (C++,Python).

This will deploy in the region associated with Resource Group and the VM Size is one of the parameter.</p>
Once the VM is deployed you can use the following bash files for Linux VM under /git/bash: </p>

+ **buildDLIB.sh**: build DLIB library(C++),
+ **buildDLIBCPPSamples.sh**: build DLIB C++ samples (C++),
+ **buildDLIBPythonSamples.sh**: build DLIB Python samples (Python),
+ **runTests.sh**: run unit tests (C++,Python)

For Windows VM, you can use the following bat files under C:\git\bash: </p>

+ **buildDLIB.bat**: build DLIB library(C++),
+ **buildDLIBCPPSamples.bat**: build DLIB C++ samples (C++),
+ **buildDLIBPythonSamples.bat**: build DLIB Python samples (Python),
+ **runTests.bat**: run unit tests (C++,Python)

</p>
The diagnostic information after the installation are available under:

### Linux
```bash
/var/log/install.log
```

### Windows
```PowerShell
C:\var\log\install.log
```

With Azure CLI you can deploy this VM with 2 command lines:


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/1-architecture.png)


## CREATE RESOURCE GROUP:
azure group create "ResourceGroupName" "DataCenterName"

For instance:

    azure group create dlibgrpeu2 eastus2

## DEPLOY THE VM:
azure group deployment create "ResourceGroupName" "DeploymentName"  -f azuredeploy.json -e azuredeploy.parameters.json

For instance:

    azure group deployment create dlibgrpeu2 depdlibtest -f azuredeploy.json -e azuredeploy.parameters.json -vv

Beyond login/password, the input parameters are :</p>
configurationSize (Small: F2 and 128 GB data disk, Medium: F4 and 256 GB data disk, Large: F8 and 512 GB data disk, XLarge: F16 and 1024 GB data disk) : 

    "configurationSize": {
      "type": "string",
      "defaultValue": "Small",
      "allowedValues": [
        "Small",
        "Medium",
        "Large",
        "XLarge"
      ],
      "metadata": {
        "description": "Configuration Size: VM Size + Disk Size"
      }
    }

configurationOS (debian, ubuntu, centos, redhat, nano server 2016, windows server 2016): 

    "configurationOS": {
      "type": "string",
      "defaultValue": "debian",
      "allowedValues": [
        "debian",
        "ubuntu",
        "centos",
        "redhat",
        "nanoserver2016",
        "windowsserver2016"
      ],
      "metadata": {
        "description": "The Operating System to be installed on the VM. Default value debian. Allowed values: debian,ubuntu,centos,redhat,nanoserver2016,windowsserver2016"
      }
    },



## TEST THE VM:
Once the VM has been deployed, you can check the Web page hosted on the VM.</p>
For the Linux VM:</p>
http://DNSName/index.php

For the Windows VM:</p>
http://DNSName/index.html

</p>
For instance, for Linux VM:

     http://vmubus001.eastus2.cloudapp.azure.com/index.php 

for Windows VM:

     http://vmnanos001.eastus2.cloudapp.azure.com/index.html 

</p>
Finally, you can open a remote session with the VM.

For instance for Linux VM:

     ssh VMAdmin@vmubus001.eastus2.cloudapp.azure.com

For Windows Server VM:

     mstsc /admin /v:vmwins001.eastus2.cloudapp.azure.com


</p>
For Windows Virtual Machine, once you are connected in the RDP session from C:\GIT\BASH you can launch the following commands files: </p>

+ buildDLIB.bat: to build DLIB library with Visual C++ 2017</p> 
+ buildDLIBCPPSamples.bat: to build DLIB C++ samples with Visual C++ 2017 (this batch file will fail when compiling dnn_face_recognition_ex.cpp: Visual C++ issue)</p> 
+ buildBoostForPython.bat: to build boost library if you want to try to generate the DLIB Library for Python. So far the issue with Visual C++ prevents the generation of DLIB library for python.
+ buildDLIBPythonSamples.bat: to build DLIB Python samples with VC++ 2017 (this batch file will fail when compiling dnn_face_recognition_ex.cpp: Visual C++ issue)  </p> 
    As it's not possible to generate the python library, by default the DLIB library is imported with Anaconda3 x64 </p> 
+ runDLIBTests.bat: to run DLIB tests (this batch file will fail when compiling dnn_face_recognition_ex.cpp: Visual C++ issue) </p> 

</p>
To test DLIB with python scripts, you don't need to generate DLIB Library (buildDLIB.bat) nor DLIB Library for python, the DLIB Library for python is imported with conda. Change directory c:\git\dlib\python_examples and run for instance the following commands:</p>
Test not requiring a UI:

      python ./svm_rank.py

Test requiring a UI (X11 or Windows):

      python ./face_landmark_detection.py ../../dlib-models/shape_predictor_68_face_landmarks.dat ../examples/faces

</p>

For Linux Virtual Machines, once you are connected with ssh, you can use the following bash files under /git/bash to: </p>

+ buildDLIB.sh: build DLIB library(C++),</p>
+ buildDLIBCPPSamples.sh: build DLIB C++ samples (C++),</p>
+ buildDLIBPythonSamples.sh: build DLIB Python samples (Python),</p>
+ runTests.sh: run unit tests (C++,Python)</p>
</p>
By default the bash files are available under /git/bash folder.</p>

</p>
If you want to test DLIB with the python samples, you'll find under /git/dish/python_examples several python files.
You can for instance run the following sample script:

       python ./svm_rank.py 

to check the python configuration.
Keep in mind before running this test, you need to build the DLIB library (bash buildDLIB.sh) and the python samples (bash buildDLIBPythonSamples.sh).

![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/test1.png)


If you want to test python samples which require GUI, you need to install an X11 terminal on your client. If you are using a Windows PC, you could install Putty and XMing to support X11 on your PC:</p>
+ **PuTTy** from http://www.chiark.greenend.org.uk/~sgtatham/putty/ </p>
+ **Xming** from http://sourceforge.net/project/downloading.php?group_id=156984&filename=Xming-6-9-0-31-setup.exe </p>


Install Xming following the installation screenshots below:

![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/xming1.jpg)


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/xming2.jpg)


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/xming3.jpg)


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/xming4.jpg)

Configure Putty following the installation screenshots below:</p>

Enter the dns name of your server :</p>
![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty1.png)


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty2.jpg)


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty3.jpg)


![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty4.jpg)


The server is already configured to support X11 over SSH, and the file /etc/ssh/ssh_config has been updated:

+ ForwardAgent yes</p>
+ ForwardX11 yes</p>
+ ForwardX11Trusted yes </p>

The file /etc/ssh/sshd_config has been updated:

+ X11Forwarding yes</p>


Before launching Putty to open an SSH session with your VM check that XMing is running on your local Windows Machine:
![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/xming5.png)


Once you are connected with Putty,

![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty5.png)

Enter the following commands to test if X11 is running: </p>

+ xclock </p>

The Clock should be displayed on your Windows machine:

![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty6.png)

Now you can test the python samples requiring GUI:</p>
For instance under /git/dlib/python_examples run the following command:</p>

     python ./face_landmark_detection.py ../../dlib-models/shape_predictor_68_face_landmarks.dat ../examples/faces

 and check that the picture is displayed on your local machine:</p>

![](https://raw.githubusercontent.com/flecoqui/ARMStepByStep/master/Step_4_DataScientistTemplates/101-vm-simple-universal-datascientist/Docs/putty7.png)

## DELETE THE RESOURCE GROUP:
azure group delete "ResourceGroupName" "DataCenterName"

For instance:

    azure group delete dlibgrpeu2 eastus2

# mums


If you are looking for imagemagick or ghostscript among other OSS tools that IBM can not provide for some reason, then this script is for you.

```mums``` allows you to install open source packages on IBM i into PASE not provided by YUM

Thanks to Michael Perzl I have been using loads of "linux open source for AIX" open source on the IBM i in the PASE environment over the years.

However it is hard to make the PERZL tool work these days. So I decided to make a super simple script that will provide the tools I need from the folowwing sites: 

https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/

ftp://www.oss4aix.org 

This script is in no way fancy, however it combines the tools that nowadays are available by yum like "rpm" together with the functionality that Michael Perzl provided many years ago.  
 
.. and this is what this script is all about.

## Install ```mums```

Before you can clone this git repo then You need to ensure that the ssh daemon is running on your IBM i. 
So from a IBM i menu prompt start the SSH daemon:

```
===> STRTCPSVR *SSHD
```

Now - you need to have wget and git on your IBM i:

1) Open ACS and click on "Tools"
2) Click on "Open Source Package Management"
3) Open the "Available packages" tab
4) Click "wget" and "Install"
5) Click "git" and "Install"

Next up we need a SSH terminal:

1) Click SSH Terminal in ACS ( or use your default terminal like putty) 

(or you can use ```call qp2term``` – but I suggest that you get use to ssh)

2) From the terminal. You can also install git and wget with yum from the command line if you don't like the above:  
```
ssh MY_IBM_I
PATH=/QOpenSys/pkgs/bin:$PATH
yum install wget git
```
As you can see - you have to adjust your path to use yum, git and other opens source tooling  

And now in the same ssh session - clone the repo 
```
mkdir /prj
cd /prj
git -c http.sslVerify=false clone https://github.com/NielsLiisberg/mums.git
```

Now you have /prj/mums on your IFS - You are good to go.
"mums" will install all your open source into ```/opt/freeware```

## Using ```mums```

btw. "mums" is Danish for "yum" ..

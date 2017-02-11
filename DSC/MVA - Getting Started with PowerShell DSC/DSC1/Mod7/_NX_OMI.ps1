Start-Process -FilePath iexplore http://blogs.technet.com/b/privatecloud/archive/2014/05/19/powershell-dsc-for-linux-step-by-step.aspx

# Do not run in Windows PowerShell -- CentOS 6

# 1. Install required Pre-Req packages
yum groupinstall 'Development Tools'
yum install pam-devel
yum install openssl-devel
yum install wget
# 2. Download and extract OMI 1.0.8 from The Open Group
mkdir /root/downloads
cd /root/downloads
wget https://collaboration.opengroup.org/omi/documents/30532/omi-1.0.8.tar.gz
tar -xvf omi-1.0.8.tar.gz
# 3. Config and build OMI
cd omi-1.0.8/
./configure
make
make install
#4. Install DSC Components
yum install python
yum install python-devel
cd /root/downloads
wget https://github.com/MSFTOSSMgmt/WPSDSCLinux/releases/download/v1.0.0-CTP/PSDSCLinux.tar.gz
tar -xvf PSDSCLinux.tar.gz
mv ./dsc/* ./
ls -l
make
make reg
# 5. Run OMI server -debugging
OMI_HOME=/opt/omi-1.0.8 /opt/omi-1.0.8/bin/omiserver
# 6. Run OMI server - background
OMI_HOME=/opt/omi-1.0.8 /opt/omi-1.0.8/bin/omiserver -d
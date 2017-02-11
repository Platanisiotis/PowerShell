
# Create folder and share on DC for MOF and Resource modules
New-Item -Path C:\DSCSMB -ItemType Directory
New-SmbShare -Name DSCSMB -Path c:\DSCSMB -ReadAccess Everyone -FullAccess Administrator -Description "SMB share for DSC"
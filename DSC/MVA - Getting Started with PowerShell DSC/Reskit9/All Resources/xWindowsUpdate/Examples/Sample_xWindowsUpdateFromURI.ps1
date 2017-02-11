<#
 # This sample looks at installing a particular windows update. However, the URI and ID properties can be changed 
 # as per the hotfix that you want to install
 #>

Configuration DownloadHotfixFromURI
{
    xHotfix m1
    {
        Uri = "http://hotfixv4.microsoft.com/Microsoft%20Office%20SharePoint%20Server%202007/sp2/officekb956056fullfilex64glb/12.0000.6327.5000/free/358323_intl_x64_zip.exe"
        Id = "KB956056" 
        Ensure="Present"
    }

}
DownloadHotfixFromURI

Start-DscConfiguration -path ./DownloadHotfixFromURI -wait -Verbose
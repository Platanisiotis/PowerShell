$OFS=[Environment]::Newline

#Read Script elements from text files
$ConfigGet = Get-Content "c:\scripts\DSC1\Mod7\scripts\get.txt"
$ConfigSet = Get-Content "c:\scripts\DSC1\Mod7\scripts\set.txt"
$ConfigTest = Get-Content "c:\scripts\DSC1\Mod7\scripts\test.txt"


#Get WPConfig from file
$WPConfig  = Get-Content "c:\scripts\DSC1\Mod7\scripts\WP-Config.txt"

#Define WordPress Server Configuration
Configuration WordPressServer
{
   
    #Import Linux DSC Module
    Import-DscResource -Module nx

    Node '192.168.3.20' {

		# Install packages if they are not installed
		nxPackage httpd
		{
			Name = "httpd"
			Ensure = "Present"
			PackageManager = "Yum"
		}
		
		nxPackage mod_ssl
		{
			Name = "mod_ssl"
			Ensure = "Present"
			PackageManager = "Yum"
		}
		
		nxPackage php
		{
			Name = "php"
			Ensure = "Present"
			PackageManager = "Yum"
		}
	
		nxPackage php-mysql
		{
			Name = "php-mysql"
			Ensure = "Present"
			PackageManager = "Yum"
		}
		
		nxPackage mysql
		{
			Name = "mysql"
			Ensure = "Present"
			PackageManager = "Yum"
		}
		
		nxPackage mysql-server
		{
			Name = "mysql-server"
			Ensure = "Present"
			PackageManager = "Yum"
		}
		
		nxPackage unzip
		{
			Name = "unzip"
			Ensure = "Present"
			PackageManager = "Yum"
		}
				
		nxPackage wget
		{
			Name = "wget"
			Ensure = "Present"
			PackageManager = "Yum"
		}
        
        #Apache Service
        nxService ApacheService 
        {
            Name = "httpd"
            State = "running"
            Enabled = $true
            Controller = "init"
           # DependsOn = "[nxScript]ApacheState"
        }

        #MySQL Service
        nxService MySQLService 
        {
            Name = "mysqld"
            State = "running"
            Enabled = $true
            Controller = "init"
        }
		
		# Configure MySQL and Wordpress
        nxScript ConfigScript
        {
            GetScript = "$ConfigGet"
            SetScript = "$ConfigSet"
            TestScript = "$ConfigTest"
			DependsOn = "[nxService]ApacheService", "[nxService]MySQLService"
        }
       
        nxFile indexpage
        {
            Ensure = "Present"  
            Type = "File" # Default is "File".
            DestinationPath = "/var/www/html/index.php"    
            Contents = "<?php phpinfo(); ?>"
            DependsOn = "[nxScript]ConfigScript"
        }
		
        nxFile uploadsdir
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "/var/www/html/wordpress/wp-content/uploads"
            Mode = "700"
            DependsOn = "[nxScript]ConfigScript"
        }

        nxFile cachedir
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "/var/www/html/wordpress/wp-content/cache"
            Mode = "700" 
            DependsOn = "[nxScript]ConfigScript"
        }

        nxFile wp-config
        {
            Ensure = "Present"
            DestinationPath = "/var/www/html/wordpress/wp-config.php"
            Type="File"
            Contents = "$WPConfig"
            DependsOn = "[nxScript]ConfigScript"
        }



    }
}

WordPressServer -outputpath c:\DSCNX 

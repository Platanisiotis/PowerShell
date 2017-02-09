#Requires -Version 3.0
function Get-CheatSheet
{
    [CmdletBinding(PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias("cs")]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0)]
        [ValidateSet("Operators", "Classes", "Parameter_Attribute_Property", "Default_Variables","ADS_Constants","Debugging_Commands","UTF-8_Unicode")]
        [Alias("cheat")] 
        $Reference
    )

    Begin
    {
        $Object = @()

    }
    Process
    {
        switch ($Reference) 
        {
            Operators 
            {
                $CollectionStats = @(
                    ('-eq','Equals','$a = 5 ; $a -eq 4','False'),
                    ('-ne','Does not equal','$a = 5 ; $a -ne 4','True'),
                    ('-gt','Greater than','$a = 5 ; $a -gt 4','True'),
                    ('-ge','Greater than or equal to','$a = 5 ; $a -ge 5','True'),
                    ('-lt','Less than','$a = 5 ; $a -lt 5','False'),
                    ('-le','Less than or equal to','$a = 5 ; $a -le 5','True'),
                    ('-like','Wildcard comparison','$a = “This is Text” ; $a -like “Text”','False'),
                    ('-notlike','Wildcard comparison','$a = “This is Text” ; $a -notlike “Text”','True'),
                    ('-match','Regular expression comparison','$a = “This is Text” ; $a -match “Text”','True'),
                    ('-notmatch','Regular expression comparison','$a = “This is Text” ; $a -notmatch “Text$”','False')
                )

                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Operator"= $Stat[0];
                        "Description"= $Stat[1];
                        "Example"= $Stat[2];
                        "Result"= $Stat[3];
                    }
                }
            }


            Classes
            {
                # $CollectionStats - System.Object[]
                $CollectionStats = @(
                    ('[int]','A 32-bit signed integer'),
                    ('[long','A 64-bit signed integer'),
                    ('[string]','A fixed-length string of Unicode characters'),
                    ('[char]','A Unicode 16-bit character, UTF-16'),
                    ('[bool]','A true/false value'),
                    ('[byte]','An 8-bit unsigned integer'),
                    ('[double]','A double-precision 64-bit floating-point number'),
                    ('[decimal]','A 128-bit decimal value'),
                    ('[single]','A single-precision 32-bit floating-point number'),
                    ('[array]','An array of values'),
                    ('[xml]','An XML document'),
                    ('[hashtable]','A hashtable object (similar to a dictionary object'),
                    ('[ordered]','An ordered array')
                )

                # $Stat - System.String
                # $CollectionStats - System.Object[]
                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Class"= $Stat[0];
                        "Description"= $Stat[1];
                    }
                }
            }

            # Switch option for $Reference
            'Parameter_Attribute_Property'
            {
                # $CollectionStats - System.Object[]
                $CollectionStats = @(
                    ('Mandatory','Mandatory=$true','The parameter must be specified.'),
                    ('Position','Position=0','The parameter occupies the first position when the function is called.'),
                    ('ParameterSetName','ParameterSetName=”name”','The parameter belongs to the specified parameter set.'),
                    ('ValueFromPipeline','ValueFromPipeline=$true','The parameter accepts pipelined input.'),
                    ('ValueFromPipelineByPropertyName','ValueFromPipelineByPropertyName=$true','The parameter uses a property of the object instead of the entire object.'),
                    ('ValueFromRemainingArguments','ValueFromRemainingArguments=$true','The parameter collects unassigned arguments.'),
                    ('HelpMessage','HelpMessage=”parameter help info”','A short help message for the parameter is displayed.')
                )
                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Parameter Attribute Property"= $Stat[0];
                        "Example"= $Stat[1];
                        "Meaning"= $Stat[2];
                    }
                }
            }

            Default_Variables
            {
                $CollectionStats = @( 
                    ('$^','This contains the first token of the last line input into the shell.'),
                    ('$$','This contains the last token of the last line input into the shell.'),
                    ('$_','This is the current pipeline object; it is used in script blocks, filters, Where-Object, ForEach-Object, and Switch.'),
                    ('$?','This contains the success/fail status of the last statement.'),
                    ('$Args','This is used with functions or scripts requiring parameters that do not have a param block.'),
                    ('$Error','This saves the error object in the $error variable if an error occurs.'),
                    ('$ExecutionContext','This contains the execution objects available to cmdlets.'),
                    ('$foreach','This refers to the enumerator in a foreach loop.'),
                    ('$HOME','This is the user'‘s home directory (set to %HOMEDRIVE%\%HOMEPATH%).'),
                    ('$Input','This is input that is pipelined to a function or code block.'),
                    ('$Match','This is a hash table consisting of items found by the -match operator.'),
                    ('$MyInvocation','This contains information about the currently executing script or command line.'),
                    ('$PSHome','This is the directory where Windows PowerShell is installed.'),
                    ('$Host','This contains information about the currently executing host.'),
                    ('$LastExitCode','This contains the exit code of the last native application to run.'),
                    ('$True','This is used for Boolean TRUE.'),
                    ('$False','This is used for Boolean FALSE.'),
                    ('$Null','This represents a null object.'),
                    ('$This','In the Types.ps1xml file and some script block instances, this represents the current object.'),
                    ('$OFS','This is the output field separator used when converting an array to a string.'),
                    ('$ShellID','This is the identifier for the shell; this value is used by the shell to determine the execution policy and what profiles are run at startup.'),
                    ('$StackTrace','This contains detailed stack trace information about the last error.'),
                    ('$using','?????')            
                )
                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Variable"= $Stat[0];
                        "Description"= $Stat[1]
                    }
                }
            }

            ADS_Constants
            {
                $CollectionStats = @(
                    ('ADS_UF_SCRIPT','0X0001'),
                    ('ADS_UF_ACCOUNTDISABLE','0X0002'),
                    ('ADS_UF_HOMEDIR_REQUIRED','0X0008'),
                    ('ADS_UF_LOCKOUT','0X0010'),
                    ('ADS_UF_PASSWD_NOTREQD','0X0020'),
                    ('ADS_UF_PASSWD_CANT_CHANGE','0X0040'),
                    ('ADS_UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED','0X0080'),
                    ('ADS_UF_TEMP_DUPLICATE_ACCOUNT','0X0100'),
                    ('ADS_UF_NORMAL_ACCOUNT','0X0200'),
                    ('ADS_UF_INTERDOMAIN_TRUST_ACCOUNT','0X0800'),
                    ('ADS_UF_WORKSTATION_TRUST_ACCOUNT','0X1000'),
                    ('ADS_UF_SERVER_TRUST_ACCOUNT','0X2000'),
                    ('ADS_UF_DONT_EXPIRE_PASSWD','0X10000'),
                    ('ADS_UF_MNS_LOGON_ACCOUNT','0X20000'),
                    ('ADS_UF_SMARTCARD_REQUIRED','0X40000'),
                    ('ADS_UF_TRUSTED_FOR_DELEGATION','0X80000'),
                    ('ADS_UF_NOT_DELEGATED','0X100000'),
                    ('ADS_UF_USE_DES_KEY_ONLY','0x200000'),
                    ('ADS_UF_DONT_REQUIRE_PREAUTH','0x400000'),
                    ('ADS_UF_PASSWORD_EXPIRED','0x800000'),
                    ('ADS_UF_TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION','0x1000000')
                )

                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "ADS constant"= $Stat[0];
                        "Value in hexadecimal"= $Stat[1]
                    }
                }
            }

            'Debugging_Commands'
            {
                $CollectionStats = @(
                    ('S','Step-Into','Executes the next statement and then stops.'),
                    ('V','Step-Over','Executes the next statement, but skips functions and invocations. The skipped statements are executed, but not stepped through.'),
                    ('O','Step-Out','Steps out of the current function up one level if nested. If the current function is in the main body, execution continues to the end or to the next breakpoint. The skipped statements are executed, but not stepped through.'),
                    ('C','Continue','Continues to run until the script is complete or until the next breakpoint is reached. The skipped statements are executed, but not stepped through.'),
                    ('L','List','Displays the part of the script that is executing. By default, this displays the current line, 5 previous lines, and 10 subsequent lines. To continue listing the script, press Enter.'),
                    ('L <M>','List','Displays 16 lines of the script, beginning with the line number specified by M.'),
                    ('L <M> <N>','List','Displays the number of lines of the script specified by N, beginning with the line number specified by M.'),
                    ('Q','Stop (Quit)','Stops executing the script and exits the debugger.'),
                    ('K','Get-PsCallStack','Displays the current call stack.'),
                    ('Enter','Repeat','Repeats the last command if it was Step-Into, Step-Over, or List. Otherwise, represents a submit action.'),
                    ('H or ?','Help','Displays the debugger command help.')
                )
                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Keyboard Shortcut"= $Stat[0];
                        "Name"= $Stat[1];
                        "Meaning"=$Stat[2]
                    }
                }
            }

            UTF-8_Unicode
            {
                $CollectionStats = @(
                    ('0x0000','','0','<control>'),
                    ('0x0001','','1','<control>'),
                    ('0x0002','','2','<control>'),
                    ('0x0003','','3','<control>'),
                    ('0x0004','','4','<control>'),
                    ('0x0005','','5','<control>'),
                    ('0x0006','','6','<control>'),
                    ('0x0007','','7','<control>'),
                    ('0x0008','','8','<control>'),
                    ('0x0009','','9','<control>'),
                    ('0x000A','','0a','<control>'),
                    ('0x000B','','0b','<control>'),
                    ('0x000C','','0c','<control>'),
                    ('0x000D','','0d','<control>'),
                    ('0x000E','','0e','<control>'),
                    ('0x000F','','0f','<control>'),
                    ('0x0010','','10','<control>'),
                    ('0x0011','','11','<control>'),
                    ('0x0012','','12','<control>'),
                    ('0x0013','','13','<control>'),
                    ('0x0014','','14','<control>'),
                    ('0x0015','','15','<control>'),
                    ('0x0016','','16','<control>'),
                    ('0x0017','','17','<control>'),
                    ('0x0018','','18','<control>'),
                    ('0x0019','','19','<control>'),
                    ('0x001A','','1a','<control>'),
                    ('0x001B','','1b','<control>'),
                    ('0x001C','','1c','<control>'),
                    ('0x001D','','1d','<control>'),
                    ('0x001E','','1e','<control>'),
                    ('0x001F','','1f','<control>'),
                    ('0x0020','','20','SPACE'),
                    ('0x0021','!','21','EXCLAMATION MARK'),
                    ('0x0022','"','22','QUOTATION MARK'),
                    ('0x0023','#','23','NUMBER SIGN'),
                    ('0x0024','$','24','DOLLAR SIGN'),
                    ('0x0025','%','25','PERCENT SIGN'),
                    ('0x0026','&','26','AMPERSAND'),
                    ('0x0027',"'",'27','APOSTROPHE'),
                    ('0x0028','(','28','LEFT PARENTHESIS'),
                    ('0x0029',')','29','RIGHT PARENTHESIS'),
                    ('0x002A','*','2a','ASTERISK'),
                    ('0x002B','+','2b','PLUS SIGN'),
                    ('0x002C',',','2c','COMMA'),
                    ('0x002D','-','2d','HYPHEN-MINUS'),
                    ('0x002E','.','2e','FULL STOP'),
                    ('0x002F','/','2f','SOLIDUS'),
                    ('0x0030','0','30','DIGIT ZERO'),
                    ('0x0031','1','31','DIGIT ONE'),
                    ('0x0032','2','32','DIGIT TWO'),
                    ('0x0033','3','33','DIGIT THREE'),
                    ('0x0034','4','34','DIGIT FOUR'),
                    ('0x0035','5','35','DIGIT FIVE'),
                    ('0x0036','6','36','DIGIT SIX'),
                    ('0x0037','7','37','DIGIT SEVEN'),
                    ('0x0038','8','38','DIGIT EIGHT'),
                    ('0x0039','9','39','DIGIT NINE'),
                    ('0x003A',':','3a','COLON'),
                    ('0x003B',';','3b','SEMICOLON'),
                    ('0x003C','<','3c','LESS-THAN SIGN'),
                    ('0x003D','=','3d','EQUALS SIGN'),
                    ('0x003E','>','3e','GREATER-THAN SIGN'),
                    ('0x003F','?','3f','QUESTION MARK'),
                    ('0x0040','@','40','COMMERCIAL AT'),
                    ('0x0041','A','41','LATIN CAPITAL LETTER A'),
                    ('0x0042','B','42','LATIN CAPITAL LETTER B'),
                    ('0x0043','C','43','LATIN CAPITAL LETTER C'),
                    ('0x0044','D','44','LATIN CAPITAL LETTER D'),
                    ('0x0045','E','45','LATIN CAPITAL LETTER E'),
                    ('0x0046','F','46','LATIN CAPITAL LETTER F'),
                    ('0x0047','G','47','LATIN CAPITAL LETTER G'),
                    ('0x0048','H','48','LATIN CAPITAL LETTER H'),
                    ('0x0049','I','49','LATIN CAPITAL LETTER I'),
                    ('0x004A','J','4a','LATIN CAPITAL LETTER J'),
                    ('0x004B','K','4b','LATIN CAPITAL LETTER K'),
                    ('0x004C','L','4c','LATIN CAPITAL LETTER L'),
                    ('0x004D','M','4d','LATIN CAPITAL LETTER M'),
                    ('0x004E','N','4e','LATIN CAPITAL LETTER N'),
                    ('0x004F','O','4f','LATIN CAPITAL LETTER O'),
                    ('0x0050','P','50','LATIN CAPITAL LETTER P'),
                    ('0x0051','Q','51','LATIN CAPITAL LETTER Q'),
                    ('0x0052','R','52','LATIN CAPITAL LETTER R'),
                    ('0x0053','S','53','LATIN CAPITAL LETTER S'),
                    ('0x0054','T','54','LATIN CAPITAL LETTER T'),
                    ('0x0055','U','55','LATIN CAPITAL LETTER U'),
                    ('0x0056','V','56','LATIN CAPITAL LETTER V'),
                    ('0x0057','W','57','LATIN CAPITAL LETTER W'),
                    ('0x0058','X','58','LATIN CAPITAL LETTER X'),
                    ('0x0059','Y','59','LATIN CAPITAL LETTER Y'),
                    ('0x005A','Z','5a','LATIN CAPITAL LETTER Z'),
                    ('0x005B','[','5b','LEFT SQUARE BRACKET'),
                    ('0x005C','\','5c','REVERSE SOLIDUS'),
                    ('0x005D',']','5d','RIGHT SQUARE BRACKET'),
                    ('0x005E','^','5e','CIRCUMFLEX ACCENT'),
                    ('0x005F','_','5f','LOW LINE'),
                    ('0x0060','`','60','GRAVE ACCENT'),
                    ('0x0061','a','61','LATIN SMALL LETTER A'),
                    ('0x0062','b','62','LATIN SMALL LETTER B'),
                    ('0x0063','c','63','LATIN SMALL LETTER C'),
                    ('0x0064','d','64','LATIN SMALL LETTER D'),
                    ('0x0065','e','65','LATIN SMALL LETTER E'),
                    ('0x0066','f','66','LATIN SMALL LETTER F'),
                    ('0x0067','g','67','LATIN SMALL LETTER G'),
                    ('0x0068','h','68','LATIN SMALL LETTER H'),
                    ('0x0069','i','69','LATIN SMALL LETTER I'),
                    ('0x006A','j','6a','LATIN SMALL LETTER J'),
                    ('0x006B','k','6b','LATIN SMALL LETTER K'),
                    ('0x006C','l','6c','LATIN SMALL LETTER L'),
                    ('0x006D','m','6d','LATIN SMALL LETTER M'),
                    ('0x006E','n','6e','LATIN SMALL LETTER N'),
                    ('0x006F','o','6f','LATIN SMALL LETTER O'),
                    ('0x0070','p','70','LATIN SMALL LETTER P'),
                    ('0x0071','q','71','LATIN SMALL LETTER Q'),
                    ('0x0072','r','72','LATIN SMALL LETTER R'),
                    ('0x0073','s','73','LATIN SMALL LETTER S'),
                    ('0x0074','t','74','LATIN SMALL LETTER T'),
                    ('0x0075','u','75','LATIN SMALL LETTER U'),
                    ('0x0076','v','76','LATIN SMALL LETTER V'),
                    ('0x0077','w','77','LATIN SMALL LETTER W'),
                    ('0x0078','x','78','LATIN SMALL LETTER X'),
                    ('0x0079','y','79','LATIN SMALL LETTER Y'),
                    ('0x007A','z','7a','LATIN SMALL LETTER Z'),
                    ('0x007B','{','7b','LEFT CURLY BRACKET'),
                    ('0x007C','|','7c','VERTICAL LINE'),
                    ('0x007D','}','7d','RIGHT CURLY BRACKET'),
                    ('0x007E','~','7e','TILDE'),
                    ('0x007F','','7f','<control>'),
                    ('0x0080','','c2 80','<control>'),
                    ('0x0081','','c2 81','<control>'),
                    ('0x0082','','c2 82','<control>'),
                    ('0x0083','','c2 83','<control>'),
                    ('0x0084','','c2 84','<control>'),
                    ('0x0085','','c2 85','<control>'),
                    ('0x0086','','c2 86','<control>'),
                    ('0x0087','','c2 87','<control>'),
                    ('0x0088','','c2 88','<control>'),
                    ('0x0089','','c2 89','<control>'),
                    ('0x008A','','c2 8a','<control>'),
                    ('0x008B','','c2 8b','<control>'),
                    ('0x008C','','c2 8c','<control>'),
                    ('0x008D','','c2 8d','<control>'),
                    ('0x008E','','c2 8e','<control>'),
                    ('0x008F','','c2 8f','<control>'),
                    ('0x0090','','c2 90','<control>'),
                    ('0x0091','','c2 91','<control>'),
                    ('0x0092','','c2 92','<control>'),
                    ('0x0093','','c2 93','<control>'),
                    ('0x0094','','c2 94','<control>'),
                    ('0x0095','','c2 95','<control>'),
                    ('0x0096','','c2 96','<control>'),
                    ('0x0097','','c2 97','<control>'),
                    ('0x0098','','c2 98','<control>'),
                    ('0x0099','','c2 99','<control>'),
                    ('0x009A','','c2 9a','<control>'),
                    ('0x009B','','c2 9b','<control>'),
                    ('0x009C','','c2 9c','<control>'),
                    ('0x009D','','c2 9d','<control>'),
                    ('0x009E','','c2 9e','<control>'),
                    ('0x009F','','c2 9f','<control>'),
                    ('0x00A0','','c2 a0','NO-BREAK SPACE'),
                    ('0x00A1','¡','c2 a1','INVERTED EXCLAMATION MARK'),
                    ('0x00A2','¢','c2 a2','CENT SIGN'),
                    ('0x00A3','£','c2 a3','POUND SIGN'),
                    ('0x00A4','¤','c2 a4','CURRENCY SIGN'),
                    ('0x00A5','¥','c2 a5','YEN SIGN'),
                    ('0x00A6','¦','c2 a6','BROKEN BAR'),
                    ('0x00A7','§','c2 a7','SECTION SIGN'),
                    ('0x00A8','¨','c2 a8','DIAERESIS'),
                    ('0x00A9','©','c2 a9','COPYRIGHT SIGN'),
                    ('0x00AA','ª','c2 aa','FEMININE ORDINAL INDICATOR'),
                    ('0x00AB','«','c2 ab','LEFT-POINTING DOUBLE ANGLE QUOTATION MARK'),
                    ('0x00AC','¬','c2 ac','NOT SIGN'),
                    ('0x00AD',' ','c2 ad','SOFT HYPHEN'),
                    ('0x00AE','®','c2 ae','REGISTERED SIGN'),
                    ('0x00AF','¯','c2 af','MACRON'),
                    ('0x00B0','°','c2 b0','DEGREE SIGN'),
                    ('0x00B1','±','c2 b1','PLUS-MINUS SIGN'),
                    ('0x00B2','²','c2 b2','SUPERSCRIPT TWO'),
                    ('0x00B3','³','c2 b3','SUPERSCRIPT THREE'),
                    ('0x00B4','´','c2 b4','ACUTE ACCENT'),
                    ('0x00B5','µ','c2 b5','MICRO SIGN'),
                    ('0x00B6','¶','c2 b6','PILCROW SIGN'),
                    ('0x00B7','·','c2 b7','MIDDLE DOT'),
                    ('0x00B8','¸','c2 b8','CEDILLA'),
                    ('0x00B9','¹','c2 b9','SUPERSCRIPT ONE'),
                    ('0x00BA','º','c2 ba','MASCULINE ORDINAL INDICATOR'),
                    ('0x00BB','»','c2 bb','RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK'),
                    ('0x00BC','¼','c2 bc','VULGAR FRACTION ONE QUARTER'),
                    ('0x00BD','½','c2 bd','VULGAR FRACTION ONE HALF'),
                    ('0x00BE','¾','c2 be','VULGAR FRACTION THREE QUARTERS'),
                    ('0x00BF','¿','c2 bf','INVERTED QUESTION MARK'),
                    ('0x00C0','À','c3 80','LATIN CAPITAL LETTER A WITH GRAVE'),
                    ('0x00C1','Á','c3 81','LATIN CAPITAL LETTER A WITH ACUTE'),
                    ('0x00C2','Â','c3 82','LATIN CAPITAL LETTER A WITH CIRCUMFLEX'),
                    ('0x00C3','Ã','c3 83','LATIN CAPITAL LETTER A WITH TILDE'),
                    ('0x00C4','Ä','c3 84','LATIN CAPITAL LETTER A WITH DIAERESIS'),
                    ('0x00C5','Å','c3 85','LATIN CAPITAL LETTER A WITH RING ABOVE'),
                    ('0x00C6','Æ','c3 86','LATIN CAPITAL LETTER AE'),
                    ('0x00C7','Ç','c3 87','LATIN CAPITAL LETTER C WITH CEDILLA'),
                    ('0x00C8','È','c3 88','LATIN CAPITAL LETTER E WITH GRAVE'),
                    ('0x00C9','É','c3 89','LATIN CAPITAL LETTER E WITH ACUTE'),
                    ('0x00CA','Ê','c3 8a','LATIN CAPITAL LETTER E WITH CIRCUMFLEX'),
                    ('0x00CB','Ë','c3 8b','LATIN CAPITAL LETTER E WITH DIAERESIS'),
                    ('0x00CC','Ì','c3 8c','LATIN CAPITAL LETTER I WITH GRAVE'),
                    ('0x00CD','Í','c3 8d','LATIN CAPITAL LETTER I WITH ACUTE'),
                    ('0x00CE','Î','c3 8e','LATIN CAPITAL LETTER I WITH CIRCUMFLEX'),
                    ('0x00CF','Ï','c3 8f','LATIN CAPITAL LETTER I WITH DIAERESIS'),
                    ('0x00D0','Ð','c3 90','LATIN CAPITAL LETTER ETH'),
                    ('0x00D1','Ñ','c3 91','LATIN CAPITAL LETTER N WITH TILDE'),
                    ('0x00D2','Ò','c3 92','LATIN CAPITAL LETTER O WITH GRAVE'),
                    ('0x00D3','Ó','c3 93','LATIN CAPITAL LETTER O WITH ACUTE'),
                    ('0x00D4','Ô','c3 94','LATIN CAPITAL LETTER O WITH CIRCUMFLEX'),
                    ('0x00D5','Õ','c3 95','LATIN CAPITAL LETTER O WITH TILDE'),
                    ('0x00D6','Ö','c3 96','LATIN CAPITAL LETTER O WITH DIAERESIS'),
                    ('0x00D7','×','c3 97','MULTIPLICATION SIGN'),
                    ('0x00D8','Ø','c3 98','LATIN CAPITAL LETTER O WITH STROKE'),
                    ('0x00D9','Ù','c3 99','LATIN CAPITAL LETTER U WITH GRAVE'),
                    ('0x00DA','Ú','c3 9a','LATIN CAPITAL LETTER U WITH ACUTE'),
                    ('0x00DB','Û','c3 9b','LATIN CAPITAL LETTER U WITH CIRCUMFLEX'),
                    ('0x00DC','Ü','c3 9c','LATIN CAPITAL LETTER U WITH DIAERESIS'),
                    ('0x00DD','Ý','c3 9d','LATIN CAPITAL LETTER Y WITH ACUTE'),
                    ('0x00DE','Þ','c3 9e','LATIN CAPITAL LETTER THORN'),
                    ('0x00DF','ß','c3 9f','LATIN SMALL LETTER SHARP S'),
                    ('0x00E0','à','c3 a0','LATIN SMALL LETTER A WITH GRAVE'),
                    ('0x00E1','á','c3 a1','LATIN SMALL LETTER A WITH ACUTE'),
                    ('0x00E2','â','c3 a2','LATIN SMALL LETTER A WITH CIRCUMFLEX'),
                    ('0x00E3','ã','c3 a3','LATIN SMALL LETTER A WITH TILDE'),
                    ('0x00E4','ä','c3 a4','LATIN SMALL LETTER A WITH DIAERESIS'),
                    ('0x00E5','å','c3 a5','LATIN SMALL LETTER A WITH RING ABOVE'),
                    ('0x00E6',"æ",'c3 a6','LATIN SMALL LETTER AE'),
                    ('0x00E7','ç','c3 a7','LATIN SMALL LETTER C WITH CEDILLA'),
                    ('0x00E8','è','c3 a8','LATIN SMALL LETTER E WITH GRAVE'),
                    ('0x00E9','é','c3 a9','LATIN SMALL LETTER E WITH ACUTE'),
                    ('0x00EA','ê','c3 aa','LATIN SMALL LETTER E WITH CIRCUMFLEX'),
                    ('0x00EB','ë','c3 ab','LATIN SMALL LETTER E WITH DIAERESIS'),
                    ('0x00EC','ì','c3 ac','LATIN SMALL LETTER I WITH GRAVE'),
                    ('0x00ED','í','c3 ad','LATIN SMALL LETTER I WITH ACUTE'),
                    ('0x00EE','î','c3 ae','LATIN SMALL LETTER I WITH CIRCUMFLEX'),
                    ('0x00EF','ï','c3 af','LATIN SMALL LETTER I WITH DIAERESIS'),
                    ('0x00F0','ð','c3 b0','LATIN SMALL LETTER ETH'),
                    ('0x00F1','ñ','c3 b1','LATIN SMALL LETTER N WITH TILDE'),
                    ('0x00F2','ò','c3 b2','LATIN SMALL LETTER O WITH GRAVE'),
                    ('0x00F3','ó','c3 b3','LATIN SMALL LETTER O WITH ACUTE'),
                    ('0x00F4','ô','c3 b4','LATIN SMALL LETTER O WITH CIRCUMFLEX'),
                    ('0x00F5','õ','c3 b5','LATIN SMALL LETTER O WITH TILDE'),
                    ('0x00F6','ö','c3 b6','LATIN SMALL LETTER O WITH DIAERESIS'),
                    ('0x00F7','÷','c3 b7','DIVISION SIGN'),
                    ('0x00F8','ø','c3 b8','LATIN SMALL LETTER O WITH STROKE'),
                    ('0x00F9','ù','c3 b9','LATIN SMALL LETTER U WITH GRAVE'),
                    ('0x00FA','ú','c3 ba','LATIN SMALL LETTER U WITH ACUTE'),
                    ('0x00FB','û','c3 bb','LATIN SMALL LETTER U WITH CIRCUMFLEX'),
                    ('0x00FC','ü','c3 bc','LATIN SMALL LETTER U WITH DIAERESIS'),
                    ('0x00FD','ý','c3 bd','LATIN SMALL LETTER Y WITH ACUTE'),
                    ('0x00FE','þ','c3 be','LATIN SMALL LETTER THORN'),
                    ('0x00FF','ÿ','c3 bf','LATIN SMALL LETTER Y WITH DIAERESIS')
                )

                foreach ($Stat in $CollectionStats)
                {
                    [pscustomobject]@{
                        "Name"= $Stat[3];
                        "Character"= $Stat[1];
                        "Unicode Code Point"=$Stat[0]
                        "UTF-8 (hex.)"=$Stat[2]
                    }
                }
            }
        }
    
    }
    End
    {
    }
}

Configuration NLB {
    
    Node s3 {

        WindowsFeature NEwNLB {
            Name='NLB'
            Ensure = 'Present'

        }
    }

}
NLB -outputpath C:\DSCSMB


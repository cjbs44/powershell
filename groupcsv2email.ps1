 $usercsv = import-csv 4ggacanousers.csv
  
 $resultsfile = "resultsacano.csv"
 $resultsfilebanner = "Results are below...."

 $resultsfilebanner > $resultsfile



 foreach($user in $usercsv)
  
   {
  
   $samaccountname = $user.SamAccountName

   $email = ""
  
    $strFilter = "(samaccountname=$samaccountname)"

    $objDomain = New-Object System.DirectoryServices.DirectoryEntry
    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = $objDomain
    $objSearcher.PageSize = 1000
    $objSearcher.Filter = $strFilter
    $objSearcher.SearchScope = "Subtree"

    $colProplist = "mail"
 #   foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)}
 $objSearcher.PropertiesToLoad.mail
    $colResults = $objSearcher.FindAll()

    foreach ($objResult in $colResults)
   {
   $objItem = $objResult.Properties; $objItem.mail
   $email = $objItem.mail
   }
  
   Echo "$samaccountname,$email" >> $resultsfile
  
   }
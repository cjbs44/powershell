 $usercsv = import-csv users.csv
  
 $resultsfile = "results.csv"
 $resultsfilebanner = "Results are below...."

 $resultsfilebanner > $resultsfile



 foreach($user in $usercsv)
  
   {
  
   $first = $user.First
  
   $last = $user.Last

   $last2 = $user.Last2

   $email = ""
  
    $strFilter = "(&(objectCategory=User)(sn=$last)(givenName=$first))"

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
  
   Echo "$first, $last, $last2, $email" >> $resultsfile
  
   }
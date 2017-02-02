$users = Get-ADUser -Filter { Enabled -eq $true } -Properties telephonenumber, mail
$pnum = @{}; $users | ForEach-Object { if($_.telephonenumber) { $pnum[$_.telephonenumber] += 1 } }
$filteredUsers = $users | Where-Object { if($_.telephonenumber) { $pnum[$_.telephonenumber] -gt 1 } }
$filteredUsers | Select-Object -Property SamAccountName, mail, telephonenumber | Sort-Object telephonenumber | Export-Csv duplicatephonenumbers.csv

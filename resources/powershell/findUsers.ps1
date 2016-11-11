Param(
  Parameter(Mandatory=$True]
   [string[]]$users
)
$emailRegex = "\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
$filter =
[scriptblock]::create(($users| foreach {"(mail -eq '$_')"}) -join ' -or ')
Get-ADUser -f $filter

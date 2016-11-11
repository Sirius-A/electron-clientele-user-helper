Param(
   [Parameter(Mandatory=$True)]
   [string[]] $users
)


Function Construct-Filter
{
  Param
  (
    # List of, e-mail adrsses and GID's
    [Parameter(Mandatory=$true)]
    [String[]]$users
  )
  [string]$filter = "(&(objectClass=User)(| "

  $emailRegex = "\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
  $GIDRegex = "^[\w\d]*$"
  $winCredentialsRegex = "^[\w\d]*\\[\w\d]*$"

  foreach ($user in $users)
  {
    if ($user -match $emailRegex){
      $filter = "$filter(mail=$user)"
    }elseif($user -match $GIDRegex){
      $filter = "$filter(siemens-gid=$user)"
    }elseif($user -match $winCredentialsRegex){
      $username = $user.Split("\")[1]
      $filter = "$filter(samaccountname=$username)"
    }else{
      Write-host "Error finding pattern for $user" -ForegroundColor Red
    }
  }

  return "$filter))" #Close final bracket   and return string
}

$searchfilter = Construct-Filter $users

$searcher = [adsisearcher]""
$searcher.filter = $searchfilter
$searcher.PropertiesToLoad.addRange(("siemens-gid",
"displayname",
"employeetype",
"department",
"givenname",
"sn",
"displaynameprintable",
"samaccountname",
"mail",
"objectcategory",
"telephonenumber"
))
$searcher.findAll()

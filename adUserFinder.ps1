<#
.SYNOPSIS
  Searches users in the Active Directory and export their details into an XML File

.DESCRIPTION
  Generates a human-readable XML file with details of Active Directory user
  Accepts GIDs, e-mail addresses or Windows credentials to find the desired users.

  If the script was unable to find certain users, it will write their IDs into the console.

.PARAMETER users
  One or muliple IDs of users.
  Accepts det ID Formats
    - GID                 (Example: Z002MKUM)
    - e-mail address      (Example: fabio.zuber@siemens.com)
    - Windows credential  (Example: AD001\Z002MKUM)

.PARAMETER filePath
  Name or path of the export XML file. (Absolute or realtive paths are both allowed)

  Default: Current_directory/ADUserData.xml

.EXAMPLE
    ./adUserFinder.ps1 fabio.zuber@siemens.com, Z00232EP

    Looks for the users of Marko Ivic and Fabio Zuber and exports their details to ./ADUserData.xml
.EXAMPLE
  ./adUserFinder.ps1 -Users fabio.zuber@siemens.com, Z00232EP, AD001\mullersv -FilePath C:\Temp\UserData.xml

  Creates and XML file in C:\Temp\UserData.xml which contains the user Details for the 3 Users
#>

#-------------------------------------------------------------------------------
# Main parameters
#------------------------------------------------------------------------------
Param(
   [Parameter(Mandatory=$True)]
   [String[]] $users,
   [String]$filePath = "ADUserData.xml" # Set the File Name
)

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
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
      Write-host "Invalid user input: $user" -ForegroundColor Red
    }
  }

  return "$filter))" #Close final bracket   and return string
}

function Search-Users
{
  Param
  (
    # List of, e-mail adrsses and GID's
    [string]$LDAPSearchRoot,
    [String]$searchfilter,
    [String[]]$PropertiesToLoad
  )

  $searcher = [adsisearcher]$LDAPSearchRoot
  $searcher.filter = $searchfilter
  $searcher.PropertiesToLoad.addRange($PropertiesToLoad)

  return $searcher.findAll()
}

Function Validate-Results{
  Param
  (
    #The Users that were originally requested by the user
    [String[]]$requestedUsers,
    #List of Users that were found in the AD
    $foundUsers
  )

  [System.Collections.ArrayList]$requestedUserList = New-Object System.Collections.ArrayList
  $requestedUserList.addRange($requestedUsers)
  #[System.Collections.ArrayList]$requestedUserList = $requestedUsers

  #Quick check (compare lengths)
  if($foundUsers.Length -eq $requestedUsers.Length){
    #everytng ok :D we can leave here
    return
  }

  #if the legths are different, search for the users that were not found
  Foreach ($user in $foundUsers)
  {
    [String]$samaccountname = $user.Properties.samaccountname
    $samaccountname = $samaccountname.ToUpper()
    [String]$gid = $user.Properties.'siemens-gid'
    $gid = $gid.toUpper()
    [String]$email = $user.Properties.mail
    $email = $email.toLower()

    if ($requestedUsers -contains $gid){
      $requestedUserList.Remove($gid)
    }elseif ($requestedUsers -contains $email){
      Write-host "mail"$email
      $requestedUserList.Remove($email)
    }elseif ($requestedUsers -like "*$samaccountname" ){
      $compareResult = $requestedUsers -like "*$samaccountname"
      $index = $requestedUserList.IndexOf($compareResult)
      $requestedUserList.RemoveAt($index)
    }
  }
  return ,$requestedUserList #Use comma in return statement to prevent type conversion
}

Function Out-XML
{
  Param
  (
    # List of, e-mail adrsses and GID's
    [Parameter(Mandatory=$true)]
    $foundUsers,
    [String]$filePath
  )
  # Create The Document
  $XmlWriter = New-Object System.XMl.XmlTextWriter($filePath,$Null)

  # Set The Formatting
  $xmlWriter.Formatting = "Indented"
  $xmlWriter.Indentation = "4"

  # Write the XML Decleration
  $xmlWriter.WriteStartDocument()

  # Write Root Element
  $xmlWriter.WriteStartElement("People")

  Foreach ($foundUser in $foundUsers)
  {
    $xmlWriter.WriteStartElement("Person")
    foreach ( $UserProperty in $foundUser.Properties.GetEnumerator()){
      $xmlWriter.WriteElementString($UserProperty.Name,$UserProperty.Value)

      if ($UserProperty.Name -eq "distinguishedname") {
        $DomainName = $UserProperty.Value -Split "DC="
        $DomainName = $DomainName[1].replace(',','')
        $xmlWriter.WriteElementString("DomainName", $DomainName.ToUpper())
      }
    }
    $xmlWriter.WriteEndElement() # <-- Closing Person
  }
  $xmlWriter.WriteEndElement() # <-- Closing People

  # End the XML Document
  $xmlWriter.WriteEndDocument()

  # Finish The Document
  $xmlWriter.Finalize
  $xmlWriter.Flush()
  $xmlWriter.Close()
} #End function Out-XML


#-------------------------------------------------------------------------------
# Main script
#-------------------------------------------------------------------------------

# handle relative Paths for export file
if($FilePath -NotMatch "\w:[\\|\/]"){
  $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
  $FilePath = "$scriptPath/$FilePath"
}

#region AD search
$PropertiesToLoad = @(
  "siemens-gid",
  "displayname",
  "employeetype",
  "department",
  "givenname",
  "sn",
  "displaynameprintable",
  "samaccountname",
  "mail",
  "objectcategory",
  "telephonenumber",
  "mobile",
  "distinguishedname"
)

$searchfilter = Construct-Filter $users

if ($searchfilter -eq "(&(objectClass=User)(| ))"){
  Write-host "No Valid Users in input; abort" -ForegroundColor Red
  return
}

$searchResults = Search-Users "LDAP://DC=siemens,DC=net" $searchfilter $PropertiesToLoad
#endregion AD search

#Find requested user not found in the AD
$missingUsers = Validate-Results -requestedUsers $users -foundUsers $searchResults

#Region console output
$searchResultsOutput = $searchResults | select -Expand Properties |
    select @{n='Display Name';e={$_.displaynameprintable}}, @{n='Windows username';e={$_.samaccountname}}, @{n='E-mail address';e={$_.mail}},
    @{n='GID';e={$_."siemens-gid"}}

$searchResultsOutput | Format-Table | Out-String |% {Write-Host $_}

if($missingUsers.Count -gt 0){
Write-Host "Users not found in AD:" -ForegroundColor Red
  Foreach ($userNotFound in $missingUsers)
  {
    Write-Host $userNotFound
  }
}
#Endregion console output

if ($searchResults.Count -gt 0 -or $searchResults.Properties.Count -gt 0){
  Out-XML $searchResults $filePath
  Write-host "Detailed results exported to $filePath" -ForegroundColor Green
}else{
  Write-host "No user found; no XML file was created" -ForegroundColor Yellow
}
return $searchResults

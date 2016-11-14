Param(
   [Parameter(Mandatory=$True)]
   [string[]] $users,
   [String]$filePath = $MyInvocation.MyCommand.Path+"test.xml" # Set the File Name
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
}

if($FilePath -NotMatch "\w:[\\|\/]"){
  $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
  $FilePath = "$scriptPath/$FilePath"
}

$searchfilter = Construct-Filter $users
$PropertiesToLoad = @("siemens-gid",
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
"mobile"
)

$searcher = [adsisearcher]""
$searcher.filter = $searchfilter
$searcher.PropertiesToLoad.addRange($PropertiesToLoad)

$results = $searcher.findAll()

Out-XML $results $filePath

return $results

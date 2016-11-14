[![](https://img.shields.io/badge/license-Siemens%20Inner%20Source-blue.svg)](LICENSE.md)

# Powershell Active Directory User Export

## Download

### Via [Git](https://www.atlassian.com/git/tutorials/what-is-git)
If you have Git installed, you can get the content of this repo by using git clone.
~~~~bash
git clone git@code.siemens.com:gs-it-bt/ps-aduser-export-xml.git
cd ./ps-aduser-export-xml
~~~~

### Manual Download
Click on the "Download ZIP" button on the home page of this repository. Extract the content of the zip anywhere you like.

## Usage
Use Powershell to execute the adUserFinder script.
The [Script](adUserFinder.ps1) takes 2 arguments:
 * **Users**: List of E-Mail Adresses, GIDs or Domain\User Credentials of the desired users
 * **FilePath**: Path of the export xml file (default = *currentDir*/ADUserData.xml)

### Example
The example below shows 3 different ways to get user details (for the same user). The XML File with the user data will be placed in the current directory.
~~~~powershell
./adUserFinder.ps1 -Users fabio.zuber@siemens.com, Z002MKUM, AD001\Z002MKUM -FilePath "./UserExport.xml"
~~~~

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
The [Script](adUserFinder.ps1) take 2 arguments
 * **Users**: List of E-Mail Adresses, GIDs or Domain\User Credentials of the desired users
 * **FilePath**: Path of the export xml file (default = *currentDir/ADUserData.xml*)


~~~~bash
./adUserFinder.ps1 -Users fabio.zuber@siemens.com, Z002MKUM, AD001\Z002MKUM
~~~~
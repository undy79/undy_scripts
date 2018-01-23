# Copied from a bunch of internet scripts
# Adds a new local windows user and puts that user into the local Administrators group

$Computername = $env:COMPUTERNAME
$ADSIComp = [adsi]"WinNT://$Computername"

# Create Username
$Username = Read-Host -Prompt "Enter username"
$NewUser = $ADSIComp.Create('User',$Username)  

#Create password 
$Password = Read-Host -Prompt "Enter password for $Username" -AsSecureString
$BSTR = [system.runtime.interopservices.marshal]::SecureStringToBSTR($Password)

$_password = [system.runtime.interopservices.marshal]::PtrToStringAuto($BSTR)
#Set password on account 
$NewUser.SetPassword(($_password))
$NewUser.SetInfo()

$group = [ADSI]"WinNT://$Computername/Administrators,group"
$group.Add("WinNT://$ComputerName/$Username,user")

#Cleanup 
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR) 
Remove-Variable Password,BSTR,_password 

$xml = '

  <QueryList>

  <Query  Id="0" Path="Security">

  <Select  Path="Security">*[System[(EventID=4720)]]</Select>

  </Query>

  </QueryList>

  ' 
  Get-WinEvent -FilterXml  $xml |  Select -Expand Message

# AD-SQL Restore

Clear-Host

New-ADOrganizationalUnit -Name finance -ProtectedFromAccidentalDeletion $False

$NewAD = Import-CSV $PSScriptRoot\financePersonnel.csv
$Path = "OU=finance,DC=anycompany,DC=com"

foreach ($ADUser in $NewAD)
{

$First = $ADUser.fname
$Last = $ADUser.Lname
$Name = $First + " " + $Last
$City = $ADUser.City
$County = $ADUser.County
$PostalCode = $ADUser.PostalCode
$Office = $ADUser.OPhone
$Mobile = $ADUser.MobilePhone

New-ADUser -GivenName $First -Surname $Last -Name $Name -DisplayName $Name -City $City -State $County -PostalCode $PostalCode -OfficePhone $Office -MobilePhone $MobilePhone -Path $Path
}



Import-Module -Name sqlps -DisableNameChecking -Force

##Create object for SQL connection
$srv = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList ucertify1
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $srv, ClientDB
$db.Create()

Invoke-Sqlcmd -ServerInstance anycompany1 -Database ClientDB -InputFile $PSScriptRoot\Contacts.sql

$table = 'Client_A_Contacts'
$db = 'ClientDB'

Import-CSV $PSScriptRoot\NewClientData.csv | ForEach-Object {Invoke-Sqlcmd -Database ClientDB -ServerInstance anycompany1 -Query "insert into $table (first_name,last_name, city, county, zip, officePhone, mobilePhone) VALUES `
('$($_.first_name)','$($_.last_name)','$($_.city)','$($_.county)','$($_.zip)','$($_.officePhone)','$($_.mobilePhone)')"
}


try {

# AD-SQL Restore

Clear-Host

New-ADOrganizationalUnit -Name finance -ProtectedFromAccidentalDeletion $False

$NewAD = Import-CSV $PSScriptRoot\financePersonnel.csv
$Path = "OU=finance,DC=anycompany,DC=com"

foreach ($ADUser in $NewAD)
{

$First = $ADUser.fname
$Last = $ADUser.Lname
$Name = $First + " " + $Last
$City = $ADUser.City
$County = $ADUser.County
$PostalCode = $ADUser.PostalCode
$Office = $ADUser.OPhone
$Mobile = $ADUser.MobilePhone

New-ADUser -GivenName $First -Surname $Last -Name $Name -DisplayName $Name -City $City -State $County -PostalCode $PostalCode -OfficePhone $Office -MobilePhone $MobilePhone -Path $Path
}



Import-Module -Name sqlps -DisableNameChecking -Force

##Create object for SQL connection
$srv = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList ucertify1
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $srv, ClientDB
$db.Create()

Invoke-Sqlcmd -ServerInstance anycompany1 -Database ClientDB -InputFile $PSScriptRoot\Contacts.sql

$table = 'Client_A_Contacts'
$db = 'ClientDB'

Import-CSV $PSScriptRoot\NewClientData.csv | ForEach-Object {Invoke-Sqlcmd -Database ClientDB -ServerInstance anycompany1 -Query "insert into $table (first_name,last_name, city, county, zip, officePhone, mobilePhone) VALUES `
('$($_.first_name)','$($_.last_name)','$($_.city)','$($_.county)','$($_.zip)','$($_.officePhone)','$($_.mobilePhone)')"
}

}
Catch [System.OutOfMemoryException] {
    Write-Output "OutOfMemoryException occured."
}
Catch {
    Write-Output "Something else happened: $($_.Exception.message)"
}
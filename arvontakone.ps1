$countOfLicenses=9
$licenseHolders = "Thu Nguyen","Markus Lauttia","Tamara Tomilova","Hanna-Leena Lindblom","Matan Shenhav","Nikolai Koudelia","Rasmus Blässar","Stephen Montgomery","Kim Wallis"

$studyGroups = @{}
for ($i=1; $i -le $countOfLicenses; $i++) 
{
    New-Variable -Name "studyGroup$i" -Value (new-object -TypeName "System.Collections.ArrayList") -Force
    $studyGroups[$i] =  Get-Variable -Name "studyGroup$i"
}

#add license holders to study groups
$licenseHolders | foreach {$studyGroups[$licenseHolders.IndexOf($_.ToString())+1].Value.Add($_.ToString())}

[System.Collections.ArrayList]$productUsers = Get-ADGroupMember -identity "SievoEngineering" -Recursive | select -expandproperty name

#remove stale users from user list 
$productUsers.Remove("Moramay Barinoff")
$productUsers.Remove("Antti Matikainen")
$productUsers.Remove("Pasi Viljanen")
$productUsers.Remove("Yuri Kazarov")
$productUsers.Remove("Silke Karner")
$productUsers.Remove("Tiia Halme")
$productUsers.Remove("Dursunali Keskin")
$productUsers.Remove("Maria Lahtinen")

#remove license holders from user list
$licenseHolders | foreach {$productUsers.Remove($_.ToString())}

#assign users to groups randomly
$numberofUsersToAssign = ($productUsers | measure-object).Count
for ($i=1; $i -le $numberofUsersToAssign; $i++) 
{
    $person = Get-Random -InputObject $productUsers
    $studyGroups[$i%$countOfLicenses+1].Value.Add($person)
    $productUsers.Remove($person)
}


#print out the results
for ($i=1; $i -le $studyGroups.Count; $i++) 
{
    write-host "Group $i"
    write-host "--------"
    $studyGroups[$i].Value
    write-host "--------"
    write-host ""
}






$csvPath = "C:\ICE\Scripts\Log\~Output.csv"

$currentDate = (Get-Date).AddDays(-0).Date

# Define the start and end time range 
$startTime = Get-Date -Year $currentDate.Year -Month $currentDate.Month -Day $currentDate.Day -Hour 00 -Minute 0 -Second 1
$endTime = Get-Date -Year $currentDate.Year -Month $currentDate.Month -Day $currentDate.Day -Hour 23 -Minute 59 -Second 59


# Get all user accounts in Active Directory
$users = Get-ADUser -Filter * -Properties LastLogonDate, Name, Displayname -SearchBase "OU=SMCH,DC=smch,DC=int" -SearchScope Subtree | Where-Object { $_.Enabled -eq $true -and $_.LastLogonDate -ge $startTime -and $_.LastLogonDate -lt $endTime }

# Create an array to store user objects with last login information
$userObjects = @()

foreach ($user in $users) {
   # Retrieve the last login date and time
   $lastLogin = $user.LastLogonDate

   # Create a custom object with user details
   $userObject = [PSCustomObject]@{
       UserName = $user.SamAccountName
       Firtname = $user.givenname
       LastName = $user.surname
       LastLogin = $lastLogin
   }

   # Add the user object to the array
   $userObjects += $userObject
}

# Export the user objects to a CSV file
$userObjects | Export-Csv -Path $csvPath -NoTypeInformation -Force
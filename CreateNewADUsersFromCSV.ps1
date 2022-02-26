# Create AD users from .csv file

# Import modules
Import-Module ActiveDirectory

# Create inital password
$securePassword = ConvertTo-SecureString "CreateYourOwnp@ssw0rd!" -AsPlainText -Force

# Prompt user to enter full CSV file path
$filepath = Read-Host -Prompt "Please enter full file path to user csv" 

# Import csv file
$ADusers = Import-Csv $filepath -Delimiter ";"


# Loop through CSV file
ForEach ($user in $ADusers) {

    # Read data and assign variable
    $firstname = $user.'First Name'
    $lastname = $user.'Last Name'
    $initials = $user.initials
    $OUpath = $user.'Organizational Unit'
    $manager = $user.manager
    $telephone = $user.telephone
    $company = $user.company
    $jobTitle = $user.'Job Title'
    $description = $user.Description
    $dept = $user.Department
    $streetaddress = $user."Street Address"
    $city = $user.City
    $state = $user.State
    $zipcode = $user.Zipcode
    $country = $user.Country
    $UPN = $user.UPN    
 

    # Check to if user already exisit in Active Diretory
    if(Get-ADUser -Filter "SamAccountName -eq '$firstname.$lastname'")  {
        #If user exist, Warning.
        Write-Warning "$firstname.$lastname already exist in Active Directory."
    }
    else {

        # Create new AD user
        New-ADUser `
            -SamAccountName "$firstname.$lastname" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Initials $initials `
            -DisplayName "$firstname $lastname" `
            -UserPrincipalName "$firstname.$lastname@$UPN" `
            -Title $jobTitle `
            -Description $description `
            -Department $dept `
            -EmailAddress $email `
            -OfficePhone $telephone `
            -Company $company `
            -StreetAddress $streetaddress `
            -city $city `
            -State $state `
            -PostalCode $zipcode `
            -Country $country `
            -Path $OUpath `
            -Manager $manager `
            -AccountPassword $securePassword `
            -ChangePasswordAtLogon $true `
            -Enabled $true 


             #Write output
            Write-host  "Account created for $firstname.$lastname"
    }
}
Read-Host -Prompt "Press any key to exit" 
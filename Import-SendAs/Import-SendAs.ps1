Param(
    [string]$CsvPath="SendAs.csv"
)

$Mbxs = Get-Mailbox -ResultSize unlimited
$Permissions = Import-Csv $CsvPath

foreach ($Permission in $Permissions) {
    if ($Permission.Trustee -like "*;*") {
        $Trustees = $Permission.Trustee.Split(";")
        foreach ($Trustee in $Trustees) {
            write-host "Granting $($Trustee) the ability to send as $($Permission.Identity)" -ForegroundColor Green
            Add-RecipientPermission $Permission.Identity -AccessRights SendAs -Trustee $Trustee -Confirm:$false
        }
    } else {
        write-host "Granting $($Permission.Trustee) the ability to send as $($Permission.Identity)" -ForegroundColor Green
        Add-RecipientPermission $Permission.Identity -AccessRights SendAs -Trustee $Permission.Trustee -Confirm:$false
    }
}

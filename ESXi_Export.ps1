# Import the VMware PowerCLI module
try {
    Import-Module -Name VMware.PowerCLI -ErrorAction Stop
} catch {
    Write-Error "Failed to import the VMware PowerCLI module. Please ensure it's installed."
    exit 1
}

# Suppress the certificate warning
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false | Out-Null

# Server credentials
$server = "FQDN_or_IP_Address"
$user = "user_name"
$pass = ConvertTo-SecureString -String "Password" -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass

# Connect to the ESXi Server
try {
    Connect-VIServer -Server $server -Credential $cred -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to the server $server"
    exit 1
}

# Retrieve and export the VM information
try {
    Get-VM | Export-Csv -Path "C:\VMs-$server-Listing.csv" -NoTypeInformation -UseCulture
} catch {
    Write-Error "Failed to retrieve VM information or export to CSV"
} finally {
    # Always disconnect to clean up session
    Disconnect-VIServer -Confirm:$false -ErrorAction SilentlyContinue
}

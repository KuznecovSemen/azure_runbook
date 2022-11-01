Param(
		
		[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
        [String]
        $AzureFirewallName = "test-fw",
		
		[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] 
        [String]
        $AzureFirewallResourceGroup = "test-fw"
		)

"Please enable appropriate RBAC permissions to the system identity of this automation account. Otherwise, the runbook may fail..."

try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

#Get all ARM resources from all resource groups
$ResourceGroups = Get-AzResourceGroup

foreach ($ResourceGroup in $ResourceGroups)
{    
    Write-Output ("Showing resources in resource group " + $ResourceGroup.ResourceGroupName)
    $Resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
    foreach ($Resource in $Resources)
    {
        Write-Output ($Resource.Name + " of type " +  $Resource.ResourceType)
    }
    Write-Output ("")
}

$azfw = Get-AzFirewall -Name $AzureFirewallName -ResourceGroupName $AzureFirewallResourceGroup

$azfw.Deallocate()

Set-AzFirewall -AzureFirewall $azfw
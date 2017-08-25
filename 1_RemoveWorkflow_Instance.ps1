Add-PsSnapin Microsoft.SharePoint.PowerShell -erroraction silentlycontinue 

$siteAddress = 'Give the site address'

[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.WorkflowServices.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll")

$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($siteAddress)
$clientWeb = $clientContext.Web
        
$wfm = New-Object Microsoft.SharePoint.Client.WorkflowServices.WorkflowServicesManager -ArgumentList $clientContext, $clientWeb
$wfDeploymentService = $wfm.GetWorkflowDeploymentService();
$showOnlyPublishWorkflows = $true;
$definitions = $wfDeploymentService.EnumerateDefinitions($showOnlyPublishWorkflows);
$clientContext.Load($definitions);
$clientContext.ExecuteQuery();
        
$workflowtobedeleted = "name of the workflow"
        
foreach($def in $definitions)
{
    if($def.DisplayName -eq $workflowtobedeleted )
    {
            Write-Host "Workflow Name - To Be Deleted : " $def.DisplayName
            Write-Host "Workflow ID - To Be Deleted : " $def.Id -ForegroundColor yellow
            $workflowID = $def.Id
    }
}
       
Write-Host "Getting all the workflow subscriptions" -ForegroundColor Yellow

$wfSubscriptionService = $wfm.GetWorkflowSubscriptionService();
$clientContext.Load($wfSubscriptionService)
$clientContext.ExecuteQuery()
       
$workflowAssociations = $wfSubscriptionService.EnumerateSubscriptionsByDefinition($workflowID);
$clientContext.Load($workflowAssociations);
$clientContext.ExecuteQuery();
        
if($workflowAssociations -ne $null)
{
    foreach($wfa in $workflowAssociations)
    { 
        Write-Host "Worfklow Instance to be deleted : " $wfa.Name
        $wfSubscriptionService.DeleteSubscription($wfa.Id)
        $clientContext.ExecuteQuery()
        Write-Host "Deleted workflow subscription : " $wfa.Name -ForegroundColor Green
    }
}
else
{
    Write-Host "Workflow subscription not found" -ForegroundColor Cyan
    break
}
        

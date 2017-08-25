Add-PsSnapin Microsoft.SharePoint.PowerShell -erroraction silentlycontinue 
$siteAddress = 'name of the site'
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.WorkflowServices.dll")
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll")
$ListName = "SharePoint List name" 
#Get Web and List objects 

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
        Write-Host "Workflow Name:" $def.DisplayName
        Write-Host "Workflow ID:" $def.Id -ForegroundColor Green
        $workflowID = $def.Id
    }
}

$wfDeploymentService.DeleteDefinition($workflowID)
$clientContext.ExecuteQuery()

Write-Host "Deleted the workflow definition" -ForegroundColor Green 
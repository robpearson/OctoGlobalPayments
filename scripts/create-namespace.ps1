param(
    [string]$namespace
)


# Get existing namespaces
Write-Host "Retrieving new test"
$namespaces = (kubectl get namespaces -o JSON | ConvertFrom-Json)

# Check to see if namespace exists
if ($null -eq ($namespaces.Items | Where-Object {$_.metadata.name -eq $namespace}))
{
	# Create the namespace
    Write-Host "Namespace $namespace doesn't exist, creating ..."
    kubectl create namespace $namespace
}
else
{
	Write-Host "Namespace $namespace already exists, moving on ..."
}
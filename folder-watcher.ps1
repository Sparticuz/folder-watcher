# Parameters
param (
    [Parameter(Mandatory=$true)][string]$folder = "", # Enter the root path you want to monitor.
    [string]$filter = '*.*', # You can enter a wildcard filter here.
    [bool]$includesubdir = $true, # In the following line, you can change 'IncludeSubdirectories to $false if required.
    [Parameter(Mandatory=$true)][string]$slackUri = "",
    [Parameter(Mandatory=$true)][string]$slackChannel = "",
    [bool]$fsCreated = $true,
    [bool]$fsDeleted = $true,
    [bool]$fsChanged = $true
)

if(-Not (Test-Path $folder)){
    Throw "$folder does not exist."
}

Import-Module .\PSSlack\PSSlack.psm1
# Set up Slack parameters
$slack = [PSCustomObject]@{
    uri = $slackUri
    channel = $slackChannel
    username = "Resilio Sync"
    icon = ":dart:"
}

$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $includesubdir;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

# Here, all three events are registerd.  You need only subscribe to events that you need:

if($fsCreated){
    Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -MessageData $slack -Action {
    $name       = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp  = $Event.TimeGenerated
    $slack      = $Event.MessageData
    #Write-Host "The file '$name' was $changeType at $timeStamp" -fore green
    Send-SlackMessage   -Uri $slack.uri `
                        -Channel $slack.channel `
                        -Parse full `
                        -Username $slack.username `
                        -IconEmoji $slack.icon `
                        -Text "The file '$name' was $changeType at $timeStamp"
    }
}

if($fsDeleted){
    Register-ObjectEvent $fsw Deleted -SourceIdentifier FileDeleted -MessageData $slack -Action {
    $name = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    $slack = $Event.MessageData
    #Write-Host "The file '$name' was $changeType at $timeStamp" -fore red
    Send-SlackMessage   -Uri $slack.uri `
                        -Channel $slack.channel `
                        -Parse full `
                        -Username $slack.username `
                        -IconEmoji $slack.icon `
                        -Text "The file '$name' was $changeType at $timeStamp"
    }
}

if($fsChanged){
    Register-ObjectEvent $fsw Changed -SourceIdentifier FileChanged -MessageData $slack -Action {
    $name = $Event.SourceEventArgs.Name
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    $slack = $Event.MessageData
    #Write-Host "The file '$name' was $changeType at $timeStamp" -fore white
    Send-SlackMessage   -Uri $slack.uri `
                        -Channel $slack.channel `
                        -Parse full `
                        -Username $slack.username `
                        -IconEmoji $slack.icon `
                        -Text "The file '$name' was $changeType at $timeStamp"
    }
}
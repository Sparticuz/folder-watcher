$selection = Get-EventSubscriber

if($selection.Count -gt 1){
    $title = "Event Selection"
    $message = "Which event would you like to unsubscribe from?"

    $choices = @()
    for($index = 0; $index -lt $selection.Count; $index++){
        $choices += New-Object System.Management.Automation.Host.ChoiceDescription ($selection[$index].SourceIdentifier),($selection[$index].SourceIdentifier)
    }
    $choices += New-Object System.Management.Automation.Host.ChoiceDescription "All","Delete All Events"

    $options = [System.Management.Automation.Host.ChoiceDescription[]]$choices
    $result = $host.UI.PromptForChoice($title, $message, $options, 0)

    if($result -eq $selection.count){
        $selection = $selection
    } else {
        $selection = $selection[$result]
    }

}

foreach($evt in $selection){
    Write-Host "$evt.SourceIdentifier removed"
    Unregister-Event $evt.SourceIdentifier
}
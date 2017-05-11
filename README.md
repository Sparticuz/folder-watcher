# Folder Watcher & PSSlack

This script uses [Powershell FileSystemWatcher](https://gallery.technet.microsoft.com/scriptcenter/Powershell-FileSystemWatche-dfd7084b#content) and [PSSlack](https://github.com/RamblingCookieMonster/PSSlack) to post folder status updates to a Slack channel.

## To Run
folder-watcher.ps1 can be run with the following parameters
 * -folder #Enter the root path you want to monitor.
 * -filter #You can enter a wildcard filter here.
 * -includesubdir #$true or $false
 * -slackUri #The Slack URI, add one [here](https://my.slack.com/apps/A0F7XDUAZ)
 * -slackChannel #The channel or dm of the message

## To stop
run folder-unwatcher.ps1 to unregister the Watchers
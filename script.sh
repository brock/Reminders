#!/bin/bash
# This script creates a "cronjob" using MacOSX's preferred "launchd"
# Convert minutes to seconds, then create a one-time cron that
# simply calls up a sticky growlnotify with your reminder. 

MINUTES=$1
TIMER=$(($1 * 60))
GROWL=/usr/local/bin/growlnotify
shift
REMINDER=$*
echo "$MINUTES minute reminder:"
echo "$REMINDER"

cat > ~/Library/LaunchAgents/com.approductive.remindersapp.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.approductive.remindersapp</string>
	<key>ProgramArguments</key>
	<array>
		<string>$GROWL</string>
		<string>-s</string>
		<string>--image</string>
		<string>$HOME/Library/Application Support/Alfred/extensions/scripts/Reminders/reminders.png</string>
		<string>-m</string>
		<string>$REMINDER</string>
		<string>-t</string>
		<string>Reminders</string>
	</array>
	<key>StartInterval</key>
	<integer>$TIMER</integer>
	<key>RunAtLoad</key>
	<false/>
	<key>LaunchOnlyOnce</key>
	<true/>
	<key>OnDemand</key>
	<true/>
</dict>
</plist>
EOF
chmod +x ~/"Library/Application Support/Alfred/extensions/scripts/Reminders/show_reminder.sh"
launchctl load ~/Library/LaunchAgents/com.approductive.remindersapp.plist
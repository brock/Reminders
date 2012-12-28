#!/bin/bash
# This script creates a "cronjob" using MacOSX's preferred "launchd"
# Convert minutes to seconds, then create a one-time cron that
# simply calls up a sticky growlnotify with your reminder. 


if [[ $1 == "cleanup" ]]; then

	echo "Cleaning up expired reminders..."
	ACTIVE_REMINDERS=($(launchctl list | grep com.approductive.remindersapp | awk '{print $3}'))
	REMINDER_PLISTS=($(command ls ~/Library/LaunchAgents/com.approductive.remindersapp.*))

	total_plists=${#REMINDER_PLISTS[*]}
	for (( i=0; i<=$(( $total_plists -1 )); i++ ))
	do
		trimmed_plist=$(basename ${REMINDER_PLISTS[$i]} | sed 's#.plist##g')
		is_active=$(echo "${ACTIVE_REMINDERS[@]}" | grep -o "$trimmed_plist")
		
		if [[ -z $is_active ]]; then
			rm ${REMINDER_PLISTS[$i]}
		fi
	done
	exit
fi

MINUTES=$1
TIMESTAMP=$(command date +%s)
TIMER=$(($1 * 60))
GROWL=/usr/local/bin/growlnotify
shift
REMINDER=$*
echo "$MINUTES minute reminder:"
echo "$REMINDER"

cat > ~/Library/LaunchAgents/com.approductive.remindersapp.$TIMESTAMP.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.approductive.remindersapp.$TIMESTAMP</string>
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
</dict>
</plist>
EOF
chmod 644 ~/Library/LaunchAgents/com.approductive.remindersapp.$TIMESTAMP.plist
launchctl load ~/Library/LaunchAgents/com.approductive.remindersapp.$TIMESTAMP.plist

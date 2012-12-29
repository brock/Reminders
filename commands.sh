#!/bin/bash

# This captures all the text you specify when creating your reminder
REMINDER=$*

# For some reason, using 'which growlnotify' never worked in tests
# run 'which growlnotify' and put that path here
GROWLNOTIFY=/usr/local/bin/growlnotify

SAY=$(which say)
AFPLAY=$(which afplay)

# This is the default location for the reminders.png file
# Change only if you have moved your Alfred extensions to your Dropbox folder, or somewhere else
REMINDERS_IMAGE="$HOME/Library/Application Support/Alfred/extensions/scripts/Reminders/reminders.png"

# You can choose any audio file for your notification
# Other options typically in this folder (add .aiff): 
# Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping
# Pop, Purr, Sosumi, Submarine, Tink
AUDIO_FILE=/System/Library/Sounds/Basso.aiff

# Mac OSX can also read the reminder out loud in a number of voices
# Just (un)comment the last two lines of this file with your choice
# Female Voices: Agnes, Kathy, Princess, Vicki, Victoria, 
# Male Voices: Bruce, Fred, Junior, Ralph, Albert, 
# Novelty Voices: "Bad News", Bahh, Bells, Boing, Bubbles, Cellos, Deranged, "Good News", Hysterical, "Pipe Organ", Trinoids, Whisper, Zarvox
VOICE="Victoria"

# This is what actually does something. :P

$GROWLNOTIFY -s --image "$REMINDERS_IMAGE" -m "$REMINDER" -t Reminders
# $AFPLAY $AUDIO_FILE
# Uncomment this next line if you would like your reminder spoken to you :P
$SAY -v $VOICE "$REMINDER"
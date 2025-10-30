# Nagios2GoogleChat

Nagios notifications for Google Chat

* Define an incoming webhook in your Room.</br>
(https://developers.google.com/hangouts/chat/how-tos/webhooks)

* Copy the script to your plugin directory. (paths may vary)

* Create gchat.cfg and edit the webhook url and thread key.
(example in gchat.cfg.sample)

* Define the new gchat notification commands in Nagios.
(example in gchat_commands.cfg, modify paths as required)

* Set up a new contact to use the new host and service notification commands.

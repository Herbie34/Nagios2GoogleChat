#!/usr/bin/env bash

# load webhook url and thread id
#url='https://chat.googleapis.com/v1/spaces/xxxxxxxxx/messages?key=xxxxxxxx&token=xxxxxxxx'
#id=spaces/xxxxxxxxx/threads/xxxxxxxx
. $(readlink -f "$(dirname "${BASH_SOURCE:-$0}")/gchat.cfg")

# gchat notification commands
#
# define command {
#   command_name  gchat-service
#   command_line  /usr/lib64/nagios/plugins/gchat_notify.sh "$NOTIFICATIONTYPE$" "$HOSTNAME$" "$HOSTADDRESS$" "$SERVICEDESC$" "$SERVICESTATE$" "$SERVICEOUTPUT$" "$LONGDATETIME$"
# }

json_escape() {
	echo -n "$1" | sed -z \
		-e 's/\\/\\\\/g' \
		-e 's/"/\\"/g' \
		-e 's/\//\\\//g' \
		-e 's/\f/\\f/g' \
		-e 's/\n/\\n/g' \
		-e 's/\r/\\r/g' \
		-e 's/\t/\\t/g' \
		-e 's/[^[:print:]]//g'
}

ntype=$(json_escape "$1")
hname=$(json_escape "$2")
address=$(json_escape "$3")
desc=$(json_escape "$4")
state=$(json_escape "$5")
output=$(json_escape "$6")
dtime=$(json_escape "$7")

# sending notification to gchat
curl -4 -X POST \
	"$url" \
	-H 'Content-Type: text/json; charset=utf-8' \
	-d @- <<-__EOD__
		{
			"thread": {
				"name": "$id"
			},
			"cardsV2": [{
				"card": {
					"header": {
						"title": "$ntype Service Alert",
						"subtitle": "$hname ($address)/$desc is $state"
					},
					"sections": [{
						"widgets": [{
							"decoratedText": {
								"startIcon": {
									"knownIcon": "DESCRIPTION"
								},
								"topLabel": "Info",
								"text": "$output",
								"wrapText": true
							}
						}, {
							"decoratedText": {
								"startIcon": {
									"knownIcon": "CLOCK"
								},
								"topLabel": "DATE/TIME",
								"text": "$dtime"
							}
						}]
					}]
				}
			}]
		}
__EOD__

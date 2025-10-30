#!/usr/bin/env bash

# load webhook url and thread id
. $(readlink -f "$(dirname "${BASH_SOURCE:-$0}")/gchat.cfg")

# gchat notification commands
#
# define command {
#   command_name  gchat-service
#   command_line  $USER1$/gchat_service_notify.sh "$NOTIFICATIONTYPE$" "$HOSTNAME$" "$HOSTADDRESS$" "$SERVICEDESC$" "$SERVICESTATE$" "$SERVICEOUTPUT$" "$LONGDATETIME$"
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

case $state in
	OK)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAG6SURBVFhH1Zc9TsRADIV9BC6WpUCiRJHoERJC4gxsJCoaGlpqLkBDDRINx+AIs/M5OGSJM8kMQYEnPW02/puxPU4i/weHNwdSNbVstvfx90k2Tdij3lNZrbqLAWfqePshx3dBTh+DnD0HuXwLcvXekmvuIUMHXWx+vJDq+lydnTwEuXj5CjhFdLHBFh/ZsF0f3bY784LMIbb4yMoGilXzqqnsp7mU+NCyRJ+zFsFqlwputEXgOwnqRcpmBjd4sgHxie/RntDUx6bJqLnBk7nENzHcUpAeOtczXJLEGJTCdp9z1EpJjEEWmF40iWeQoMGTJdmeivozegQpYYp5ygkaPFmSxNorA3O8YOAYPFmS2owxZgceJgXn3uDJkiQWMTvwx1OcoMGTTfLvLWDVEqzfhOsfw5UHUeEoNniyUbqjGJCSzIeRwZON0n0YActCRjMaPJlLbT5v94ZVX0gMpIcmKZgLo8QXPt3Uf4eWYs2XUoAiqyVlBQOqI7b4wNfs4H1QL5qGzs05ouhig+1kzadg2cAZqWSKsbN+ebjmHjJNd9Qt3vUYcMb00sXwIRofJn3qPZUt/HH6qxDZAcb5llsQD+MQAAAAAElFTkSuQmCC" ;;
	WARNING)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEcSURBVFhHxZFNDsIgEEY5qtck8QoujcvGe9TifBSMxWH4KYxN3qIdms57NWcuZ80FhFv9a7NmAeFW9/L2V+M8/6jg7W/GebQrRPt12VGvEO3X545qhYN9WEC1QmofUanA2kc0KuTsI1MriPaRmRVK9pEpFXL2GIHvZ1Mq5Oxp9LsAMbSC9O8xBunzoRWkf09jfgFiSAXJHuAI4GZDKkj2gI7kFyBOVSjZAxwD3MxzpkLJHtAxeQGiq0KNPcBRwM0+9FSosQd0tLwA0VSh1h7gOOBmB1oq1NoDOl63AFFVocW+mZoKLfY9iBV67PEa4GYsUoUee3qtbQGCrTD136dwFWb/+5RDBW9vjXvdiYcS9C1801fAJuFGnc2a5Q2EDLLcjgOyZgAAAABJRU5ErkJggg==" ;;
	CRITICAL)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAHPSURBVFhH1Zc9TsNAEIV9A5DzQ0kVS1AgGiSgReIacARu5ALS0nAAREGFlJyAmoIiRCmRWPx5Z+X1sk7WiWHDk54SrWfmjWdm13byb5Dv7+zejdLrcdbLx6P0sfhVNeq1HBtsxW1zEIzABWcPh331cjxQrydD9X62pz7ONfnPGtewwRafjRO5zdIbgj0dDdTbaSW4itjigy8xJFw4zF3fH/TLO/OJhBBfYrSqhhZPp5TSLvO6JIZuSzoNSoJsuxI3rJLo5SLjB/2iZF2KGxKT2I0zIX2fuT2fX2bqc/KsFlcXtfVlxBYffO11YqPhbQXlYXJtB0gg8LWYByWBDbYAX/e67I56K8zd+7aaHXBVEiG2aPyoAqcXQ+IaG4YEDrExRAtNkdfl5xTzGRsuE2gjDtGqtYFzPOTA8Qm1FYflMBaaIl9WIHjruYJtxSFaaIq8TsBn2EQ7CdBG3HD7Eojbgi0YwrjbMPpBFP0oBpQk2sMImCq4w/hnj2MQ9YXEgPIwJF0mQSxiekvvQrci4kspkHmI81pug34xNEyub4s2EVuZ9vU+TGyYahCMUnKKcWd2e/jPGtek1918mtkgGKdXmYz+EEWool7r/uP0d5Ek38d32Ps72jRtAAAAAElFTkSuQmCC" ;;
	*)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJQSURBVFhH1Ze9SgNBEMf3EXwEH8FH8AWigmApAXsJiGBpqwmIhY2NYCVYCNoKaVKKgiCCKEEQQQQVRBRB1vtNnHjnzX3sJSL+4U+Sna/dmdm5i/s/mFwbcbVW3U00t6LPtpto+QRlTWR10R0acCaOm49uZtO7uX3v5jveLZ56t3TeI99ZQ4YOutgMvJHaakOcze54t3D8HbCI6GKDLT6Coaee3uidzApShtjiIygbKNZaJ5LKeJqrEh9SlshnqU2w2xLBR1cufX331i8f3guntm9MPaFuAt+5oF6kLCf42HrXt69evIXuw7vILTvxie/MnpDUR01TUHNOCx5fP/ze2bP8Prl9kzXA+sjyhWkrvolhloL00LmWYYwEJPDPIJRD0Ti4S8gSJEaqFHr6EleN2lvrUDNBiSy5kBipLDC9aBLLIIDaG7kbgL1bUf+KHoGUMMUs5QDShIAyWfI+iZUoA3N8kIETkbor8soklGaMYvbBw6Tg3ucx3oBrnQdTJ0FiEbMPfliKJRgPvnX0ZOqYHMYGmH6KoOAwtYEKJdCmYy5Y8kymSlCxCRXjm9emPJPpJqx2DRWWLJfGNQweRIxihSXPZWoQBYzigWmOYkBKSjyMBqb5MAKahYBmVFgyk9J81ukVJV5I4lRYshTxmftCoiA9NEmFuZBJfOHTTP1PSCn+8qUUoMhuSVmFAdUntvjAV+ngcVAvmobODbmi6GKDbWHNi6DZwBmpZIpxsnh5+M4aMkl3pFv51FnAGdNLNsMf0ehhEqesiWzIf05/Fc59AhDWuFIaNKMUAAAAAElFTkSuQmCC" ;;
esac

if "${eval_thread_key:-false}"; then
	thread_key=$(eval echo "$thread_key")
fi

# sending notification to gchat
curl -4 -X POST \
	"$url" \
	-H 'Content-Type: text/json; charset=utf-8' \
	-d @- <<-__EOD__
		{
			"thread": {
				"threadKey": "$thread_key"
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
									"iconUrl": "$icon"
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

#!/usr/bin/env bash

# load webhook url and thread id
. $(readlink -f "$(dirname "${BASH_SOURCE:-$0}")/gchat.cfg")

# gchat notification commands
#
# define command {
#   command_name  gchat-host
#   command_line  $USER1$/gchat_host_notify.sh "$NOTIFICATIONTYPE$" "$HOSTNAME$" "$HOSTADDRESS$" "$HOSTSTATE$" "$HOSTOUTPUT$" "$LONGDATETIME$"
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
state=$(json_escape "$4")
output=$(json_escape "$5")
dtime=$(json_escape "$6")

case $state in
	UP)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAISSURBVFhH7ZaxSwJRHMf9D3JqaGhqCCSwhjZTI2goQYikzSB1ibBBRQPDoUFTajACk3AQtEEUhJZWwRah3MRFAhcHEfwHft339c6sTuvsni194cedd++9z+e9d9yp+89/1Mblcu17PB6S6sntdl9KR7vT6dTz22IjwzOZDBUKBUomkxQKhSAjXkiG53I5qtVqH6parYoVGgdXKk2F1MKVSkGox4cfHy3gnyuRSLAV4YjREQn/VkA0fKzANOAjBaYFB4cj3/OncAQ3y+Uy1et1xcHUlio4ggb9fp9Vt9uldrtNzWZzIiHVcEQWCAaDFIlEKJvNshdIp9NRJTQRHJEFAAQYAhDB9Z8KTQxHpMa9z6BRQrFYbLBdKAgVi8XJ4Qg+EFInO/9gPGGAUUKNRoOd377csMI53vUyGKUKrpSfCsk1LPBruFK+E0qn02LggUDgGOXz+Yz8EguEDKdbtHflIMeRUxw8Ho9TPp8nHKXfvYPgYWnpzHY8c2426mNrtPlsJRx5F20jC1QqFWq1WqwWLrZpPm2muWszA8sCEOLdtA3fghJmD5nZ6Dqt3Ftoo2ZlBYHFOy4UNfUMZza0/bJlmgSDYvn10bUSYIACvvrwJmR5fFuN4S2DvNfrFfO3Hcs+EzUNhABfju982LJUKkV+vz/Cu4jN7onLiOXHrDF7rEI4HIaAnTeZbrBlQp4F7aLTvQKUjCRYWeUnOgAAAABJRU5ErkJggg==" ;;
	DOWN)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAKQSURBVFhH7ZXBixJRHMf9D5Ikgw51adsiqmWDDkHr7lJ42Ay7yNJFYVUWItiDih5cPCyspm2B0WJSHty0whKEThF7kIxAMKFAvEjhxYNM+A/8mu9jZnecfY666nbZL/x4M+PzfT7z3sw83XGOM2ycTqfD7XaTWBWXy/VUbK12u10v/TzZyPBUKkW5XI7i8TgFAgHITF5IhmcyGSqXy11VKpUmK6QF59VYhYaF84ojJEjDa2cccHXFYjE2IxKidyYJ7yswabimwFHAewocFRwcCbmf/wpH8GOhUKBqtcodbNgaCo6gQ6fTYdVut6nZbFK9Xh9Y6OuHd/Rla5Mda8F3pk46dqZOzTCoMrKA3++nUChE6XSafUBarVZfIcBzs+fo/bSBtlcdmnD0eXPBIKSnDfMMLEcWABBgCEAE17WEvhc+MvifG0ZWAKzfM/eEo8/P60ZIEK4xOCJ2FtSgXkKRSGRvuX5lXjMoBv5783SXBA+u7NMlgA1CHNwqbRgVgHoJ1Wo1dvzq90tWvSQAGAjOy6BCcn2ObnAlDgXnpZ9QMplk064Gjgz3+XxrKI/H0/XqQOjy+hItP7eR7ZF974FTT/nI8Gg0StlsltCK58KK/2H+yoZl7cRj04w+MkfmHwuEVvrLgQduLALFYpEajQar81t36WzSRGdemBhYFoCQGo5WeXxoCbHyuHvIGMOLNPtpnm6XF1hB4OJbEy2tXj2w/jjnXRtaQg6eA0y/PjyX14dvCZgFwFc2r3FBYZtFQI1VQhlM+4PlS7s8wLftZ2zJEokExe6bKxOTwMaCbzs+r/LATyx3duUlCwaD5PV6rcrng/spHiWyhPqusGTK11eWQF/ujjhKMOAgd4Q++3Cd7h86C9nsvcyalQAAAABJRU5ErkJggg==" ;;
	*)	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJ3SURBVFhH7ZXPixJhGMe9SZeIHdbASyJsexKkoMOeDIo9bVhCV0dQ6biBih4MD0GJ9gM8LCblwU0pLMFrxB4kIxBEKBAvUnjxIBP+A0/zfZnZHad3Rl2d3ct+4eGdHy/v5zPv+86M7SIXWTbhcFiMRqMkVzcSibySW38wGLyi3LY2KrxcLlO9XqdCoUCpVAoy1gup8Gq1Sp1OZ6ba7ba1QmZwXq1VaFk4rzhCkjK8edYB11c+n2czoiCMYyV8roDVcFOBs4AbCpwVHBwFeZJzhSO42Ww2qdfrcQdbtpaCI+gwnU5ZTSYTGo1GNBgMFhb69ukDfX35jB2bwQ+3NsTDrU0vg2qjCiSTScpkMlSpVNgHZDwezxUCvH7jGn3cFujgkWgKR5/31wWpsi34GFiNKgAgwBCACK6bCf1ofmbwP7ccrAB4cm/XEI4+P286IEG4xuCI3FnSg4yEstns8XL9qr5jUAz8d+fqjAQPru0zI4AfhDy4X/lhdAEyEur3++z47e83rIwkAFgIzsuiQmp9yT3lSpwKzss8oVKpxKZdD1wZnkgk9lGxWGzm1YGQy+VieyIQCBxvOP2UrwzP5XJUq9UIrXwuhUKhhtvt3pdvQ4iB0aI/YolAq9Wi4XDIyuFwkNPpJEEQGFgj4NXD0WqPTy0hVwNPDxm73U4+n49EUWQFAY/HQ3c2L/+3/jjnXVtaQg32gTL9DbkkzALgj2/vcEHPH+5JqLVK6OJ9sHHpiAf4fvCaLVmxWKT8/d2uZRL4seDbjs+rOvCLvbtH6pKl02mKx+N+7f7gfopXiSqhfyosmfb1VSXQl/tHXCUYcJEnQp8TuM32D+NMyUA5/H77AAAAAElFTkSuQmCC" ;;
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
						"title": "$ntype Host Alert",
						"subtitle": "$hname ($address) is $state"
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

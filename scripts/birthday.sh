#!/bin/sh

## OS/ENVIRONMENT INFO DETECTION
ostype="Linux"

kernel="$(uname -r | cut -d'-'  -f1-1)"
version="$(cat /etc/lsb-release | grep DISTRIB_RELEASE | cut -c 18-23)"
uptime="$(uptime -p | cut -c 4- | sed {s/hours/H/} | sed {s/minutes/Mins/} | sed {s/hour/H/})"

## PACKAGE MANAGER AND PACKAGES DETECTION
manager=$(which pacman /usr/sbin/slackpkg yay paru 2>/dev/null)
manager=${manager##*/}
case $manager in
	pacman) packages="$(pacman -Q | wc -l)";;
	yay) packages="$(yay -Q | wc -l)";;
	paru) packages="$(paru -Q | wc -l)";;
	*)
		packages="$(ls /usr/bin | wc -l)"
		manager="bin";;
esac

## RAM DETECTION
case $ostype in
	"Linux")
		while IFS=':k ' read -r key val _; do
			case $key in
				MemTotal)
					mem_used=$((mem_used + val))
					mem_full=$val;;
				Shmem) mem_used=$((mem_used + val));;
				MemFree|Buffers|Cached|SReclaimable) mem_used=$((mem_used - val));;
			esac
		done < /proc/meminfo
		mem_used=$((mem_used / 1024))
		mem_full=$((mem_full / 1024));;
esac
memstat="${mem_used}/${mem_full} MB"

## DEFINE COLORS
bold='[1m'
red='[31m'
green='[32m'
yellow='[33m'
blue='[34m'
magenta='[35m'
cyan='[36m'
white='[37m'
reset='[0m'

## USER VARIABLES -- YOU CAN CHANGE THESE
lc="${reset}${magenta}"  # labels
hn="${reset}${bold}${blue}"     # hostname
ic="${reset}${green}"           # info
c1="${reset}${white}"           # second color
c2="${reset}${yellow}"          # third color

## ROOT DIRECTORY CREATION DATE AND AGE DETECTION
creation_date=$(stat -c '%w' / | cut -d' ' -f1)
if [ "$creation_date" == "-" ]; then
  creation_date="Unknown"
  root_age="Unavailable"
else
  current_date=$(date '+%Y-%m-%d')
  age_in_days=$(( ( $(date -d "$current_date" '+%s') - $(date -d "$creation_date" '+%s') ) / 86400 ))
  years=$(( age_in_days / 365 ))
  months=$(( (age_in_days % 365) / 30 ))
  days=$(( (age_in_days % 365) % 30 ))
  root_age="${years} years, ${months} months, and ${days} days old"
fi

## OUTPUT
cat <<EOF
 	${yellow} ${blue} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${green} ${magenta} ${cyan} ${red} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${red} ${green} ${red} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${reset}

 	  ${ic} ${cyan}${version}${reset} ${lc} ${c2}${kernel}${reset} ${lc}  ${c1}${RAM}${memstat}${reset} ${lc} ${ic}${packages}${reset} ${lc}  ${hn}${uptime}${reset}

 	  ${ic}🎂 ${yellow}BirthDay: ${cyan}${creation_date}${reset}
 	  ${ic}🤫 ${yellow}Age: ${cyan}${root_age}${reset}

 	${yellow} ${blue} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${green} ${magenta} ${cyan} ${red} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${red} ${green} ${red} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${reset}
EOF

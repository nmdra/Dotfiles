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
  # Get current date and creation date as year, month, day
  year_creation=$(date -d "$creation_date" '+%Y')
  month_creation=$(date -d "$creation_date" '+%-m')
  day_creation=$(date -d "$creation_date" '+%-d')

  year_current=$(date '+%Y')
  month_current=$(date '+%-m')
  day_current=$(date '+%-d')

  # Calculate years difference
  age_in_years=$((year_current - year_creation))
  
  # Calculate months difference
  age_in_months=$((month_current - month_creation))
  
  # Calculate days difference
  age_in_days=$((day_current - day_creation))
  
  # Adjust for negative days or months
  if [ $age_in_days -lt 0 ]; then
    previous_month=$(date -d "$current_date -1 month" '+%-m')
    days_in_previous_month=$(date -d "$year_current-$previous_month-01 +1 month -1 day" '+%d')
    age_in_days=$((age_in_days + days_in_previous_month))
    age_in_months=$((age_in_months - 1))
  fi

  if [ $age_in_months -lt 0 ]; then
    age_in_months=$((age_in_months + 12))
    age_in_years=$((age_in_years - 1))
  fi

  root_age="${age_in_years} years, ${age_in_months} months, and ${age_in_days} days old"
fi

## OUTPUT
cat <<EOF
 	${yellow} ${blue} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${green} ${magenta} ${cyan} ${red} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${red} ${green} ${red} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${reset}

 	  ${ic} ${cyan}${version}${reset} ${lc} ${c2}${kernel}${reset} ${lc}  ${c1}${RAM}${memstat}${reset} ${lc} ${ic}${packages}${reset} ${lc}  ${hn}${uptime}${reset}

 	  ${ic}🎂 ${yellow}BirthDay: ${cyan}${creation_date}${reset}
 	  ${ic}🤫 ${yellow}Age: ${cyan}${root_age}${reset}

 	${yellow} ${blue} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${green} ${magenta} ${cyan} ${red} ${magenta} ${cyan} ${red} ${green} ${red} ${yellow} ${red} ${green} ${red} ${cyan} ${red} ${green} ${red} ${yellow} ${green} ${blue} ${reset}
EOF

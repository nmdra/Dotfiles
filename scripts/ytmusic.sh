#!/bin/bash

curl --silent "https://www.youtube.com/oembed\?url\=https://www.youtube.com/watch?v=5L7eTJT-MLs&format\=json" | grep -oP '(?<="title":")[^"]+'

echo $name

# mpv --vo=null --video=no --pause=no --no-video --term-osd-bar --loop-playlist=yes "$1" 1>/dev/null

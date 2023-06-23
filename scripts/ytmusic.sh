#!/bin/bash

mpv --vo=null --video=no --pause=no --no-video --term-osd-bar --loop-playlist=yes "$1" 1>/dev/null

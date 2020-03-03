#!/bin/bash

echo "starting VNC server ..."
export USER=devuser
vncserver :1 -geometry 1280x800 -depth 24 && tail -F .vnc/*.log

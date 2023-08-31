#!/bin/bash

# setting for autoshutdown time
sudo sh -c 'echo "SHUTDOWN_TIME=30" >> /home/ubuntu/.c9/autoshutdown-configuration'

# setting for python formatter
FILE_PATH="/home/ubuntu/.c9/project.settings"
jq '.python["@formatOnSave"] = true | .python["@formatter"] = "autopep8 --in-place $file --ignore E402"' $FILE_PATH > temp.json && mv temp.json $FILE_PATH

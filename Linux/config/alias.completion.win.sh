#!/bin/bash
# Only for windows git bash
# cp alias.completion.sh /etc/alias.completion.sh
# echo "source /etc/alias.completion.sh"  >> /etc/profile

__git_complete g git
__git_complete gmg git_merge
__git_complete gpl git_pull
__git_complete gps git_push
__git_complete gb git_branch
__git_complete gc git_commit
__git_complete gco git_checkout
__git_complete gs git_switch
__git_complete gcp git_cherry_pick
__git_complete gst git_status



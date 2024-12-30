#!/bin/bash
/usr/local/bin/pass ls
read -p "Name: " entry
/usr/local/bin/pass -c "$entry"

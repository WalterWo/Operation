#!/bin/bash

Server_Name=$1
Server_Metrix=$2
Monitor_Time=$3

cd ./ansible

sudo ansible-playbook -i "${Server_Name}" ./playbook/test_script.yml -e '{"metrix":"${Server_Metrix}","runtime":"${Monitor_Time}","hosts":"${Server_Name}"}'

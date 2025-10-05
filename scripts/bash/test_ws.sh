#!/bin/bash

curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: example.com" -H "Origin: http://example.com" http://example.com/websocket
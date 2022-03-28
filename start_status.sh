#!/bin/bash

nohup /root/wstunnel-x64-linux -L 0.0.0.0:35601:127.0.0.1:35601 wss://test-81-web-gbjkld.cloud.okteto.net &
nohup /root/client-linux.py &

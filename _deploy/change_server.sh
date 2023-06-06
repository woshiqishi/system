#!/bin/bash

if sudo sed -i 's/http:\/\/[a-z][a-z]\.archive\.ubuntu\.com\/ubuntu\//http:\/\/archive.ubuntu.com\/ubuntu\//g' /etc/apt/sources.list; then
    echo "server changed"
else
    echo "ERROR: server not changed!"; exit 1
fi
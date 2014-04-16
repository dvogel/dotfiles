#!/bin/bash

function myip () {
    curl_bin="$(which curl)"
    if [[ -z "${curl_bin}" ]]; then
        echo "Cannot find curl"
    else
        curl -s http://ifconfig.me
    fi
}


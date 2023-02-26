#!/bin/bash

: '
Start-up script for observability tools demo.

Prerequisites:
- minikube >= v1.29.0
- terraform >= 1.3.0

Usage 
'
set -euo pipefail

# Check if needed components are installed
if  ! command -v minikube &> /dev/null   
then
    echo -e "\xF0\x9F\x98\xA2 Error: Minikube is not installed. Please install Minikube and try again."
    exit 1
fi

if  ! command -v terraform &> /dev/null   
then
    echo -e "\xF0\x9F\x98\xA2 Error: terraform is not installed. Please install terraform and try again."
    exit 1
fi

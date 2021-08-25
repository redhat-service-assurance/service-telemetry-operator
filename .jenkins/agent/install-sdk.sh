#!/bin/bash

# NOTE: any version of operator-sdk later than v0.19.4 is incompatable with the build scripts

SDK_FULL_NAME="operator-sdk-v0.19.4-x86_64-linux-gnu"
curl -LO "https://github.com/operator-framework/operator-sdk/releases/download/v0.19.4/$SDK_FULL_NAME"
chmod +x "$SDK_FULL_NAME" && mv "$SDK_FULL_NAME" /usr/local/bin/operator-sdk

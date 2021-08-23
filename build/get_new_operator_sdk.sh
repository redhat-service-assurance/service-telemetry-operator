#!/bin/bash

REL=$(dirname "$0")
ARCH=$(case $(uname -m) in x86_64) echo -n amd64 ;; aarch64) echo -n arm64 ;; *) echo -n $(uname -m) ;; esac)
OS=$(uname | awk '{print tolower($0)}')
VERSION="${1:-v1.5.0}"
OPERATOR_SDK_DL_URL=https://github.com/operator-framework/operator-sdk/releases/download/${VERSION}

if [[ ! -f ${REL}/working/operator-sdk-${VERSION} ]]; then
	curl -L ${OPERATOR_SDK_DL_URL}/operator-sdk_${OS}_${ARCH} -o ${REL}/working/operator-sdk-${VERSION}
	chmod +x ${REL}/working/operator-sdk-${VERSION}
fi


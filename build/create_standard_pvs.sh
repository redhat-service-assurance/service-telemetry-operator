#!/usr/bin/env bash

# Create the standard storage class
if ! oc describe sc standard; then
	oc create -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/no-provisioner
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
EOF
fi

# Check how many PVs we need to patch
AVAILABLE_STANDARD_PVS=`oc get pv | grep standard | grep Available | wc -l`
REQUIRED_NEW_STANDARD_PVS=`expr $1 - $AVAILABLE_STANDARD_PVS`

for (( i=0; i<$REQUIRED_NEW_STANDARD_PVS; i++ ))
do
	PV=`oc get pv | grep -v standard | grep Available -m 1 | awk '{print $1}'`
	oc patch pv $PV -p '{"spec":{"storageClassName":"standard"}}'
done

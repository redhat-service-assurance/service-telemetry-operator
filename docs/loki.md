# How to run SGO with Loki
A few examples about how to deploy with Loki for logging support.

## Deploy SGO + Loki with minio for storage
This is less resource intensive. Useful for development in crc.
```
ansible-playbook --extra-vars __service_telemetry_logs_enabled=true --extra-vars __deploy_minio_enabled=true run-ci.yaml
```

## Deploy SGO + Loki with OCS for storage
This is more a production-like setup. It's more resource demanding and cannot be run in crc. This assumes OCS is already deployed.

### Create an object bucket claim
```
oc apply -f - <<EOF
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: loki-s3-storage
spec:
  additionalConfig:
    bucketclass: noobaa-default-bucket-class
  generateBucketName: loki-s3-storage
  storageClassName: openshift-storage.noobaa.io
EOF
```

### Find the required information to connect to OCS
```
oc extract secret/loki-s3-storage --to=-
oc extract configmap/loki-s3-storage --to=-
```

### Example output
```
oc extract secret/loki-s3-storage --to=-
# AWS_SECRET_ACCESS_KEY
u6fA9Nkh2D7jS7qNBSU0zKEAfLKx2QnMu71jMfpR
# AWS_ACCESS_KEY_ID
q2Jv3EvxOkavqw1TRhdD
 
oc extract configmap/loki-s3-storage --to=-
# BUCKET_NAME
loki-s3-storage-8d19e1e7-c889-46f7-8654-3cef0aeb08a1
# BUCKET_PORT
443
# BUCKET_REGION
 
# BUCKET_SUBREGION
 
# BUCKET_HOST
s3.openshift-storage.svc
```

### Create a secret with S3 credentials for the loki-operator
```
oc apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: <name of the secret>
stringData:
  endpoint: https://<BUCKET_HOST from previous commands>:<BUCKET_PORT from previous commands>
  bucketnames: <BUCKET_NAME from previous commands>
  access_key_id: <AWS_ACCESS_KEY_ID from previous commands>
  access_key_secret: <AWS_SECRET_ACCESS_KEY from previous commands>
type: Opaque
EOF
```

### Deploy SGO + Loki
```
ansible-playbook --extra-vars __service_telemetry_logs_enabled=true --extra-vars __loki_skip_tls_verify=true run-ci.yaml
```


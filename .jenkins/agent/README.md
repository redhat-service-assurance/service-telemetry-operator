The Jenkins agent pod is used to run all Jenkins pipelines for the Service Telemetry Framework. 

# Build in OpenShift
```bash
oc new-build --binary=true --name=jenkins-agent
oc start-build jenkins-agent --from-dir .
```
Builds will be available in-cluster at the address: `image-registry.openshift-image-registry.svc:5000/<NAMESPACE>/jenkins-agent:latest`

# Build with Podman/Docker
```bash
podman build -t jenkins-agent:latest .
```

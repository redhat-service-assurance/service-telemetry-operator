KIND_SERVICEASSURANCE="apiVersion: infra.watch/v1alpha1
kind: ServiceTelemetry
metadata:
  name: saf-default
  namespace: ${OCP_PROJECT}
spec:
  metricsEnabled: true
  eventsEnabled: true"

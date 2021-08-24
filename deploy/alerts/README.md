# Predefined alerts

## alerts.yaml
These alarms are triggered by a substantial change (over a certain
amount of standard deviation). They provide a default and may
require adjustment for specific deployments.

## alerts_extended.yaml
Besides `alerts.yaml` alarms from **openstack.rules**, it includes:
 - **ceph.rules**: 
     * ceph osd down
     * ceph full (warning and critical)
 - **virtual.rules**:
     * high cpu virtual (warning and critical)
     * memory low virtual (warning and critical)
     * error packets rx/tx virtual
     * dropped packers rx/tx virtual
 - **availability.rules**:
     * metric listener down
     * host down

## Installation

Log into OpenShift and

```
oc apply -f alerts.yaml
```

or:

```
oc apply -f alerts_extended.yaml
```


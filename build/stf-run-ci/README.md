stf-run-ci
==========

Run the Service Telemetry Framework CI system. This role is intended to be
called from a playbook running locally on a preconfigured test system.
Primarily this means a running CodeReady Container system has been provided.

Requirements
------------

- CodeReady Containers
- Ansible 2.9 (tested)
- `oc` command line tool

Variables
---------

Not all variables are listed here, but these are the most common ones you might
choose to override:

| Parameter name                                  | Values          | Default                                          | Description                                                                                           |
| ------------------------------                  | ------------    | ---------                                        | ------------------------------------                                                                  |
| `__deploy_stf`                                  | {true,false}    | true                                             | Whether to deploy an instance of STF                                                                  |
| `__local_build_enabled`                         | {true,false}    | true                                             | Whether to deploySTF from local built artifacts. Also see `working_branch`, `sg_branch`, `sgo_branch` |
| `prometheus_webhook_snmp_branch`                | <git_branch>    | master                                           | Which Prometheus Webhook SNMP git branch to checkout                                                  |
| `sgo_branch`                                    | <git_branch>    | master                                           | Which Smart Gateway Operator git branch to checkout                                                   |
| `sg_branch`                                     | <git_branch>    | master                                           | Which Smart Gateway git branch to checkout                                                            |
| `sg_core_branch`                                | <git_branch>    | master                                           | Which Smart Gateway Core git branch to checkout                                                       |
| `sg_bridge_branch`                              | <git_branch>    | master                                           | Which Smart Gateway Bridge git branch to checkout                                                     |
| `__service_telemetry_events_enabled`            | {true,false}    | true                                             | Whether to enable events support in ServiceTelemetry                                                  |
| `__service_telemetry_high_availability_enabled` | {true,false}    | false                                            | Whether to enable high availability support in ServiceTelemetry                                       |
| `__service_telemetry_metrics_enabled`           | {true,false}    | true                                             | Whether to enable metrics support in ServiceTelemetry                                                 |
| `__service_telemetry_storage_ephemeral_enabled` | {true,false}    | false                                            | Whether to enable ephemeral storage support in ServiceTelemetry                                       |
| `__service_telemetry_snmptraps_enabled`         | {true,false}    | true                                             | Whether to enable snmptraps delivery via Alertmanager receiver (prometheus-webhook-snmp)              |
| `__service_telemetry_logs_enabled`              | {true,false}    | false                                            | Whether to enable logs support in ServiceTelemetry                                                    |
| `__internal_registry_path`                      | <registry_path> | image-registry.openshift-image-registry.svc:5000 | Path to internal registry for image path                                                              |
| `__deploy_minio_enabled`                        | {true,false}    | false                                            | Whether to deploy minio while deploying loki-operator for logging development purposes                |
| `__loki_skip_tls_verify`                        | {true,false}    | false                                            | Whether to skip TLS verify for Loki S3 connection                                                     |


Example Playbook
----------------

```yaml
---
# run STF CI setup in CRC (already provisioned)
- hosts: localhost
  connection: local
  tasks:
  - name: Run the STF CI system
    import_role:
        name: stf-run-ci
```

Usage
-----

You can deploy Service Telemetry Framework using this role in a few
configuration methods:

* local build artifacts from Git repository cloned locally
* standard deployment using Subscription and OLM
* supporting components but no instance of Service Telemetry Operator

You can deploy using the sample `run-ci.yaml` from the _Example Playbook_
section:

```
ansible-playbook run-ci.yaml
```

If you want to do a standard deployment (existing remote artifacts) you can use
the following command:

```
ansible-playbook --extra-vars __local_build_enabled=false run-ci.yaml
```

License
-------

Apache v2.0

Author Information
------------------

Leif Madsen

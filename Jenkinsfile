#!/usr/bin/env groovy

// can't just use BUILD_TAG because qdr operator limits name of resources to 60 chars
def namespace = env.JOB_BASE_NAME + '-' + env.BUILD_NUMBER
namespace = namespace.toLowerCase()

def stages_failed = false;

def stf_resource = """
apiVersion: infra.watch/v1beta1
kind: ServiceTelemetry
metadata:
  name: default
  namespace: ${namespace}
spec:
  alerting:
    alertmanager:
      storage:
        strategy: ephemeral
      receivers:
        snmpTraps:
          enabled: true
  backends:
    events:
      elasticsearch:
        enabled: true
        storage:
          strategy: ephemeral
    metrics:
      prometheus:
        enabled: true
        storage:
          strategy: ephemeral
  transports:
    qdr:
      enabled: true
      deploymentSize: 1
      web:
        enabled: false
  elasticsearch_manifest: |
    apiVersion: elasticsearch.k8s.elastic.co/v1beta1
    kind: Elasticsearch
    metadata:
      name: elasticsearch
      namespace: $namespace
    spec:
      version: 7.10.2
      http:
        tls:
          certificate:
            secretName: 'elasticsearch-es-cert'
      nodeSets:
        - config:
            node.data: true
            node.ingest: true
            node.master: true
            node.store.allow_mmap: true
          count: 1
          name: default
          podTemplate:
            metadata:
              labels:
                tuned.openshift.io/elasticsearch: elasticsearch
            spec:
              containers:
                - name: elasticsearch
                  resources:
                    limits:
                      cpu: '2'
                      memory: 4Gi
                    requests:
                      cpu: '1'
                      memory: 2Gi
              volumes:
                - emptyDir: {}
                  name: elasticsearch-data
"""

def working_branch = "stable-1.2"

node('ocp-agent') {
    container('exec') {
        dir('service-telemetry-operator') {
            stage ('Clone Upstream') {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    checkout scm
                    working_branch = sh(script: 'git ls-remote --heads origin | grep $(git rev-parse HEAD) | cut -d / -f 3', returnStdout: true).toString().trim()
                    // ansible script needs local branch to exist, not detached HEAD
                    sh "git checkout -b ${working_branch}"
                }
            }
            stage ('Create project') {
                if ( currentBuild.result != null ) { stages_failed = true; return; }
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    openshift.withCluster(){
                        openshift.newProject(namespace)
                    }
                }
            }
            stage('Build STF Containers') {
                if ( currentBuild.result != null ) { stages_failed = true; return; }
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    ansiColor('xterm') {
                        ansiblePlaybook(
                            // use the playbook to build the containers but don't run CI
                            playbook: 'build/run-ci.yaml',
                            colorized: true,
                            extraVars: [
                                "namespace": namespace,
                                "__deploy_stf": "false",
                                "__local_build_enabled": "true",
                                "__service_telemetry_snmptraps_enabled": "true",
                                "__service_telemetry_storage_ephemeral_enabled": "true",
                                "working_branch":"${working_branch}"
                            ]
                        )
                    }
                }
            }
            stage('Deploy STF Object') {
                if ( currentBuild.result != null ) { stages_failed = true; return; }
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    openshift.withCluster() {
                        openshift.withProject(namespace) {
                            timeout(time: 300, unit: 'SECONDS') {
                                openshift.create(stf_resource)
                                sh "OCP_PROJECT=${namespace} ./build/validate_deployment.sh"
                            }
                        }
                    }
                }
            }
            stage('Run Smoketest') {
                if ( currentBuild.result != null ) { stages_failed = true; return; }
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh "OCP_PROJECT=${namespace} ./tests/smoketest/smoketest.sh"
                }
            }
            stage('Cleanup') {
                return;
                openshift.withCluster(){
                    openshift.selector("project/${namespace}").delete()
                    if ( stages_failed ) { currentBuild.result = 'FAILURE' }
                }
                if ( stages_failed ) { currentBuild.result = 'FAILURE' }
            }
        }
    }
}


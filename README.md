# mysql-rrc
MySQL Read Replica Cluster based on Kubernetes StatefulSet

The kubernetes-resources directory contains individual resource manifest, (almost) ready to be deployed. Please edit the .secret.yaml files or modify when deployed with the right values.

The openshift-resources directory contains a template resource manifest, to deploy the RRC. It only works in a OpenShift Cluster

The scripts directory contains some scripts. The following scripts are packed in a configmap, and will be mounted in a MySQL container pulled from registry.redhat.io:

* rrc-env
* rrc-run-mysqld
* rrc-run-mysqld-replica
* rrc-run-mysqld-source
* rrc-instance-alive
* rrc-instance-ready

The following scripts are included in a custom RHEL9 container image, among with Percona Xtrabackup utility, available at quay.io/jnmalledo/sts-rrc-utils:1.1

* rrc-env
* rrc-pre
* rrc-post

Enjoy
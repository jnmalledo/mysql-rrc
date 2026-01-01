# mysql-rrc
MySQL Read Replica Cluster based on Kubernetes StatefulSet

The kubernetes-resources directory contains individual resource manifest, (almost) ready to be deployed. Please edit the .secret.yaml files or modify when deployed with the right values. It also includes a bash script to interact with deployed database instances

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

The following Kubernetes resources will be deployed (default values for names are shown):

1. Secrets
   1.1. mysql-creds (MySQL credentials)
   1.2. rh-registry-creds (Registry pull credentials)
2. Configmaps
   2.1. rrc-scripts (rrc scripts for the mysql-80 container)
   2.2. dbdump (a simple test database dump file)
3. Services
   3.1. interconnect (headless service for individual pod access)
   3.2. mysql-read (regular ClusterIP service for read-only purposes)
4. StatefulSet
   4.1. mysql (the RRC StatefulSet Resource)

To configure pod access to RRC:

1. Writer endpoint. For database update operations, like INSERT, UPDATE, DELETE, CREATE, etc, use the following endpoint: 
        mysql-0.interconnect
2. Round-robin reader endpoint. For light select operations, you can use the following endpoint: 
        mysql-read
   Please note that SELECT operations might be attended by the primary Source instance (writer) when you use this endpoint
3. Heavy reader endpoint. For heavy select operations, use this endpoint instead:
        mysql-n.interconnect
   (n > 0)


Enjoy
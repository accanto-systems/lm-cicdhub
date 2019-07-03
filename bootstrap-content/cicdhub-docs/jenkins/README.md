# Jenkins

Jenkins is an automation server to enable continuous integration and continuous delivery. It is included in the CICDHub for automating the build, test and deployment of Stratoss LM Assembly projects. It can be accessed at: {{bgv_jenkins_addr}}

# Admin User

The inital Admin user of Jenkins on this CICDHub is:

- Username: {{bgv_jenkins_admin_user}}
- Password: {{bgv_jenkins_admin_pass}}

# Lmctl

{% if bootstrap_jenkins_lmctl_slave|default(False)|bool == False %}
**Note: the installation of this CICDHub did not have the `bootstrap_jenkins_lmctl_slave` option enabled, so a slave may not have been configured**
{% endif %}

A Jenkins JNLP agent has been configured to create slave pods using a custom built lmctl docker image (including the version of lmctl you provided at install time). Each job execution will create a fresh environment by creating a new temporary pod.

You may view the configuration for this on the Jenkins UI at `Manage Jenkins->Configure System->Cloud->Kubernetes`.

To use this slave in your pipelines you must configure the agent option with the `lmctl` label:

```
pipeline {
    agent { label 'lmctl' }
    ...rest of pipeline...
}
```

The created pod imports a `lmctl-config.yaml` file from the `lmctl-slave-config` config map, which has been pre-configured with a `testing` environment referencing the target Stratoss LM and Ansible RM either.

This config can be updated at anytime, by replacing the contents of the config map. Do this using `kubectl edit`:

```
kubectl edit configmap lmctl-slave-config
```

This command opens a text editor on the contents of the config map. Make changes to `data` field to update your lmctl config. You can confirm your changes have been saved by inspecting the configmap:

```
kubectl describe configmap lmctl-slave-config
```

Once your changes have been saved, they will take affect on the next Jenkins job execution.

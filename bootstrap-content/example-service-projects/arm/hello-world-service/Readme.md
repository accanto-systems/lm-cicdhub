# Hello-world service

This service is a very simple network service that deploys an asterisk service and a sip traffic generator into a docker enviroment, using two docker networks.

The aim of that a successful test of this service indicates that the environment that has been installed is working.

## Prerequisite

You have `lmctl` installed and a target Stratoss&trade; Lifecycle Manager environment. Check your `Getting Started` repository for more information on how to install and configure `lmctl`.

## Using the Hello-World service

This service can be pushed to a target Stratoss&trade; Lifecycle Manager environment with lmctl.

You will need to checkout this project, plus an additional 3 projects for VNFs this service depends on:

```
git clone {{bgv_gogs_clone_addr}}/{{ bgv_gogs_admin_user }}/docker-network.git
git clone {{bgv_gogs_clone_addr}}/{{ bgv_gogs_admin_user }}/ip-pbx.git
git clone {{bgv_gogs_clone_addr}}/{{ bgv_gogs_admin_user }}/sip-performance.git
git clone {{bgv_gogs_clone_addr}}/{{ bgv_gogs_admin_user }}/hello-world-service.git
```

Once you have these projects and have configured your lmctl install with a target environment, use the `project push` command to first push the VNFs (replace `dev` with the name of your environment from your lmctl config file):

```
cd ./docker-network
lmctl project push dev

cd ../ip-pbx
lmctl project push dev

cd ../sip-performance
lmctl project push dev
```

Now push the hello-world-service project to your target Lifecycle Manager environment. Use the `project push` command or use the `project test` command to also run the included behaviour tests on push.

```
lmctl project test dev
```

## Example Process for use with CI/CD Hub

```

              +---+
              |   |
              +---+
                |
                |
                v
      +-------------------+
      |                   |         - This stage is done on an engineers environment.  Working on a "development" branch.
      |  Development      +------+  - Using "lmctl project create", "lmctl project push" and "lmctl project pull".
      |                   |      |  - Merging the development branch into master branch would signal move to formal
      +-------------------+      |    testing phase.
                |                |
                |                |
                |                |
                v                |
      +-------------------+      |  - This is an optional state.  If the running of testing is manually run then this
      |                   |      |  - indicates that the artefact is awaiting testing.
      |  Awaiting Test    |      |
      |                   |      |
      +-------------------+      |
                |                |
                |                |
                |        Failed  |
                v                |
      +-------------------+      |  - This state indicates that the artefact had been tested.  In the event of failure
      |                   |      |  - the artefact is not moved to the next state and the development will have to continue.
      |  Tested           +------+  - Passing this state will create a package in the repository and the master branch is
      |                   |         - tagged with the version that had been tested.  The master branch should be up-versioned
      +-------------------+         - A new development branch based on the master position so that on going development starts
                |                   - from this point.
                | Passed
                |
                v
      +-------------------+         - Another optional branch allowing manual approval of the tested artefact.
      |                   |
      |  Awaiting Release |
      |                   |
      +-------------------+
                |
                |
                v
      +-------------------+         - The act of releasing would normally involve moving the tested artefact package to a
      |                   |         - released format that can be used by production environments.
      |  Released         |         - The master branch is tagged with the release version.
      |                   |
      +-------------------+
                |
                |
              +-v-+
              |   |
              +---+

```

## The Process

The process above is an example set of states that allow an artefact (VNFC, VNF, NS) to be managed from development through to a released state.  
The CI/CD Hub allows for this process to be handled. With a combination of the Gogs git repository, to manage branches and tags of the files used by the
arfefact. The Jenkins server allows for automated testing and tagging of the artefact beyond the development state. The Nexus repository is
used to hold built artefacts in a manner which is immutable. This allows the results of testing and released versions to be captured for ongoing distribution.

## Using Jenkins within the CI/CD Hub

To build, test and deploy this service with Jenkins you need to create a multibranch pipeline for this project (and for each of the VNF projects).

To do this, open [Jenkins]({{bgv_jenkins_addr}}) and do the following:

1. Select the `New Item` option from the left hand menu
2. Enter a `name` (use the project name) e.g. `hello-world-service`
3. Select `Multibranch Pipeline` and press `OK`
4. Open `ADD SOURCE` under the `Branch Sources` section of the job configuration
5. Select `Git`
6. Enter the repository url in the `Project Repository` field e.g. `{{bgv_gogs_clone_addr}}/{{ bgv_gogs_admin_user }}/hello-world-service.git`
7. Open `ADD PROPERTY` and select `Suppress automatic SCM triggering`
8. Finally press `SAVE`

This will create a job that reads the Git project for a `Jenksinfile`. The hello-world-service project (and VNF dependencies) all include an example `Jenkinsfile` that uses lmctl to push and run tests on the Lifecycle Manager test environment.

You may execute the job for a project by selecting it's name in the list of Jenkins job on the dashboard. Then select the `Master` branch and select `Build Now`.

Ensure you execute the jobs for the VNFs before the hello-world-service.

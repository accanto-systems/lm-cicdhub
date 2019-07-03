# Nexus

Nexus is a repository manager and is included in the CICDHub for storing artifacts in a central location. It can be accessed at: {{bgv_nexus_addr}}

# Admin User

The inital Admin user of Nexus on this CICDHub is:

* Username: {{bgv_nexus_admin_user}}
* Password: {{bgv_nexus_admin_pass}}

# Repositories

Several repositories have been created by the CICDHub install scripts. 

* maven-XYZ - default maven repositories created by Nexus
* nuget-XYZ - default nuget repositories created by Nexus
* pypi - a pypi repository created for hosting `lmctl`
* pypi-proxy - a pypi proxy to the public pypi repositories
* pypi-all - a pypi group that can pull packages from both pypi and pypi-all, making it possible to reference a single pypi repository to download both public and internal packages
* raw - a raw Nexus repository used for storing `All-in-one` and `Lifecycle Manager` artifacts
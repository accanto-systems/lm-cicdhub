# Openldap

Openldap is an open-source implementation of the Lightweight Directry Access Protocol. It is included in the CICDHub as a central service for User Management of the Stratoss&trade; Lifecycle Manager environment on the Hub. 

The access address for the Openldap server installed on this Hub is: {{bgv_openldap_addr}}

# Admin User

The inital Admin user of Openldap on this CICDHub is:

* Username: {{bgv_openldap_admin_user}}
* Password: {{bgv_openldap_admin_pass}}

# Sharing Openldap across Stratoss LM environments

Several Stratoss LM environments can share a single Openldap, making it possible for users to use the same credentials across them. In each environment, the privileges available to be each user can be configured differently, providing a mechanism for controlling users access to pre-production and testing environments. 

The `All-in-one` environment (which may be downloaded from this CICDHub) installed by each VNF/NS developer is pre-configured to access the same Openldap as the CICDHub.
 
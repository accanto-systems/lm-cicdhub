# Lifecycle Manager

{% if lm|default(False)|bool == True %}
A Stratoss&trade; Lifecycle Manager instance has been installed, to be used as a test environment in Jenkins builds. It can be accessed at:

- UI - {{bgv_lm_ui_addr}}
- API - {{bgv_lm_api_addr}}

There is also a Kibana instance, for viewing and analysing the logs of Stratoss LM applications (and the Ansible RM) at: {{bgv_kibana_addr}}

# Ansible RM

An instance of the [Ansible RM](https://github.com/IBM/osslm-ansible-resource-manager) has been installed on the CICDHub and onboarded in your Stratoss LM instance. The Swagger UI for it may be accessed at: {{bgv_ansiblerm_addr}}

{% else %}

Installation of the Stratoss&trade; Lifecycle Manager was disabled.

{% endif %}

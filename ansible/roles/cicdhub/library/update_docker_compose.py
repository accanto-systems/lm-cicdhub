#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule

import json

try:
    import jsonpointer
except ImportError:
    jsonpointer = None

def update(docker_compose, service, docker_registry_uri, path):
    image = jsonpointer.resolve_pointer(docker_compose, "/services/" + service + "/image")
    jsonpointer.set_pointer(docker_compose, "/services/" + service + "/image", docker_registry_uri + '/' + image)

    # context = jsonpointer.resolve_pointer(docker_compose, "/services/" + service + "/build/context").replace('./', path + '/')
    # jsonpointer.set_pointer(docker_compose, "/services/" + service + "/build/context", context)

def main():
    module = AnsibleModule(
        argument_spec={
            "docker_compose": {"default": True, "type": "dict"},
            "docker_registry_uri": {"default": True, "type": "str"},
            "path": {"default": True, "type": "str"}
        },
        supports_check_mode=True,
    )

    if jsonpointer is None:
        module.fail_json(msg='jsonpointer module is not available')

    docker_compose = module.params['docker_compose']
    docker_registry_uri = module.params['docker_registry_uri']
    path = module.params['path']

    if isinstance(docker_compose, str):
        docker_compose = json.loads(str)

    services = ["conductor", "apollo", "daytona", "galileo", "ishtar", "nimrod", "lm-configurator", "relay", "watchtower", "doki", "talledega"]

    try:
        for service in services:
            update(docker_compose, service, docker_registry_uri, path)

    except jsonpointer.JsonPointerException as err:
        module.fail_json(msg=str(err))

    module.exit_json(changed=True, result=docker_compose)

if __name__ == '__main__':
    main()
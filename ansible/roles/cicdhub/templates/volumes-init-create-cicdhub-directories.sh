set -e

# ~/volumes-init-create-marketplace-directories.yml -p /var/marketplace -n 1 -j 1 -g 1 -t 1 -c 1
usage(){
    echo "usage: $(basename "$(test -L "$0" && readlink "$0" || echo "$0")") [OPTIONS]
    Program to:
    - Setup directories required by the volumesInit functionality of helm-foundation chart

    options:
        -p, --parent-dir             (required) parent directory to create volume directories in (default: /var/cicdhub)
        -n, --nexus                  number of nexus instances requiring volumes (default: 1)
        -j, --jenkins                number of jenkins master instances requiring volumes (default: 1)
        -g, --gogs                   number of gogs instances requiring volumes (default: 1)
        -d, --dockerregistry         number of dockerregistry instances requiring volumes (default: 1)
        -jh, --jupyterhub            number of jupyterhub instances requiring volumes (default: 1)
        -o, --openldaps              number of openldaps instances requiring volumes (default: 1)
    "
}

parent_dir="/var/cicdhub"
nexus=1
jenkins=1
# gitlab=1
gogs=1
jupyterhub=1
dockerregistry=1
openldaps=1

while [ "$1" != "" ]; do
    case $1 in
        -p | --parent_dir )
            shift
            parent_dir=$1
            ;;
        -n | --nexus )
            shift
            nexus=$1
            ;;
        -j | --jenkins )
            shift
            jenkins=$1
            ;;
        # -d | --gitlab )
        #     shift
        #     gitlab=$1
        #     ;;
        -g | --gogs )
            shift
            gogs=$1
            ;;
        -jh | --jupyterhub )
            shift
            jupyterhub=$1
            ;;
        -d | --dockerregistry )
            shift
            dockerregistry=$1
            ;;
        -o | --openldaps )
            shift
            openldaps=$1
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            exit 1
    esac
    shift
done

createVolumeDir(){
    mkdir -p "$parent_dir/volume-$1"
    chmod 777 "$parent_dir/volume-$1"
}

if [[ -z $parent_dir ]]; then
    echo "Aborted: No parent directory was given (-p, --parent-dir)"
    exit 1;
fi

if [[ $nexus -gt 0 ]]; then
    for (( i=0; i<$nexus; i++ ))
    do
        createVolumeDir "nexus$i"
    done
fi

if [[ $jenkins -gt 0 ]]; then
    for (( i=0; i<$jenkins; i++ ))
    do
        createVolumeDir "jenkins$i"
    done
fi

# if [[ $gitlab -gt 0 ]]; then
#     for (( i=0; i<$gitlab; i++ ))
#     do
#         createVolumeDir "volume-gitlab-etc$i"
#         createVolumeDir "volume-gitlab-data$i"
#     done
# fi

if [[ $gogs -gt 0 ]]; then
    for (( i=0; i<$gogs; i++ ))
    do
        createVolumeDir "gogs$i"
        createVolumeDir "gogs-postgresql$i"
    done
fi

if [[ $dockerregistry -gt 0 ]]; then
    for (( i=0; i<$dockerregistry; i++ ))
    do
        createVolumeDir "dockerregistry$i"
    done
fi

if [[ $jupyterhub -gt 0 ]]; then
    for (( i=0; i<$jupyterhub; i++ ))
    do
        createVolumeDir "jupyter$i"
    done
fi

if [[ $openldaps -gt 0 ]]; then
    for (( i=0; i<$openldaps; i++ ))
    do
        createVolumeDir "f$i"
    done
fi
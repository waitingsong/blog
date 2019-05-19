#!/bin/sh
#--------------------------------------------------
# Make extra_images_kubeasz
#
# @author:  waiting
# @date:    2019.04.18
# @link:    https://github.com/waitingsong/blog/blob/master/201904/assets/make_extra_images_bundle.sh
# @ref:     https://github.com/gjmzj/kubeasz
# @usage:
<<BASH
  wget https://raw.githubusercontent.com/waitingsong/blog/master/201904/assets/make_extra_images_bundle.sh
  chmod a+x make_extra_images_bundle.sh
  ./make_extra_images_bundle.sh
BASH
#--------------------------------------------------

basicVer=1.1
dir=extra_images_kubeasz_${basicVer}
bundle=${dir}.tar.xz

curlVer=latest
curlRep=appropriate/curl:$curlVer

# efk
elasticsearchVer=v5.6.4
elasticsearchRep=mirrorgooglecontainers/elasticsearch:$elasticsearchVer

alpineVer=3.6
alpineRep=alpine:$alpineVer

fluentdElasticsearchVer=v2.4.0
fluentdElasticsearchRep=mirrorgooglecontainers/fluentd-elasticsearch:$fluentdElasticsearchVer

kibanaVer=6.6.1
kibanaRep=jmgao1983/kibana:$kibanaVer
# efk END

heapsterVer=v1.5.4
heapsterInfluxdbVer=v1.5.2
heapsterGrafanaVer=v4.4.3
heapsterRep=mirrorgooglecontainers/heapster-amd64:$heapsterVer
heapsterInfluxdbRep=mirrorgooglecontainers/heapster-influxdb-amd64:$heapsterInfluxdbVer
heapsterGrafanaRep=mirrorgooglecontainers/heapster-grafana-amd64:$heapsterGrafanaVer

nfsClientVer=latest
nfsClientRep=jmgao1983/nfs-client-provisioner:$nfsClientVer

nginxVer=latest
nginxRep=nginx:$nginxVer

tillerVer=v2.12.3
tillerRep=jmgao1983/tiller:$tillerVer


case "$1" in
  dump)
    rm "/tmp/${dir}" -rf
    mkdir /tmp/${dir}
    cp "$0" /tmp/${dir}

    echo -e '\n--------------------------------------------------'
    echo -e 'Pulling images...\n'

    docker pull $curlRep
    docker pull $elasticsearchRep
    docker pull $alpineRep
    docker pull $fluentdElasticsearchRep
    docker pull $kibanaRep

    docker pull $heapsterRep
    docker pull $heapsterInfluxdbRep
    docker pull $heapsterGrafanaRep

    docker pull $nfsClientRep
    docker pull $nginxRep

    docker pull $tillerRep
    docker pull $zipkinRep


    echo -e '\n--------------------------------------------------'
    echo -e 'Saving images...\n'

    echo -e appropriate/curl
    docker save -o /tmp/${dir}/appropriate_curl_${curlVer}.tar $curlRep

    echo -e elasticsearch
    docker save -o /tmp/${dir}/elasticsearch_${elasticsearchVer}.tar $elasticsearchRep

    echo -e alpine
    docker save -o /tmp/${dir}/alpine_${alpineVer}.tar $alpineRep

    echo -e fluentd-elasticsearch
    docker save -o /tmp/${dir}/fluentd-elasticsearch_${fluentdElasticsearchVer}.tar $fluentdElasticsearchRep

    echo -e kibana
    docker save -o /tmp/${dir}/kibana_${kibanaVer}.tar $kibanaRep

    echo -e heapster
    docker save -o /tmp/${dir}/heapster_${heapsterVer}.tar $heapsterRep $heapsterInfluxdbRep $heapsterGrafanaRep

    echo -e nfs-client-provisioner
    docker save -o /tmp/${dir}/nfs-client-provisioner_${nfsClientVer}.tar $nfsClientRep

    echo -e nginx
    docker save -o /tmp/${dir}/nginx_${nginxVer}.tar $nginxRep

    echo -e tiller
    docker save -o /tmp/${dir}/tiller_${tillerVer}.tar $tillerRep

    echo -e '\n--------------------------------------------------'
    echo -e "Packing images to /tmp/${bundle}, it will take a long time...\n"
    cd /tmp && tar -cJvf ${bundle} ${dir}
    echo -e ''
    echo -e "Bundle file created as '/tmp/${bundle}'\n"
    ;;

  extract)
    if [ $2 ];then
      srcFile="$2"
    elif [ -f $bundle ];then
      srcFile="$bundle"
    else
      echo -e "Error: Images bundle file not exists: '$bundle'. You can specify source file as 2nd paratemer !\n"
      exit 1
    fi

    echo -e "Extracting images '$srcFile' to /etc/ansible/down/ ..."
    tar -xvf "$srcFile" --strip-components 1 -C /etc/ansible/down/
    ;;

  push)
    if [ $2 ];then
      srcFile="$2"
    elif [ -f $bundle ];then
      srcFile="$bundle"
    else
      echo -e "Error: Images bundle file not exists: '$bundle'. You can specify source file as 2nd paratemer !\n"
      exit 1
    fi

    echo -e "Pushing images to all k8s master/node nodes, it will take a long time...\n"
    ansible kube-master,kube-node -m file -a "path=/opt/kube/images state=directory "
    ansible kube-master,kube-node -m unarchive -a "src=${srcFile} dest=/opt/kube/images/"
    ;;

  install)
    echo -e "Loading images at k8s nodes..."
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/appropriate_curl_${curlVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/elasticsearch_${elasticsearchVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/alpine_${alpineVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/fluentd-elasticsearch_${fluentdElasticsearchVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/kibana_${kibanaVer}.tar"

    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/heapster_${heapsterVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/nfs-client-provisioner_${nfsClientVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/nginx_${nginxVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/tiller_${tillerVer}.tar"
    ;;

  *)
    echo -e "Usage: [dump|extract|push|install|cli]\n"
    echo -e "dump                   Save istio images and pack to file '/tmp/${bundle}'"
    echo -e "                         appropriate/curl:${curlVer}"
    echo -e "                         elasticsearch:${elasticsearchVer}"
    echo -e "                         alpine:${alpineVer}"
    echo -e "                         fluentd-elasticsearch:${fluentdElasticsearchVer}"
    echo -e "                         kibana:${kibanaVer}"
    echo -e "                         heapster:${heapsterVer}"
    echo -e "                         nfs-client-provisioner:${nfsClientVer}"
    echo -e "                         nginx:${latest}"
    echo -e "                         tiller:${tillerVer}"
    echo -e "extract <bundleFile>   Extract images to the path '/etc/ansible/down/'. Using the file under current folder if <bundleFile> not specified. "
    echo -e "push <bundleFile>      Push images in the file '${bundle}' to nodes of kube-master and kube-node via ansible."
    echo -e "                       Using the file under current folder if <bundleFile> not specified."
    echo -e "install <bundleFile>   execute \"docker load -f <isio images>\" on nodes of kube-master and kube-node."
    echo -e "cli                    Generate cli string of install for executing step by step manually."
    exit 0
  ;;
esac


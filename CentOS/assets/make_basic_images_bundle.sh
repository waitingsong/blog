#!/bin/sh
#--------------------------------------------------
# Make basic_images_kubeasz
#
# @author:  waiting
# @date:    2019.04.18
# @link:    https://github.com/waitingsong/blog/blob/master/201904/assets/make_basic_images_bundle.sh
# @ref:     https://github.com/gjmzj/kubeasz
# @usage:
<<BASH
  wget https://raw.githubusercontent.com/waitingsong/blog/master/201904/assets/make_basic_images_bundle.sh
  chmod a+x make_basic_images_bundle.sh
  ./make_basic_images_bundle.sh
BASH
#--------------------------------------------------

basicVer=1.1
dir=basic_images_kubeasz_${basicVer}
bundle=${dir}.tar.xz

calicoVer=v3.4.3
calicoCniRep=calico/cni:$calicoVer
calicoKubeRep=calico/kube-controllers:$calicoVer
calicoNodeRep=calico/node:$calicoVer

ciliumVer=v1.4.4
ciliumRep=cilium/cilium:$ciliumVer

corednsVer=1.5.0
corednsRep=coredns/coredns:$corednsVer

dashboardVer=v1.10.1
dashboardRep=mirrorgooglecontainers/kubernetes-dashboard-amd64:$dashboardVer

flannelVer=v0.11.0-amd64
flannelRep=jmgao1983/flannel:$flannelVer

metricsVer=v0.3.2
metricsRep=mirrorgooglecontainers/metrics-server-amd64:$metricsVer

pauseVer=3.1
pauseRep=mirrorgooglecontainers/pause-amd64:$pauseVer

traefikVer=v1.7.11
traefikRep=traefik:$traefikVer


case "$1" in
  dump)
    rm "/tmp/${dir}" -rf
    mkdir /tmp/${dir}
    cp "$0" /tmp/${dir}

    echo -e '\n--------------------------------------------------'
    echo -e 'Pulling images...\n'

    docker pull $calicoCniRep
    docker pull $calicoKubeRep
    docker pull $calicoNodeRep

    docker pull $ciliumRep
    docker pull $corednsRep
    docker pull $dashboardRep
    docker pull $flannelRep

    docker pull $metricsRep
    docker pull $pauseRep
    docker pull $traefikRep


    echo -e '\n--------------------------------------------------'
    echo -e 'Saving images...\n'

    echo -e calico
    docker save -o /tmp/${dir}/calico_${calicoVer}.tar $calicoCniRep $calicoKubeRep $calicoNodeRep

    echo -e cilium
    docker save -o /tmp/${dir}/cilium_${ciliumVer}.tar $ciliumRep

    echo -e coredns
    docker save -o /tmp/${dir}/coredns_${corednsVer}.tar $corednsRep

    echo -e dashboard
    docker save -o /tmp/${dir}/dashboard_${dashboardVer}.tar $dashboardRep

    echo -e flannel
    docker save -o /tmp/${dir}/flannel_${flannelVer}.tar $flannelRep

    echo -e metrics
    docker save -o /tmp/${dir}/metrics_${metricsVer}.tar $metricsRep

    echo -e pause
    docker save -o /tmp/${dir}/pause_${pauseVer}.tar $pauseRep

    echo -e traefik
    docker save -o /tmp/${dir}/traefik_${traefikVer}.tar $traefikRep


    echo -e '\n--------------------------------------------------'
    echo -e "Packing images to /tmp/${bundle}, it will take a long time...\n"
    cd /tmp/${dir}
    tar -cJvf /tmp/${bundle} *
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
    tar -xvf "$srcFile" -C /etc/ansible/down/
    ;;


  *)
    echo -e "Usage: [dump|extract]\n"
    echo -e "dump                   Save k8s basic images and pack to file '/tmp/${bundle}'"
    echo -e "                         calico:${calicoVer}"
    echo -e "                         cilium:${ciliumVer}"
    echo -e "                         coredns:${corednsVer}"
    echo -e "                         dashboard:${dashboardVer}"
    echo -e "                         flannel:${flannelVer}"
    echo -e "                         metrics:${metricsVer}"
    echo -e "                         pause:${pauseVer}"
    echo -e "                         traefik:${traefikVer}"
    echo -e "extract <bundleFile>   Extract images to the path '/etc/ansible/down/'. Using the file under current folder if <bundleFile> not specified. "
    echo -e "                       Using the file under current folder if <bundleFile> not specified."
    exit 0
  ;;
esac



#!/bin/sh
#--------------------------------------------------
# Make istio relative images bundle for docker load
#
# @author:  waiting
# @link:    https://github.com/waitingsong/blog/blob/master/201904/assets/make_istio_images_bundle.sh
# @date:    2019.04.16
# @usage:
<<BASH
  wget https://raw.githubusercontent.com/waitingsong/blog/master/201904/assets/make_istio_images_bundle.sh
  chmod a+x make_istio_images_bundle.sh
  ./make_istio_images_bundle.sh
BASH
#--------------------------------------------------

alpineVer=latest
alpineRep=alpine:$alpineVer

busyboxVer=1.30.1
busyboxRep=busybox:$busyboxVer

istioVer=1.1.3
istioRep=istio/app:$istioVer
istioKubectlRep=istio/kubectl:$istioVer
istioCitadelRep=istio/citadel:$istioVer
istioGalleyRep=istio/galley:$istioVer
istioMixerRep=istio/mixer:$istioVer
istioMixerCodegenRep=istio/mixer_codegen:$istioVer
istioNodeAgentK8sRep=istio/node-agent-k8s:$istioVer
istioPilotRep=istio/pilot:$istioVer
istioProxyv2Rep=istio/proxyv2:$istioVer
istioProxyDebugRep=istio/proxy_debug:$istioVer
istioProxyInitRep=istio/proxy_init:$istioVer
istioProxytproxyRep=istio/proxytproxy:$istioVer
istioServicegraphRep=istio/servicegraph:$istioVer
istioSidecarInjectorRep=istio/sidecar_injector:$istioVer
istioTestPolicybackendRep=istio/test_policybackend:$istioVer

jaegertracingVer=1.9
jaegertracingRep=jaegertracing/all-in-one:$jaegertracingVer

kialiVer=v0.14
kialiRep=kiali/kiali:$kialiVer

# prometheus
prometheusVer=v2.3.1
prometheusRep=prom/prometheus:$prometheusVer

promAlertmanagerVer=v0.14.0
promAlertmanagerRep=prom/alertmanager:$promAlertmanagerVer

promNodeExporterVer=v0.15.2
promNodeExporterRep=prom/node-exporter:$promNodeExporterVer

busyboxLatestVer=latest
busyboxLatestRep=busybox:$busyboxLatestVer

configmapReloadVer=v0.1
configmapReloadRep=jimmidyson/configmap-reload:$configmapReloadVer

pcurlVer=latest
pcurlRep=pstauffer/curl:$pcurlVer

grafanaVer=5.4.0
grafanaRep=grafana/grafana:$grafanaVer

kubeStateMetricsVer=v1.3.1
kubeStateMetricsRep=mirrorgooglecontainers/kube-state-metrics:$kubeStateMetricsVer
# prometheus END

tillerVer=v2.12.3
tillerRep=jmgao1983/tiller:$tillerVer

zipkinVer=2
zipkinRep=openzipkin/zipkin:$zipkinVer

dir=istio_images_bundle_${istioVer}
bundle=${dir}.tar.xz


case "$1" in
  dump)
    rm "/tmp/${dir}" -rf
    mkdir /tmp/${dir}
    cp "$0" /tmp/${dir}

    echo -e '\n--------------------------------------------------'
    echo -e 'Pulling images...\n'

    docker pull $alpineRep
    docker pull $busyboxRep

    docker pull $istioRep
    docker pull $istioKubectlRep
    docker pull $istioCitadelRep
    docker pull $istioGalleyRep
    docker pull $istioMixerRep
    docker pull $istioMixerCodegenRep
    docker pull $istioNodeAgentK8sRep
    docker pull $istioPilotRep
    docker pull $istioProxyv2Rep
    docker pull $istioProxyDebugRep
    docker pull $istioProxyInitRep
    docker pull $istioProxytproxyRep
    docker pull $istioServicegraphRep
    docker pull $istioSidecarInjectorRep
    docker pull $istioTestPolicybackendRep

    docker pull $jaegertracingRep
    docker pull $kialiRep

    docker pull $prometheusRep
    docker pull $promAlertmanagerRep
    docker pull $promNodeExporterRep
    docker pull $busyboxLatestRep
    docker pull $configmapReloadRep
    docker pull $pcurlRep
    docker pull $grafanaRep
    docker pull $kubeStateMetricsRep

    docker pull $tillerRep
    docker pull $zipkinRep

    echo -e '\n--------------------------------------------------'
    echo -e 'Saving images...\n'

    echo -e alpine
    docker save -o /tmp/${dir}/alpine_${alpineVer}.tar $alpineRep

    echo -e busybox
    docker save -o /tmp/${dir}/busybox_${busyboxVer}.tar $busyboxRep

    echo -e istio
    docker save -o /tmp/${dir}/istio_images_${istioVer}.tar \
      $istioRep \
      $istioKubectlRep \
      $istioCitadelRep \
      $istioGalleyRep \
      $istioMixerRep \
      $istioMixerCodegenRep \
      $istioNodeAgentK8sRep \
      $istioPilotRep \
      $istioProxyv2Rep \
      $istioProxyDebugRep \
      $istioProxyInitRep \
      $istioProxytproxyRep \
      $istioServicegraphRep \
      $istioSidecarInjectorRep \
      $istioTestPolicybackendRep 

    echo -e jaegertracing
    docker save -o /tmp/${dir}/jaegertracing_${jaegertracingVer}.tar $jaegertracingRep

    echo -e kiali
    docker save -o /tmp/${dir}/kiali_${kialiVer}.tar $kialiRep

    # prometheus
    echo -e prometheus
    docker save -o /tmp/${dir}/prometheus_${prometheusVer}.tar $prometheusRep

    echo -e prom/alertmanager
    docker save -o /tmp/${dir}/alertmanager_${promAlertmanagerVer}.tar $promAlertmanagerRep

    echo -e prom/node-exporter
    docker save -o /tmp/${dir}/node-exporter_${promNodeExporterVer}.tar $promNodeExporterRep

    echo -e busybox:latest
    docker save -o /tmp/${dir}/busybox_${busyboxLatestVer}.tar $busyboxLatestRep

    echo -e configmap-reload
    docker save -o /tmp/${dir}/configmap-reload_${configmapReloadVer}.tar $configmapReloadRep

    echo -e pstauffer/curl
    docker save -o /tmp/${dir}/pstauffer_curl_${pcurlVer}.tar $pcurlRep

    echo -e grafana
    docker save -o /tmp/${dir}/grafana_${grafanaVer}.tar $grafanaRep

    echo -e kube-state-metrics
    docker save -o /tmp/${dir}/kube-state-metrics_${kubeStateMetricsVer}.tar $kubeStateMetricsRep
    # prometheus END

    echo -e tiller
    docker save -o /tmp/${dir}/tiller_${tillerVer}.tar $tillerRep

    echo -e zipkin
    docker save -o /tmp/${dir}/zipkin_${zipkinVer}.tar $zipkinRep


    echo -e '\n--------------------------------------------------'
    echo -e "Packing images to /tmp/${bundle}, it will take a long time...\n"
    cd /tmp && tar -cJvf ${bundle} ${dir}
    echo -e ''
    echo -e "Bundle file created as '/tmp/${bundle}'\n"
    ;;

  cli)
    echo -e "Step by step cli at deploy node:\n"
    echo -e export alpineVer=$alpineVer
    echo -e export busyboxVer=$busyboxVer
    echo -e export busyboxLatestVer=$busyboxLatestVer
    echo -e export istioVer=$istioVer
    echo -e export jaegertracingVer=$jaegertracingVer
    echo -e export kialiVer=$kialiVer
    echo -e export zipkinVer=$zipkinVer
    echo -e export dir=$dir
    echo -e export bundle=$bundle
    echo -e ''

    echo -e ansible kube-master,kube-node -m unarchive -a \"src=${bundle} dest=/opt/kube/images/\"
    echo -e ''

    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/alpine_${alpineVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/busybox_${busyboxVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/jaegertracing_${jaegertracingVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/kiali_${kialiVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/tiller_${tillerVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/zipkin_${zipkinVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/istio_images_${istioVer}.tar\"
    # prometheus
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/prometheus_${prometheusVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/alertmanager_${promAlertmanagerVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/node-exporter_${promNodeExporterVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/busybox_${busyboxLatestVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/configmap-reload_${configmapReloadVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/pstauffer_curl_${pcurlVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/grafana_${grafanaVer}.tar\"
    echo -e ansible kube-master,kube-node -a \"docker load -i /opt/kube/images/${dir}/kube-state-metrics_${kubeStateMetricsVer}.tar\"
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

    echo -e "Pushing images to k8s nodes, it will take a long time...\n"
    ansible kube-master,kube-node -m unarchive -a "src=${srcFile} dest=/opt/kube/images/"
    ;;

  install)
    echo -e "Loading images at k8s nodes..."
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/alpine_${alpineVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/busybox_${busyboxVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/jaegertracing_${jaegertracingVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/kiali_${kialiVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/tiller_${tillerVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/zipkin_${zipkinVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/istio_images_${istioVer}.tar"
    # prometheus
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/prometheus_${prometheusVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/alertmanager_${promAlertmanagerVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/node-exporter_${promNodeExporterVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/busybox_${busyboxLatestVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/configmap-reload_${configmapReloadVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/pstauffer_curl_${pcurlVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/grafana_${grafanaVer}.tar"
    ansible kube-master,kube-node -a "docker load -i /opt/kube/images/${dir}/kube-state-metrics_${kubeStateMetricsVer}.tar"
    ;;

  *)
    echo -e "Usage: [dump|extract|push|install|cli]\n"
    echo -e "dump                   Save istio images and pack to file '/tmp/${bundle}'"
    echo -e "                         alpine:${alpineVer}"
    echo -e "                         busybox:${busyboxVer}"
    echo -e "                         jaegertracing:${jaegertracingVer}"
    echo -e "                         kiali:${kialiVer}"
    echo -e "                         prometheus:${prometheusVer}"
    echo -e "                         alertmanager:${promAlertmanagerVer}"
    echo -e "                         node-exporter:${promNodeExporterVer}"
    echo -e "                         busybox:${busyboxLatestVer}"
    echo -e "                         pstauffer/curl:${pcurlVer}"
    echo -e "                         configmap-reload:${configmapReloadVer}"
    echo -e "                         grafana:${grafanaVer}"
    echo -e "                         kube-state-metrics:${kubeStateMetricsVer}"
    echo -e "                         tiller:${tillerVer}"
    echo -e "                         zipkin:${zipkinVer}"
    echo -e "                         istio:${istioVer} of istio/app, kubectl, citadel, galley, mixer, mixer_codegen, node-agent-k8s, pilot,"
    echo -e "                           proxyv2, proxy_debug, proxy_init, proxytproxy, servicegraph, sidecar_injector, test_policybackend \n"
    echo -e "extract <bundleFile>   Extract images to the path '/etc/ansible/down/'. Using the file under current folder if <bundleFile> not specified. "
    echo -e "push <bundleFile>      Push images in the file '${bundle}' to nodes of kube-master and kube-node via ansible."
    echo -e "                       Using the file under current folder if <bundleFile> not specified."
    echo -e "install <bundleFile>   execute \"docker load -f <isio images>\" on nodes of kube-node."
    echo -e "cli                    Generate cli string of install for executing step by step manually."
    exit 0
  ;;
esac



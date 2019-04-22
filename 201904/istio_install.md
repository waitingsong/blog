### <center> Istio v1.x 安装 </center>


#### 注意事项
---- 
- **以 `root` 用户登录系统执行以下所有操作**
- 以 `ssh` 客户端连接服务器进行操作， 比如 `xshell`, `putty`
- k8s 集群已经创建，所有节点已启动 `docker` 服务
- `docker-compose --version`


#### 资源准备
---- 
- 上传脚本[make_istio_images_bundle.sh](./assets/make_istio_images_bundle.sh)到服务器
- （可选）编辑 `make_istio_images_bundle.sh` 文件，更新相关镜像版本号（当前 istio v1.1.3）
- 服务器上下载并打包 istio 相关 docker 镜像文件
  ```bash
  ./make_istio_images_bundle.sh dump
  # Bundle file created as '/tmp/istio_images_bundle_1.1.3.tar.xz'
  ```

- 打开 [Istio release](https://github.com/istio/istio/releases) 页面下载最新版安装包并解压到当前目录,
  ```bash
  cd /usr/local/src
  curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.1.3 sh -

  ll istio-1.1.3/
  total 40
  drwxr-xr-x  2 root root  4096 Apr 13 06:36 bin
  drwxr-xr-x  6 root root  4096 Apr 13 06:36 install
  -rw-r--r--  1 root root   602 Apr 13 06:36 istio.VERSION
  -rw-r--r--  1 root root 11343 Apr 13 06:36 LICENSE
  -rw-r--r--  1 root root  5921 Apr 13 06:36 README.md
  drwxr-xr-x 15 root root  4096 Apr 13 06:36 samples
  drwxr-xr-x  7 root root  4096 Apr 13 06:36 tools
  ```

#### 推送并安装 Istio 相关镜像
---- 
```bash
./make_istio_images_bundle.sh install /tmp/istio_images_bundle_1.1.3.tar.xz
```

#### 安装 helm
---- 

#### 方案1：使用 Helm template 进行安装
---- 

注意事项

Istio 默认使用‘负载均衡器’服务对象类型。对于裸机安装或者公有云平台没有负载均衡器的情况下，安装需指定 `NodePort` 类型。

```bash
cd /usr/local/src/istio-1.1.3

kubectl create namespace istio-system

# 安装 istio-init chart，来启动 Istio CRD 的安装过程
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort | kubectl apply -f -

# 稍等一会儿执行
# 输出 53 或者 58 （若开启了 cert-manager）
kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l

# 部署与你选择的配置文件相对应的 Istio 的核心组件
helm template install/kubernetes/helm/istio --name istio --namespace istio-system --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort | kubectl apply -f -
```

#### 方案2：在 Helm 和 Tiller 的环境中使用 helm install 命令进行安装
---- 

注意事项

Istio 默认使用‘负载均衡器’服务对象类型。对于裸机安装或者公有云平台没有负载均衡器的情况下，安装需指定 `NodePort` 类型。

```bash
cd /usr/local/src/istio-1.1.3

kubectl create namespace istio-system

# 如果没有为 Tiller 创建 Service account，就创建一个
kubectl apply -f install/kubernetes/helm/helm-service-account.yaml

# 使用 Service account 在集群上安装 Tiller （应该提示已初始化）
helm init --service-account tiller

# 安装 istio-init chart，来启动 Istio CRD 的安装过程
helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort

# 稍等一会儿执行
# 输出 53 或者 58 （若开启了 cert-manager）
kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l

# 部署与你选择的配置文件相对应的 Istio 的核心组件
helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort
```

##### 确认安装情况
---- 
```bash
kubectl get svc,pod -n istio-system
```

#### 参考文档
- https://github.com/gjmzj/kubeasz/blob/master/docs/guide/istio.md
- https://istio.io/zh/docs/setup/kubernetes/install/helm/ 
- https://github.com/gjmzj/kubeasz/blob/master/docs/guide/helm.md

# <center> CentOS8 </center>


```sh
sudo lspci -v
sudo lshw -C network

```

```
  *-network:0
       description: Ethernet interface
       product: 82576 Gigabit Network Connection
       vendor: Intel Corporation
       physical id: 0
       bus info: pci@0000:04:00.0
       logical name: eth1
       version: 01
       serial: 6c:b3:11:40:94:6a
       size: 100Mbit/s
       capacity: 1Gbit/s
       width: 32 bits
       clock: 33MHz
       capabilities: pm msi msix pciexpress bus_master cap_list rom ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=igb driverversion=4.18.0-348.2.1.el8_5.x86_64 duplex=full firmware=1.2.1 ip=192.168.1.249 latency=0 link=yes multicast=yes port=twisted pair speed=100Mbit/s
       resources: irq:34 memory:fc420000-fc43ffff memory:fc000000-fc3fffff ioport:e020(size=32) memory:fc444000-fc447fff memory:fbc00000-fbffffff memory:fc448000-fc467fff memory:fc468000-fc487fff
```

要确定某个包是被哪个应用依赖或者安装的，在 CentOS 中，你可以使用 rpm 命令来查找依赖关系。以下是一些有用的命令和技巧：

    查找特定包的依赖关系：

    使用 rpm 命令可以列出一个包的依赖关系。例如，假设你要查找 example-package 这个包的依赖关系，可以执行以下命令：

```sh
rpm -qR example-package
```

这将列出 example-package 包所依赖的其他包。

查找安装了特定包的应用程序：

使用包管理工具：

如果你使用的是 yum 或者 dnf 等包管理工具来安装和管理软件包，那么这些工具通常会自动处理依赖关系，并且可以查找包的安装信息。例如，你可以使用 dnf 的 repoquery 子命令来查找特定包的依赖关系和安装者信息。

```sh
dnf repoquery --requires example-package
dnf repoquery --installed --whatrequires example-package
```

这些命令将分别列出 example-package 包的依赖关系和安装了该包的应用程序。
通过这些方法，你可以方便地查找特定包的依赖关系以及安装了该包的应用程序信息。

# LVM 逻辑卷管理器


## 概念

- PV: physical volume 物理卷
- VG: Volume Group 卷组
- LV: Logical Volume 逻辑卷

## 命令

- pvscan, pvs
- pvdisplay
- vgscan, vgs
- vgdisplay
- lvscan, lvs


## 查看磁盘分区信息

```sh
lsblk
parted -l
```

## 磁盘操作

### 划分分区用于 LVM

1. 创建系统盘分区表
   ```sh
   parted -s /dev/nvme1n1 mklabel gpt
   parted /dev/nvme1n1 p
   ```
2. 创建 boot 核心启动分区并格式化
   ```sh
   parted -s /dev/nvme1n1 mkpart Boot xfs 1M 500M
   mkfs.xfs /dev/nvme1n1p1
   ```
3. 设置启动标志
   ```sh
   parted -s /dev/nvme1n1p1 set 1 boot on
   ```
4. 划分系统盘剩余空间分区为 LVM 卷
   ```sh
   parted -s /dev/nvme1n1 mkpart LVM 500M 90%
   ```
5. 初始化物理卷
   ```sh
   pvcreate /dev/nvme1n1p2
   # 直接初始化整个磁盘
   # pvcreate /dev/vda
   ```
6. 扫描物理卷，创建卷组数据库，第一次创建lvm必须运行此命令
   ```sh
   pvscan                                  
   ```
7. 指定分区创建 VG
   ```sh
   vgcreate -s 100M vg0 /dev/sdb1 /dev/sdb2
   vgcreate -s 100M vg2 /dev/nvme1n1p2
   ```
8. 查看卷组的信息
   ```sh
   vgdisplay vg0
   ```
9. 创建逻辑卷
   - 名为 root (/dev/root) 的逻辑卷
     ```sh
     lvcreate -n root -L 30G vg2           
     ```
   - 名为 data，大小为 VG 剩余空间中 95% 容量的逻辑卷
     ```sh
     lvcreate -n data -l 95%FREE vg0           
     ```
   - 创建逻辑卷用 `-l` 指定块数，若默认块大小 100MB, 即分配逻辑卷 500MB大小
     ```sh
     lvcreate -n test -l 5 vg0             
     ```

### 格式化挂载分区

```sh
mkfs.xfs /dev/vg0/data			
```

若 `ftype=0` 则重新格式化
```sh
mkfs.xfs -f -n ftype=1 /dev/vg0/data
```

创建挂载点并挂载
```sh
mkdir /data
mount /dev/vg0/data /data
```

查看信息
```sh
lvdisplay /dev/vg0/data
vgdispaly vg0
```

编辑 /etc/fstab 自动挂载/data
```sh
/dev/mapper/vg0-data    /data                   xfs             defaults        0 0
# OR 
sudo echo '/usr/bin/mount /dev/mapper/vg0-data /data' >> /etc/rc.local
```


### 移除物理卷


`pvmove` 将数据移走，但 sdb1 还在 VG 内，还是属于卷组分区，`vgreduce` 将分区从 VG 中删除
```sh
pvmove /dev/sdb1                          
vgreduce vg0 /dev/sdb1 
```
 

### 建立快照（备份数据）
```sh
lvcreate –s –L 52M –n snap /dev/vg0/data
```

> -s    表示快照  
> -L    快照大小要大于或等于被创建的逻辑卷data  
> -n    快照名称  
> 快照不用格式化即可使用
 

### 删除逻辑卷

1. `umount`所有 LV
2. 休眠 VG 以便删除
   ```sh
   vgchange -an /dev/vg0
   # 重新激活 VG 命令
   vgchange -ay /dev/vg0
   ```
3. 通过lvscan查看 如有快照，先移除快照再移除逻辑卷。
   ```sh
   lvremove /dev/vg0/data
   ```
4. 删除 VG
   ```sh
   vgremove vg0
   ```

使用过程中，如有错误，可查看系统日志
```sh
tail /var/log/message
```

### 根分区使用 LVM 设备

1. 创建 LVM 设备
2. 用 `lvmcreate-initrd` 命令在 boot 分区创建支持lvm功能的虚拟磁盘镜像文件
3. 修改 `grub.conf` 加载此镜像文件


如果使用 `lvrename` 修改了 LVM 名 需要同步修改 `/etc/grub.conf` !!!


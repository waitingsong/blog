# 云服务器挂载 LVM 逻辑卷

## 查看磁盘分区信息

```sh
lsblk
parted -l
```

## 磁盘操作

1. 初始化物理卷
   ```sh
   # 直接初始化整个磁盘
   pvcreate /dev/vdb
   ```
2. 扫描物理卷，创建卷组数据库，第一次创建lvm必须运行此命令
   ```sh
   pvscan                                  
   ```
3. 指定分区创建 VG -s 指定块大小
   ```sh
   vgcreate -s 100M vg0 /dev/vdb
   ```
4. 查看卷组的信息
   ```sh
   vgdisplay vg0
   ```
5. 创建逻辑卷
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
vgdisplay vg0
```

编辑 /etc/fstab 自动挂载/data
```sh
/dev/mapper/vg0-data    /data                   xfs             defaults        0 0
# OR 
sudo echo '/usr/bin/mount /dev/mapper/vg0-data /data' >> /etc/rc.local
```




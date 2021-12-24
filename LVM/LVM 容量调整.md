# LVM 卷在线容量调整

## 扩容
 
0. 检查分区
   ```sh
   partprobe
   ```
   
1. 判断空闲空间位置，如果是新挂接的分区先创建 PV，然后添加到指定 VG 中
   ```sh
   pvcreate /dev/sdc
   pvcreate /dev/nvme1n1p2
   pvscan 
   vgs
   vgextend vg0 /dev/sdc
   vgextend vg0 /dev/nvme1n1p2
   vgdisplay
   pvdisplay -m
   ```

   或者执行
   ```sh
   vgs -o +vg_free_count,vg_extent_count
   ```
   >	This tell vgs to add the free extents and the total number of extents to the end of the vgs listing. 
   > Use the free extent number the same way you would in the above vgdisplay case.  
   > https://www.tldp.org/HOWTO/html_single/LVM-HOWTO/#AEN391


   如果是初始化整个磁盘作为 LVM 分区，执行
   ```sh
   pvresize /dev/vda
   ```
   
   然后查看 PV 是否增加：
   
   ```sh
   sudo pvs
     PV         VG   Fmt  Attr PSize   PFree  
     /dev/sda2  vg0  lvm2 a--   29.70g   3.21g
     /dev/vda   vg1  lvm2 a--  730.00g 160.00g
   sudo vgs
     VG   #PV #LV #SN Attr   VSize   VFree  
     vg0    1   3   0 wz--n-  29.70g   3.21g
     vg1    1   1   0 wz--n- 730.00g 160.00g
   ```


2. 根据空闲 PE 块扩容 LVM： 
   ```sh
   lvs
   # +200PE块
   lvresize -l +200 /dev/vg0/data
   # +600GB
   lvresize -L +600G /dev/vg0/data
   ```

3. 在线扩容文件系统

   **对于 xfs 分区只能扩大不能缩小并且执行对象是挂载点而不是设备名**

   ```sh
   fsadm resize /dev/vg0/data
   # OR
   xfs_growfs /data
   ```
   
   ```
   # fsadm resize /dev/vg0/data
   meta-data=/dev/mapper/vg0-data   isize=512    agcount=4, agsize=22648832 blks
            =                       sectsz=512   attr=2, projid32bit=1
            =                       crc=1        finobt=1, sparse=1, rmapbt=0
            =                       reflink=1
   data     =                       bsize=4096   blocks=90595328, imaxpct=25
            =                       sunit=0      swidth=0 blks
   naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
   log      =internal log           bsize=4096   blocks=44236, version=2
            =                       sectsz=512   sunit=0 blks, lazy-count=1
   realtime =none                   extsz=4096   blocks=0, rtextents=0
   ```


## 指定 PV 进行 LV 扩容

1. 查看信息
   ```sh
   pvdisplay -m
   lvdisplay -m /dev/vg0/log
   ```
   输出
   ```
     --- Logical volume ---
    LV Path                /dev/vg0/log
    LV Name                log
    VG Name                vg0
    LV Write Access        read/write
    LV Creation host, time gitlab, 2020-11-30 09:55:08 +0800
    LV Status              available
    # open                 1
    LV Size                20.00 GiB
    Current LE             640
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     8192
    Block device           253:2

    --- Segments ---
    Logical extents 0 to 639:
      Type		linear
      Physical volume	/dev/nvme0n1p3
      Physical extents	1856 to 2495
   ```
2. 扩容
   ```sh
   # 测试
   lvresize /dev/vg0/log /dev/nvme1n1p2 -l +640 -t
   # 执行
   lvresize /dev/vg0/log /dev/nvme1n1p2 -l +640
   ```
   输出
   ```
   Size of logical volume vg0/log changed from 20.00 GiB (640 extents) to 40.00 GiB (1280 extents).
   Logical volume vg0/log successfully resized.
   ```
3. 查看信息
   ```sh
   pvdisplay -m
   lvdisplay -m /dev/vg0/log
   ```
   输出
   ```
     --- Logical volume ---
    LV Path                /dev/vg0/log
    LV Name                log
    VG Name                vg0
    LV Write Access        read/write
    LV Creation host, time gitlab, 2020-11-30 09:55:08 +0800
    LV Status              available
    # open                 1
    LV Size                40.00 GiB
    Current LE             1280
    Segments               2
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:2

    --- Segments ---
    Logical extents 0 to 639:
      Type		linear
      Physical volume	/dev/nvme0n1p3
      Physical extents	1856 to 2495

    Logical extents 640 to 1279:
      Type		linear
      Physical volume	/dev/nvme1n1p2
      Physical extents	25017 to 25656
   ```
4. 更新文件系统（略）


## 缩容

**对于XFS分区只能扩大不能缩小并且执行对象是挂载点而不是设备名**

1. 减小分区容量到比预期值更小的值
   ```sh
   fsadm -e resize /dev/vg0/varlog 5G
   # 如果提示卷无法被卸载，执行命令查找占用进程停止或杀掉
   fuser -m -v /var/vg0/varlog
   ```

2. 减小PE块
   ```sh
   lvresize -L -5G /dev/vg0/varlog
   umount /var/log
   fsck -f /var/log
   fsadm resize /dev/vg_localhost/LVLOG 
   mount /dev/vg_localhost/LVLOG /var/log
   ```


## 指定 PV 进行 LV 缩容

1. 卸载分区（略）
2. 减小分区容量到比预期值更小的值
   ```sh
   fsadm -e resize /dev/vg0/varlog 5G
   # 如果提示卷无法被卸载，执行命令查找占用进程停止或杀掉
   fuser -m -v /var/vg0/varlog
   ```
3. 查看信息
   ```sh
   pvdisplay -m
   lvdisplay -m /dev/vg0/log
   ```
   输出
   ```
     --- Logical volume ---
    LV Path                /dev/vg0/log
    LV Name                log
    VG Name                vg0
    LV Write Access        read/write
    LV Creation host, time gitlab, 2020-11-30 09:55:08 +0800
    LV Status              available
    # open                 1
    LV Size                40.00 GiB
    Current LE             1280
    Segments               2
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:2

    --- Segments ---
    Logical extents 0 to 639:
      Type		linear
      Physical volume	/dev/nvme0n1p3
      Physical extents	1856 to 2495

    Logical extents 640 to 1279:
      Type		linear
      Physical volume	/dev/nvme1n1p2
      Physical extents	25017 to 25656
   ```
4. 缩小
   ```sh
   # 测试
   lvresize /dev/vg0/log /dev/nvme1n1p2 -l -640 -t
   # 执行
   lvresize /dev/vg0/log /dev/nvme1n1p2 -l -640
   ```
   输出
   ```
   Ignoring PVs on command line when reducing.
   WARNING: Reducing active and open logical volume to 20.00 GiB.
   THIS MAY DESTROY YOUR DATA (filesystem etc.)
   Do you really want to reduce vg0/log? [y/n]: y
   Size of logical volume vg0/log changed from 40.00 GiB (1280 extents) to 20.00 GiB (640 extents).
   Logical volume vg0/log successfully resized.
   ```
5. 查看信息
   ```sh
   lvdisplay -m /dev/vg0/log
   ```
   输出
   ```
     --- Logical volume ---
    LV Path                /dev/vg0/log
    LV Name                log
    VG Name                vg0
    LV UUID                v4ebdE-xLV4-ve06-Cw81-1EPd-BESe-cfwodu
    LV Write Access        read/write
    LV Creation host, time gitlab, 2020-11-30 09:55:08 +0800
    LV Status              available
    # open                 1
    LV Size                20.00 GiB
    Current LE             640
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:2

    --- Segments ---
    Logical extents 0 to 639:
      Type		linear
      Physical volume	/dev/nvme0n1p3
      Physical extents	1856 to 2495

   ```
6. 更新文件系统（略）


## 在 PV 间迁移 LV

1. 查看信息
   ```sh
   lvdisplay -m /dev/vg0/log
   ```

   输出
   ```
     --- Logical volume ---
     LV Path                /dev/vg0/log
     LV Name                log
     VG Name                vg0
     LV UUID                v4ebdE-xLV4-ve06-Cw81-1EPd-BESe-cfwodu
     LV Write Access        read/write
     LV Creation host, time gitlab, 2020-11-30 09:55:08 +0800
     LV Status              available
     # open                 1
     LV Size                20.00 GiB
     Current LE             640
     Segments               1
     Allocation             inherit
     Read ahead sectors     auto
     - currently set to     256
     Block device           253:2
   
     --- Segments ---
     Logical extents 0 to 639:
       Type		linear
       Physical volume	/dev/nvme0n1p3
       Physical extents	1856 to 2495
   ```
2. 迁移

   ```sh
   # 测试
   pvmove -t -n log /dev/nvme0n1p3 /dev/nvme1n1p2 
   # 执行
   pvmove -n log /dev/nvme0n1p3 /dev/nvme1n1p2 
   ```

   输出
   ```
   /dev/nvme0n1p3: Moved: 0.00%
   /dev/nvme0n1p3: Moved: 87.50%
   /dev/nvme0n1p3: Moved: 100.00%
   ```
3. 检查
   ```sh
   lvdisplay -m
   ```

   输出
   ```
     --- Logical volume ---
     LV Path                /dev/vg0/log
     LV Name                log
     VG Name                vg0
     LV Write Access        read/write
     LV Creation host, time gitlab, 2020-11-30 09:55:08 +0800
     LV Status              available
     # open                 1
     LV Size                20.00 GiB
     Current LE             640
     Segments               1
     Allocation             inherit
     Read ahead sectors     auto
     - currently set to     256
     Block device           253:2
   
     --- Segments ---
     Logical extents 0 to 639:
       Type		linear
       Physical volume	/dev/nvme1n1p2
       Physical extents	25017 to 25656
   ```

   ```sh
   pvdisplay -m
   ```
   输出
   ```
     --- Physical volume ---
    PV Name               /dev/nvme1n1p2
    VG Name               vg0
    PV Size               <837.90 GiB / not usable 22.00 MiB
    Allocatable           yes
    PE Size               32.00 MiB
    Total PE              26812
    Free PE               1155
    Allocated PE          25657

    --- Physical Segments ---
    Physical extent 0 to 25016:
      Logical volume	/dev/vg0/data
      Logical extents	11642 to 36658
    Physical extent 25017 to 25656:
      Logical volume	/dev/vg0/log
      Logical extents	0 to 639
    Physical extent 25657 to 26811:
      FREE
   ```


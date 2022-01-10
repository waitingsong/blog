# <center> Linux 常用工具安装 </center>


## z 

可以让你快速地在文件目录之间跳转。它会记住你访问的历史文件夹，经过短暂的学习后，你就可以使用 `z` 命令在目录之间跳转了

```sh
z tmp
z usr bin
```

[https://github.com/rupa/z](https://github.com/rupa/z)

安装：
```sh
wget https://github.com/waitingsong/blog/raw/main/Linux/bin/z-1.9.tar.gz
tar -xf z-1.9.tar.gz
sudo mv z-1.9 /usr/local/bin/
echo ". /usr/local/bin/z-1.9/z.sh"  >> ~/.bashrc
echo ". /usr/local/bin/z-1.9/z.sh"  >> ~/.profile
. /usr/local/bin/z-1.9/z.sh
```


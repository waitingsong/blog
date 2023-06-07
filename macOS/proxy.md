

```sh
brew install nmap

```

vi ~/.ssh/config
```
Host github.com
  user git
  ProxyCommand=ncat --proxy-type socks5 --proxy 192.168.1.2:7890 %h %p
```

test:
```sh
git clone git@github.com:torvalds/linux.git
```
# Cloudflare tunnel to expose server

## Build and install cloudflare tunnel from source

```bash
#!/bin/sh
echo "--upgrading packages"
pkg update

echo "-- installing dependancies: golang git debianutils make"
pkg install golang git debianutils make

echo "-- Downloading cloudflared source"
git clone https://github.com/cloudflare/cloudflared.git --depth=1
cd cloudflared
sed -i 's/linux/android/g' Makefile

echo "-- Building and installing cloudflared"
export CGO_ENABLED=0
make cloudflared
install cloudflared $PREFIX/bin

cd ..
rm -rf cloudflared

cloudflared --version
echo "--Install complete"
```

## Running the cloudflare tunnel to expose a port

```bash
cloudflared  tunnel --url localhost:8080
```

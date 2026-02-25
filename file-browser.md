# FileBrowser as storage server

## Build and install from source

```bash
pkg update -y && pkg upgrade -y || exit 1
pkg install -y git golang nodejs-lts || exit 1

npm install -g pnpm || exit 1

cd "$HOME" || exit 1
rm -rf filebrowser

git clone https://github.com/filebrowser/filebrowser.git || exit 1
cd filebrowser || exit 1

git checkout "$(git describe --tags $(git rev-list --tags --max-count=1))" || exit 1

export NODE_OPTIONS=--max-old-space-size=4096

cd frontend || exit 1
pnpm install || exit 1
pnpm build --minify=false --sourcemap=false || exit 1
cd ..

CGO_ENABLED=0 go build -tags embed -o filebrowser || exit 1

mv -f filebrowser "$PREFIX/bin/" || exit 1
chmod +x "$PREFIX/bin/filebrowser" || exit 1

echo "Installed successfully"
echo "Run with:"
echo "filebrowser -r ~/storage --address 0.0.0.0 --port 8080"
```

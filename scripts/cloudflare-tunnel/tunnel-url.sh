METRICS_PORT=20242
until curl -s "http://127.0.0.1:${METRICS_PORT}/metrics" \
      | sed -n 's/.*userHostname="\([^"]*\)".*/\1/p' \
      | grep -q 'trycloudflare.com'; do
  sleep 0.2
done
TEMP_DIR=$(mktemp -d)
curl -s "http://127.0.0.1:${METRICS_PORT}/metrics" \
  | sed -n 's/.*userHostname="\([^"]*\)".*/\1/p' \
  | head -n1 > $TEMP_DIR/tunnel_url.txt
echo "Tunnel URL: $(cat $TEMP_DIR/tunnel_url.txt)"
rm -rf TEMP_DIR

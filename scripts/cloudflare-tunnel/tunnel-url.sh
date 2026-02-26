METRICS_PORT=4040
until curl -s "http://127.0.0.1:${METRICS_PORT}/metrics" \
      | sed -n 's/.*userHostname="\([^"]*\)".*/\1/p' \
      | grep -q 'trycloudflare.com'; do
  sleep 0.2
done
curl -s "http://127.0.0.1:${METRICS_PORT}/metrics" \
  | sed -n 's/.*userHostname="\([^"]*\)".*/\1/p' \
  | head -n1 > /tmp/tunnel_url.txt
echo "Tunnel URL: $(cat /tmp/tunnel_url.txt)"

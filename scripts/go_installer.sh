export GOLANG="$(curl -s https://go.dev/dl/ | awk -F[\>\<] '/linux-armv6l/ && !/beta/ {print $5;exit}')"
wget "https://golang.org/dl/$GOLANG"
sudo tar -C "/usr/local" -xzf "$GOLANG"
rm "$GOLANG"
unset GOLANG

sudo apt-get update
sudo apt-get install -y git vim
rm -rf hab*
wget 'https://api.bintray.com/content/habitat/stable/linux/x86_64/hab-$latest-x86_64-linux.tar.gz?bt_package=hab-x86_64-linux' -O hab.tar.gz
mkdir -p hab
tar xvzf hab.tar.gz -C ./hab --strip-components 1
sudo mv hab/hab /usr/local/bin/hab
sudo chmod +x /usr/local/bin/hab
sudo useradd hab -u 42 -g 42 -d / -s /bin/sh -r
sudo groupadd -og 42 hab

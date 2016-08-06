# Rocket.chat

This module assumes you will install rocketchat through an RPM with a selfcontained Nodejs environment.

Instructions on how to recreate the RPM:

Requisites
```
- install fpm (https://github.com/jordansissel/fpm)
- install nodeenv (hint: fpm -s python -t rpm nodeenv)
- install nodejs/npm to install the dependencies of rocketchat
```

Download Rocket.chat
```
wget https://cdn-download.rocket.chat/build/rocket.chat-0.36.0.tgz
```
Extract
```
tar -zxvf *.tgz
```
Cleanup
```
rm -fr ./*.tgz
```
Create a selfcontained nodejs environment
```
nodeenv --node=0.10.40 --prebuilt --jobs=4 ./dist/opt/rocketchat
```
Move stuff around in position and create the necessary scripts and config files
```
mv ./bundle/* ./dist/opt/rocketchat/
cd ./dist/opt/rocketchat/programs/server
npm install
cd ../../../../../

echo -e "chmod +x /opt/rocketchat/bin/node\nsystemctl daemon-reload" > after-install.sh
echo -e "chmod +x /opt/rocketchat/bin/node\nsystemctl daemon-reload" > after-upgrade.sh
echo -e "systemctl stop rocketchat\n" > before-remove.sh
echo -e "systemctl daemon-reload\n" > after-remove.sh
mkdir -p ./dist/etc/systemd/system/
mkdir -p ./dist/etc/rocketchat/

cat > ./dist/etc/rocketchat/rocketchat.conf <<- EOM
ROOT_URL=http://your-host-name.com-as-accessed-from-internet:3000/
MONGO_URL=mongodb://localhost:27017/rocketchat
PORT=3000
EOM

cat > ./dist/etc/systemd/system/rocketchat.service <<- EOM
[Unit]
Description=rocketchat
After=network.target

[Service]
Type=simple
# Edit WorkingDirectory, User and Group as needed
WorkingDirectory=/opt/rocketchat
User=nobody
Group=nobody
ExecStart=/bin/bash -c "source ./bin/activate; exec node ./main.js"
SyslogIdentifier=rocketchat
EnvironmentFile=/etc/rocketchat/rocketchat.conf

[Install]
WantedBy=multi-user.target
EOM

chmod +x ./dist/opt/rocketchat/bin/node

```
Package using fpm
```
fpm \
-s dir \
-t rpm \
-n rocketchat \
--iteration 0.36.0 \
--version 1 \
--no-rpm-autoreqprov \
--architecture 'x86_64' \
--description "Selfcontained NodeJS Rocketchat with nodeenv" \
--rpm-use-file-permissions \
--rpm-user root \
--rpm-group root \
--after-install after-install.sh \
--after-upgrade after-upgrade.sh \
--before-remove before-remove.sh \
--after-remove after-remove.sh \
-C dist/
```
Place the resulting RPM in your repository or just install it on the target machine.

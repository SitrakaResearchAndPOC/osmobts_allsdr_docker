# Installation osmoBTS from USRP
## Installing tools
```
apt update
```
```
apt install docker.io wget
```
## Preparing Dockerfile
```
rm -rf osmobts_usrp && mkdir osmobts_usrp && cd osmobts_usrp
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/osmobts_allsdr_docker/refs/heads/main/usrp/Dockerfile
```
## Building images
```
docker  build -t osmobts_usrp:v1 .
```
## Launching container
```
docker rm -f osmobts_usrp
```
```
docker run -itd --privileged -v /dev/bus/usb:/dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v $XAUTHORITY:/home/user/.Xauthority:ro --net=host --env="DISPLAY=$DISPLAY" --env="LC_ALL=C.UTF-8" --env="LANG=C.UTF-8"  --name osmobts_usrp -h osmobts_usrp osmobts_usrp:v1
```
## Testing driver USRP
```
docker exec -it osmobts_usrp uhd_find_devices
```
```
docker exec -it osmobts_usrp uhd_usrp_probe
```
## Launching BTS
```
docker exec -it osmobts_usrp bash -c 'cd /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE/ && bash start_base.sh'
```
```
docker exec -it osmobts_usrp bash -c 'cd /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE/ && bash start_master.sh'
```

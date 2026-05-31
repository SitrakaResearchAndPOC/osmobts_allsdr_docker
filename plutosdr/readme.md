# Installation osmoBTS from PlutoSDR
## Flashing firmeware 
[Flashing_firmeware](https://github.com/SitrakaResearchAndPOC/osmobts_allsdr_docker/tree/main/plutosdr/firmeware)

## Installing tools
```
apt update
```
```
apt install docker.io wget
```
## Preparing Dockerfile
```
rm -rf osmobts
```
```
mkdir osmobts
```
```
cd osmobts
```
```
wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/osmobts_allsdr_docker/refs/heads/main/plutosdr/Dockerfile
```
## Building images
```
docker  build -t osmobts_pluto:v1 .
```
## Launching container
```
docker rm -f osmobts_pluto
```
```
docker rm -f  osmobts_pluto && docker run -tid --privileged \
  --cgroupns=host \
  --net=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /dev:/dev \
  -v /dev/bus/usb:/dev/bus/usb \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v /home/user/.Xauthority:/home/user/.Xauthority:ro \
  --tmpfs /run \
  --tmpfs /run/lock \
  --env="DISPLAY=$DISPLAY" \
  --env="LC_ALL=C.UTF-8" \
  --env="LANG=C.UTF-8" \
  --cap-add=sys_nice \
  --cap-add=ipc_lock \
  --ulimit rtprio=99 \
  --ulimit memlock=-1 \
  --name osmobts_pluto \
  --hostname osmobts_pluto \
  osmobts_pluto:v1
```

## Testing driver PlutoSDR
```
xhost +
```
Change the <IP_ADDRESS>
```
ssh-keygen -R '<IP_ADDRESS>' && docker exec -ti osmobts_pluto bash -c 'ping <IP_ADDRESS>'
```
or test ssh
```
docker exec -ti osmobts_pluto bash -c 'ssh root@<IP_ADDRESS>'
```
</br>
MDP is `analog`

```
docker exec -ti osmobts_pluto bash -c 'SoapySDRUtil --info'
```
```
docker exec -ti osmobts_pluto bash -c 'SoapySDRUtil --find'
```
```
docker exec -ti osmobts_pluto bash -c 'SoapySDRUtil --probe="driver=plutosdr"'
```

## Launching BTS
Launching the core network
```
docker exec -it osmobts_pluto bash -c 'cd /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE/ && bash start_master.sh'
```
Launching the RAN network
```
docker exec -it osmobts_pluto bash -c 'cd /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE/ && bash start_base.sh'
```

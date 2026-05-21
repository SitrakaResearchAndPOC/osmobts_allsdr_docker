docker  build -t osmobts_pluto:v1 .

docker rm -f osmobts_pluto

docker run -tid --privileged \
  --cgroupns=host \
  --net=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /dev:/dev \
  -v /dev/bus/usb:/dev/bus/usb \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v $XAUTHORITY:/home/user/.Xauthority:ro \
  --tmpfs /run \
  --tmpfs /run/lock \
  --env="DISPLAY=$DISPLAY" \
  --env="LC_ALL=C.UTF-8" \
  --env="LANG=C.UTF-8" \
  --name osmobts_pluto \
  --hostname osmobts_pluto \
  osmobts_pluto:v1
  
xhost +

docker exec -ti osmobts_pluto bash -c 'ping 192.168.20.1'

or test ssh

docker exec -ti osmobts_pluto bash -c 'ssh root@192.168.20.1'
MDP is analog

docker exec -ti osmobts_pluto bash -c '$SRS_INSTALL/bin/SoapySDRUtil --info'

docker exec -ti osmobts_pluto bash -c '$SRS_INSTALL/bin/SoapySDRUtil --find'

  

docker exec -it osmobts_pluto bash -c 'cd /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE/ && bash start_base.sh'

docker exec -it osmobts_pluto bash -c 'cd /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE/ && bash start_master.sh'

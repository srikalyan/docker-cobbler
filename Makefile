build:
	@docker build -t cobbler .

run:
	@docker run \
	  -d \
	  --privileged \
	  --net host \
	  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	  -v $(shell pwd)/etc/cobbler/settings:/etc/cobbler/settings \
	  -v $(shell pwd)/etc/cobbler/dhcp.template:/etc/cobbler/dhcp.template \
	  -v $(shell pwd)/dist/ubuntu:/mnt:ro \
	  -v $(shell pwd)/var/www/cobbler/images:/var/www/cobbler \
	  -v $(shell pwd)/var/www/cobbler/ks_mirror:/var/www/cobbler/ks_mirror \
	  -v $(shell pwd)/var/www/cobbler/links:/var/www/cobbler/links \
	  -v $(shell pwd)/var/lib/cobbler/config:/var/lib/cobbler/config \
	  -v $(shell pwd)/var/lib/tftpboot:/var/lib/tftpboot \
	  -p 69:69 \
	  -p 53:53 \
	  -p 80:80 \
	  -p 443:443 \
	  -p 25151:25151 \
	  --name cobbler cobbler

clean:
	@docker rm  -f cobbler > /dev/null || true

mount:
	sudo mount -t iso9660 -o loop,ro -v $(shell pwd)/dist/ubuntu-14.04.5-server-amd64.iso dist/ubuntu

tty:
	@docker exec -it cobbler /bin/bash

stop:
	@docker stop cobbler

start:
	@docker start cobbler

import:
	@docker exec -it cobbler cobbler import --name=ubuntu_trusty --path=/mnt/

umount:
	sudo umount dist/ubuntu

all: build mount run import


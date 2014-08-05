Docker Debian image
===================

This image is used as base for other docker images and usable as is. It embeds ssh server.
Services are managed by runit http://smarden.org/runit/

How to use
----------

	docker pull ahmet2mir/debian:wheezy

Or run it directly (it will make the pull)

	docker run -d -P --name containername ahmet2mir/debian:wheezy

To connect to the machine you need to know the published port (-P publish all ports).
You can find it with
	
	docker port containername 22
	
Is more simple to use the "docker ssh" (like vagrant ssh) http://muehe.org/posts/ssh-into-docker-containers-by-name/
	
	curl -s https://raw.githubusercontent.com/henrik-muehe/docker-ssh/master/install | /bin/bash
	ssh containername.docker

Login/password

	docker/docker

OR with key stored in ssh folder in this repo combined to docker-ssh

	cp <thisrepo>/ssh/docker_rsa ~/.ssh/docker_rsa
	chmod 600 ~/.ssh/docker.key

Edit ~/.ssh/config, I prefer .dock rather than .docker and configure the ssh key.

	Host *.dock
	    IdentityFile ~/.ssh/docker_rsa
	    ProxyCommand ~/.ssh/docker-proxy %h %p

And docker-proxy

	sed -i 's/\.docker/\.dock/g' ~/.ssh/docker-proxy

And now

	ssh containername.dock


License
-------

Apache 2 http://en.wikipedia.org/wiki/Apache_License

build:
	docker build -t ahmet2mir/debian:wheezy .
run:
	docker run -d -P -h wheezy --name wheezy ahmet2mir/debian:wheezy
clean:
	docker stop wheezy; docker rm wheezy
log:
	docker logs -f wheezy
port:
	docker port wheezy 22

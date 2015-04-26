all: build publish

build:
	docker build -t melopt/docker-introspect .

publish:
	docker push melopt/docker-introspect

run: build
	docker run --restart always -d --name docker-introspect -p 169.254.42.42:4242:4242 melopt/introspect

try: build
	docker run --rm -it --name docker-introspect -p 169.254.42.42:4242:4242 melopt/introspect

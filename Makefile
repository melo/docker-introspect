IMAGE=melopt/docker-introspect

all: build publish

build:
	docker build -t "${IMAGE}" .

publish:
	docker push "${IMAGE}"

run: build
	docker run --restart always -d --name docker-introspect -p 169.254.42.42:4242:4242 "${IMAGE}"

try: build
	docker run --rm -it --name docker-introspect -p 169.254.42.42:4242:4242 "${IMAGE}"

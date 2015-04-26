all: build publish

build:
	docker build -t melopt/docker-introspect .

publish:
	docker push melopt/docker-introspect

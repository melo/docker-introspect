# Docker-introspect #

The docker-introspect service provides a HTTP API that your containers
can use to obtain information useful to them.

It is mostly helpful to allow containers to obtain the host IP address
and their own port mappings, to update service discovery solutions like
[Consul](https://www.consul.io/).

This solution is inspired by the
[EC2 instance metadata service](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html).

The choices made during the design and development of this solution
assume the following assumptions:

* you have control of the host system where `dockerd` runs;
* you have no control on how containers are started (i.e. you cannot
  interfere how `docker run` is called);
* you can alter the container images that you are going to run to use
  this service.

These mirror our restrictions at $work, using AWS ECS. YMMV.


# Is this really needed??

Unfortunately yes. There are a couple of issues open on Docker that
should eventually cover this, and make this software obsolete:

* [#8427](https://github.com/docker/docker/issues/8427): this actually
  proposes something similar to docker-introspect solution;
* [#7472](https://github.com/docker/docker/issues/7472): this covers
  only getting the IP of the host, but if we have that, at least we
  could stop needing the well-known IP address.

There are a couple more issues that could be related, but these two are
the most mentioned I could find, and should cover most of the needs I
can envision at the moment for service discovery.


# How to use it #

You'll need two things:

* your host systems will need a "well known IP address": you can
  optionally map this IP to a DNS name, to provide a level of
  indirection that allows you to change the IP address, but you have
  to realise that doing that also adds another point-of-failure into
  the solution;
* the
  [melopt/docker-introspect](https://registry.hub.docker.com/u/melopt/docker-introspect/)
  image.

To run:

* add the IP (I like to use `169.254.42.42`) to your localhost interface:
    * making sure the address is added on boot depends on your OS;
    * for recent Linux-based system, this command should get you started
      (but will not survive a reboot):
        * `ip addr add 169.254.42.42 scope host dev lo`: adjust `lo` to
          your localhost interface;
        * note: `scope host` doesn't work on all systems, for example
          Amazon Linux, you can remove it.
* start the image: `docker run --restart=always -d -p 169.254.42.42:4242:4242 melopt/docker-introspect`

This should make the `http://169.254.42.42:4242/` endpoint available to
your containers.

*Please note* that you can use just about any private IP, as long it is
not in use on your infrastructure. The IP `169.254.42.42` is just a
recommendation.


# API #

> *Note*: please consider this API as alpha-quality, subject to change

The API is a simple HTTP-based API that returns `text/plain` answers on
most of its methods to easy integration. You should not need a JSON
parser, or a command line tool to extract the relevant tidbits from the
answers, basic shell plus `curl` should be enough to use the API.

The endpoint of the API is `http://169.254.42.42:4242` assuming you
followed the above instructions, but you can use a different IP and
port. If you do so, adjust the endpoint accordingly.


## Versions ##

Current version of the API is `20150425`. You can also use `latest` to
access the latest version of the API.

The API version is included on the URL as the first element of the path
on all methods. In the documentation below, we'll use `<version>` as a
placeholder.


## Container ID ##

Some of the API require your container ID. At this moment, there is no
official API for a container to obtain his ID.

The best workaround we could find so far is parsing the contents of
`/etc/self/`. This one-liner will do the trick:

    grep :/docker/ /proc/self/cgroup | cut -d/ -f3 | head -1


## Host information

This APIs return information about the host where `dockerd` is running.

### `GET /<version>/host/address`

Returns the IPv4 address of the host.


## Container information

### `GET /<version>/container/<container_id>/port_mappings`

Returns a file, one port mapping per line, for the container.


# Todo

The following items will probably make it for a future version:

* use `Accept` header to return JSON replies, easier to other
  languages to parse;
* proxy some of Docker API methods: this will most likely include
  filters (better yet, a white-list) of fields to copy over.


# Author #

Pedro Melo <melo@simplicidade.org>

Written in April, 2015.

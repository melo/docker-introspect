FROM perl
MAINTAINER Pedro Melo <melo@simplicidade.org>

WORKDIR /app

COPY cpanfile /app/
RUN cpanm --quiet -n --installdeps .

COPY . /app/

EXPOSE 4242
CMD ["starman", "--workers", "4", "--port", "4242", "--preload-app", "app.psgi"]

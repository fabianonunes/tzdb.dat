# syntax=docker/dockerfile:1
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /ziupdater
RUN <<EOT
  set -ex;
  apt-get update;
  apt-get install --yes --no-install-recommends gawk lzip make;

  # builda tarball do tzdata no formato rearguard
  curl --silent --location https://data.iana.org/time-zones/releases/tzdb-2025c.tar.lz \
    | tar --extract --lzip --file - --strip 1;
  make AWK=gawk rearguard_tarballs;

  # atualiza tzdb.dat via ZIUpdater da Azul
  curl --silent --location https://cdn.azul.com/tools/ziupdater1.1.3.1-jse8+7-any_jvm.tar.gz \
    | tar --extract --gzip --file -;

  java -jar ziupdater-1.1.3.1.jar --verbose --location "file://$(realpath tzdata*.tar.gz)";
EOT

FROM scratch
COPY --from=builder /opt/java/openjdk/lib/tzdb.dat /tzdb.dat

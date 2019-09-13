FROM adoptopenjdk/openjdk11:jdk-11.0.4_11-slim AS tzdb_builder

WORKDIR /ziupdater
RUN set -ex;                                                                       \
    apt-get update;                                                                \
    apt-get install -y --no-install-recommends gawk lzip make;                     \
    # builda tarball do tzdata no formato rearguard
    curl -sL https://data.iana.org/time-zones/releases/tzdb-2019c.tar.lz |         \
        tar --extract --lzip --file - --strip 1;                                   \
    make AWK=gawk rearguard_tarballs;                                              \
    # atualiza tzdb.dat via ZIUpdater da Azul
    curl -sL https://cdn.azul.com/tools/ziupdater1.0.2.2-jse8+7-any_jvm.tar.gz |   \
        tar --extract --gzip --file -;                                             \
    java -jar ziupdater-1.0.2.2.jar -v -l "file://$(realpath tzdata*.tar.gz)";     \
    # limpa arquivos desnecessários
    apt-get purge --autoremove -y gawk lzip make;                                  \
    rm -rf /var/lib/apt/lists/* /ziupdater;

FROM busybox:1.31.0
COPY --from=tzdb_builder /opt/java/openjdk/lib/tzdb.dat /tzdb.dat

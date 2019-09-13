# tzdb.dat

Imagem Docker com o banco de dados de fusos horários da IANA compilados no formato `tzdb.dat`
compatível com uma JDK >= 8 (inclusive OpenJDK).

A compilação é feita durante o build pelo [ZIUpdater](https://www.azul.com/products/open-source-tools/ziupdater-time-zone-tool/) da Azul.

Para importar o `tzdb.dat` em outra imagem, você pode utilizar o
[_multi-stage build_](https://docs.docker.com/develop/develop-images/multistage-build/):

```Dockerfile
COPY --from=ghcr.io/fabianonunes/tzdb.dat:latest /tzdb.dat /opt/java/openjdk/lib/tzdb.dat
```

Para criar uma cópia do `tzdb.dat`, execute:

```bash
docker run --rm ghcr.io/fabianonunes/tzdb.dat:latest cat /tzdb.dat > tzdb.dat
```

A tag `latest` pode ser substituída pela versão desejada do tzdb.

## Verificar versão do `tzdb.dat`

Para verificar a versão do `tzdb.dat` de uma JVM, execute:

```bash
jshell <<< 'import java.time.zone.ZoneRulesProvider;ZoneRulesProvider.getVersions("GMT").firstEntry().getKey();'
```

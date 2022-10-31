FROM mcr.microsoft.com/dotnet/sdk:6.0.402-bullseye-slim-amd64 AS deps

WORKDIR /build

COPY IronSegFault ./IronSegFault
COPY IronSegFault.sln ./

RUN dotnet restore && rm -rf ~/.local

RUN dotnet publish IronSegFault \
    --no-restore \
    --nologo \
    --no-self-contained \
    --configuration Release \
    --output /published/web \
 && rm -rf /build



FROM mcr.microsoft.com/dotnet/aspnet:6.0.10-bullseye-slim-amd64 AS runtime
LABEL stage=runtime

COPY --from=deps /published/web/ ./web
COPY ./*.sh /
RUN chmod u+x /*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]
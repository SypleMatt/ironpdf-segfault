# base runtime image (Debian 11 w/ .NET6 runtime)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
# install necessary packages
RUN apt update \
    && apt install -y libgdiplus libxkbcommon-x11-0 libc6 libc6-dev libgtk2.0-0 libnss3 libatk-bridge2.0-0 libx11-xcb1 libxcb-dri3-0 libdrm-common libgbm1 libasound2 libxrender1 libfontconfig1 libxshmfence1
# IronPDF requires read and write access for log files and to execute for Embedded Google Chromium Class Libraries
RUN chmod +rwx .
# base development image (Debian 11 w/ .NET6 SDK)
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
# restore NuGet packages
COPY ["IronSegFault/IronSegFault.csproj", "IronSegFault/"]
RUN dotnet restore "IronSegFault/IronSegFault.csproj"
# build project
COPY . .
WORKDIR "/src/IronSegFault"
RUN dotnet build "IronSegFault.csproj" -c Release -o /app/build
# publish project
FROM build AS publish
RUN dotnet publish "IronSegFault.csproj" -c Release -o /app/publish
# run app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "IronSegFault.dll"]
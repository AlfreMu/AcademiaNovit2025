# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /publish

# Copiamos solo el .csproj para restaurar dependencias
COPY ./AcademiaNovit/AcademiaNovit.csproj ./AcademiaNovit/
RUN dotnet restore ./AcademiaNovit/AcademiaNovit.csproj

# Copiamos todo el código fuente (solo el proyecto principal)
COPY ./AcademiaNovit ./AcademiaNovit
WORKDIR /publish/AcademiaNovit
RUN dotnet publish -c Release -o /app/out

# Etapa de runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/out ./

EXPOSE 8080

ENTRYPOINT ["dotnet", "AcademiaNovit.dll"]

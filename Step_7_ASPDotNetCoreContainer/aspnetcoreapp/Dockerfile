FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# Add nodeJs required for reactjs
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs

# copy csproj and restore as distinct layers
COPY aspnetcoreapp/*.csproj ./aspnetcoreapp/
WORKDIR /app/aspnetcoreapp
RUN dotnet restore

# copy everything else and build app
WORKDIR /app
COPY aspnetcoreapp/. ./aspnetcoreapp/
WORKDIR /app/aspnetcoreapp
RUN dotnet publish -c Release -o out

FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
WORKDIR /app
COPY --from=build /app/aspnetcoreapp/out ./
ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]
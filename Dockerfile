FROM microsoft/dotnet:core

COPY /out /app
WORKDIR /app

EXPOSE 5000/tcp
ENTRYPOINT ["dotnet", "vagrant.dll"]

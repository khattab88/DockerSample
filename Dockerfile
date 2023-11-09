# Get base image
FROM mcr.microsoft.com/dotnet/sdk:7.0 As build
# Set app working (root) directory 
WORKDIR /app

# Expose port
EXPOSE 8080

# Copy .csproj file (to root directory => /app)
COPY *.csproj ./
# Restore packages
RUN dotnet restore

# Copy all files to working directory
COPY . ./

# Publish app
RUN dotnet publish -c Release -o /app/publish

# Build runtime image form base image
FROM mcr.microsoft.com/dotnet/sdk:7.0
WORKDIR /app
# Copy publish to runtime image working directory (/app)
COPY --from=build /app/publish .

# Define app entry/startup command
ENTRYPOINT ["dotnet", "DockerSample.dll"]
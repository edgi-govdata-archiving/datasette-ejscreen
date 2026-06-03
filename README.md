# Datasette Deployment

This repository contains instructions for deploying Datasette via fly.io with the single-table version of EJScreen.

## Features

- SQLite database publishing
- Interactive web interface
- JSON API for programmatic access
- Plugin ecosystem support

## Local Development

First install local dependencies (more information here: https://docs.datasette.io/en/stable/installation.html)

### Installation on Mac

1. Install Homebrew via https://brew.sh/
2. Open terminal, navigate to the cloned repository folder and run following commands:
``` 
brew install datasette
datasette install datasette-cluster-map
datasette install datasette-extract
datasette install datasette-homepage-table
datasette install datasette-publish-fly
datasette install datasette-ip-rate-limit
```

## Pushing to Fly

After completing the above steps, install Fly CLI via ```brew install flyctl```
Login using ```fly auth login```
Enter the following command to publish to fly
```
datasette publish fly ejscreen_merged.db --app datasette-ejscreen --install datasette-cluster-map --install datasette-extract --install datasette-homepage-table --install datasette-ip-rate-limit
```
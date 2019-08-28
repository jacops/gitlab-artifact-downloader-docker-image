# Gitlab artifact downloader

This script will help you to download an artifact from a successful job, not necessary from the latest pipeline.

It's useful in a scenario, where you have for instance pipeline, which builds artifacts for different environments (i.e. dev, qa, prod), triggered one by one by manual action.
In that case, the latest pipeline not always has a completed job for specific environment as it has not been promoted yet.

## Prerequisites

* Docker
* Docker Compose    

## Run locally

1. Run `make setup` - Creates `.env` and `docker-compose.local.yml` files
2. Populate environmental variables in `.env` file. Adjust `docker-compose.local.yml` if you want. 
3. Run `make [build]` - Builds docker image
4. Run `make run` to run a script

> The rest of commands can be found in the `Makefile`. 
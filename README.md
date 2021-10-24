#  fabio-backend

# Getting Started

## Docker
[This guide](https://docs.docker.com/get-started/) is a great source to get started with Docker.

These are the commands to build a container image and set up
the network and the containers for the app.
```
# Build the image
docker build -t fabio-backend .

# Security Scan
docker scan fabio-backend

# Start a network
docker network create fabio-network

# Start a postgres container
docker run -d                         \
  --network fabio-network             \
  --network-alias pg                  \
  -v pg-data:/var/lib/postgresql      \
  -e POSTGRES_HOST_AUTH_METHOD=trust postgres

# Start the app container
docker run --rm -dp 3000:3000         \
  --network fabio-network             \
  -e POSTGRES_HOST=pg                 \
  -e POSTGRES_USER=postgres           \
  -v "$(pwd):/app"                    \
  -v "gems:/usr/local/bundle"         \
  -v "node_modules:/src/node_modules" \
  fabio-backend bin/docker-entrypoint.sh

# Run tests inside the container
docker run --rm                       \
  --network fabio-network             \
  -e POSTGRES_HOST=pg                 \
  -e POSTGRES_USER=postgres           \
  -v "$(pwd):/app"                    \
  -v "gems:/usr/local/bundle"         \
  -v "node_modules:/src/node_modules" \
  fabio-backend rails test

# Start an interactive terminal irb console (without loading Rails)
docker run --rm -it \
  --network fabio-network             \
  -e POSTGRES_HOST=pg                 \
  -e POSTGRES_USER=postgres           \
  -v "$(pwd):/app"                    \
  -v "gems:/usr/local/bundle"         \
  -v "node_modules:/src/node_modules" \
  fabio-backend

# Start an interactive terminal rails console
docker run --rm -it \
  --network fabio-network             \
  -e POSTGRES_HOST=pg                 \
  -e POSTGRES_USER=postgres           \
  -v "$(pwd):/app"                    \
  -v "gems:/usr/local/bundle"         \
  -v "node_modules:/src/node_modules" \
  fabio-backend rails c
```

## Docker composer
Simplifies the setup of the network and the containers according
to the `docker-compose.yml` configurations.
```
# https://docs.docker.com/samples/rails/#rebuild-the-application
# If the container is declared with a build directive in the docker-compose file
# instead of an image directive, this command rebuilds the image and starts the
# container
docker-compose up --build

# Start the app and postgres containers in detached mode
# without rebuilding the image
docker-compose up -d

# Logs - all containers
docker-compose logs -f

# Logs - app container only
docker-compose logs -f app

# Logs - pg container only
docker-compose logs -f pg

# Stops the containers, preserving the database volume
docker-compose down

# stop and remove volumes
docker-compose down --volumes
```

### Useful commands
```
# PG 5432 port is exposed via localhost/5432
# -h is mandatory, otherwise psql tries to conneck
# using a socket file /tmp/.s.PGSQL.5432
psql -h 127.0.0.1 -U postgres

# It's possible to run rails commands inside the container
docker-compose run --rm app rails db:reset
docker-compose run --rm app rails db:migrate
docker-compose run --rm app rails test

# To make life easier, add this alias to your `.bashrc` or similer
alias drails="docker-compose run --rm app rails"

# You can also run commands using interactive bash terminal
docker-compose run --rm app /bin/bash
Creating fabio-backend_app_run ... done
root@a583953e3cf3:/src# rails test
Running 0 tests in a single process (parallelization threshold is 50)
Run options: --seed 21251

# Running:
Finished in 0.003540s, 0.0000 runs/s, 0.0000 assertions/s.
0 runs, 0 assertions, 0 failures, 0 errors, 0 skips
```

# Zero Getting Started

### Zero-generated Dockerfile

### Essential steps to get your backend service deployed
A helloworld example has been shipped with the template to show the bare minimum setup.
  - The Dockerfile contains a script used to create a Python image.
  - The Python app dependencies are declared in the requirements.txt and installed using the pip package manager.
  - The `main.py` backend is a simple Hello World Flask app running on the container's port 80.
  - Docker exposes this container port 80 to be accessible from the host machine.

```
# builds the Docker image
docker build -t fabio-backend .

# runs the docker container
# -d: detached mode (run in background)
# -p: publishes the container's port 80 to the host's port 80
docker run -d -p 80:80 fabio-backend
```

### Setting up the Rails app after Zero setup
```
# rbenv/ruby-build will display the latest ruby version
rbenv install --list

# Installs the latest ruby version
rbenv install 3.0.2

# Install Rails 7.0.0.alpha2
gem install rails --pre

# create the app named Bills
# - using postgresql database and Sass pré-processor
# - skips bootsnap, spring, coffeescript, jbuilder, and system-tests (Capybara)
# - these settings can be configured using a ~/.railsrc file
rails new . --database=postgresql --skip-bootsnap --skip-spring --skip-coffee --skip-jbuilder --skip-system-test --css=sass

# Generates the db/schema file.
# PG must be configured on the host machine
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-20-04
rails db:create db:migrate
```

# Deployment
### Things that happened behind the scenes
- The Github Org has already been configured with secrets that allow this project to deploy to the Onboarding cluster
- CI/CD will run in Github actions to deploy your application
- It will build an image and push to ECR (Elastic Container Registry)
- it will create an ingress, service, and deployment in the Kubernetes cluster using kustomize during the CI pipeline
- It will update the deployment to use the newly built docker image

# Your local environment
To set up your local environment with access to AWS and Kubernetes, just run:
```
./scripts/setup-env.sh
```
This script will open a web browser and prompt you to log in with your Commit Gmail account, and then will configure an AWS profile and a Kubernetes context.

# Creating secrets

The Playground uses a somewhat "quick and dirty" way to create secrets for your application without needing to commit them to your GitHub repository. In order to add secrets to your deployment:

1. Rename `secrets/secrets.yml.example` to `secrets.yml` (note that `secrets.yml` has been added to the `.gitignore` file, so they will not be committed to your GitHub repository).
2. Add secrets to the `stringData` section of your `secrets.yml` file as appropriate. In your deployed application, each secret key will be available as an environment variable.
3. Run `make upsert-secrets` from the root of your application which will create the secrets object on your Kubernetes cluster server.
4. Uncomment the `secretRef` and `name` lines from `kubernetes/deploy/deployment.yml`.
5. That's it! Deploy your application in order for the secrets to be picked up, and you should now be able to access them as environment variables via the defined secret keys.

# Structure
## Kubernetes
The configuration of your application in Kubernetes uses [https://kustomize.io/](kustomize) and is run by the CI pipeline, the configuration is in the [`/kubernetes`](./kubernetes/deploy/) directory.
Once the CI pipeline is finished, you can see the pod status on kubernetes in your application namespace:
```
kubectl -n fabio-backend get pods
```
### Configuring
You can update the configuration of the [deployment] and adjust things like increasing the number of replicas and adding new environment variables in the [kustomization] file. The [ingress] and [service] control routing traffic to your application.

## Github actions
Your repository comes with a end-to-end CI/CD pipeline, which includes the following steps:
1. Checkout
2. Unit Tests
3. Build Image
4. Upload Image to ECR
4. Deploy image to cluster

<!-- Links -->
[deployment]: ./kubernetes/deploy/deployment.yml
[service]: ./kubernetes/deploy/service.yml
[ingress]: ./kubernetes/deploy/ingress.yml
[kustomization]: ./kubernetes/deploy/kustomization.yml

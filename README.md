# DevOps Environment

A toolset to work with cloud environment.

[![asciicast](https://asciinema.org/a/fR6HNcPAP4XigZkWjOWAI5zfk.svg)](https://asciinema.org/a/fR6HNcPAP4XigZkWjOWAI5zfk)

## How to install

```bash
# Create your project dir
mkdir my-project
cd my-project

# Clone
git clone https://github.com/thenets/devops-env.git devops

# Start the installation script
./devops/install.sh
```

## How to update

```bash
./devops/update.sh
```

## Add to your .gitignore

The `./.gitignore` will be verified during the installation process. If some line is missing it will be appended in the end.

## Config file example

The `./config.ini` will be generated during the first installation process if not exist.

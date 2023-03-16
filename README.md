# DEVLEGO: A Simple Way to Kickstart Your Development Journey

## Overview

DevLEGO is a collection of scripts designed to help you quickly and effortlessly set up a development environment. This easy-to-use solution takes care of the initial setup, allowing you to focus on writing code.

## Getting Started

Follow these steps to set up DevLEGO:

1. Clone the repository
2. Customize the configuration
3. Build the environment
4. Set up Nginx for access

### Step 1: Clone the Repository

```bash
git clone https://github.com/voidful/DevLEGO.git
```

### Step 2: Create a Docker Network

```lua
docker network create deblego
```

### Step 3: Customize the Configuration

#### Essential Changes:

- Dockerfile -  change the base images
- docker-compose.yml - change username, password, container name, mount volume, etc.

#### Optional Changes:

- ports.sh - port setting
- version.sh - version setting

### Step 4: Build Nginx Proxy Manager

```bash
cd nginx
docker-compose up -d
```

### Step 5: Build DevLEGO

```bash
docker-compose up -d
```

### Step 6: Set up Nginx for DevLEGO Access

## References
[Inspire By pojntfx/pojde](https://github.com/pojntfx/pojde)  

[Change Docker Default Data Directory](https://gist.github.com/plembo/0070059bde27bb8fb37735a899b16e41)


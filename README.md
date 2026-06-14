# DevLEGO

> A modular, Docker-based development environment you assemble like LEGO bricks. Pick the bricks you want, snap them together, and reach your stack from the browser, a web terminal, or SSH.

[![Docker Image](https://img.shields.io/badge/docker-voidful%2Fdevlego--1-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/voidful/devlego-1)
[![License: MIT](https://img.shields.io/badge/license-MIT-2ecc71)](./LICENSE)
[![Version](https://img.shields.io/badge/version-0.2.0-3498db)](https://github.com/voidful/DevLEGO)
[![GitHub Pages](https://img.shields.io/badge/demo-GitHub%20Pages-f1c40f?logo=github&logoColor=white)](https://voidful.github.io/DevLEGO/)

**[Landing page & demo](https://voidful.github.io/DevLEGO/)** · **[Builder](https://voidful.github.io/DevLEGO/builder.html)** · **[GitHub](https://github.com/voidful/DevLEGO)**

---

## What is DevLEGO

DevLEGO is a single Docker image that you build from a set of interchangeable **bricks** (components). Choose the IDEs, notebooks, terminals, and tooling you want, and DevLEGO bakes them into one container you can reach three ways:

- In your **browser** — VS Code (Code Server), JupyterLab, Jupyter Notebook
- In a **web terminal** — a full shell in a browser tab (ttyd)
- Over **SSH** — remote shell and tunneling, always available

It's **GPU-ready** out of the box: the image is built on the NVIDIA base image [`nvcr.io/nvidia/mxnet:24.06-py3`](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/mxnet), and `docker-compose.yml` reserves your GPU for the container, so CUDA-capable workloads just work.

Like LEGO, the value is in the modularity: every brick is one small shell script in `component/`, and turning the browser-facing services on or off is a single environment variable. **New in 0.2.0:** the [Claude Code](https://www.npmjs.com/package/@anthropic-ai/claude-code) and [Codex](https://www.npmjs.com/package/@openai/codex) agentic coding CLIs come pre-installed in every terminal.

## Components

Every brick that ships with DevLEGO:

| Brick | What it is | Port | Toggle |
| --- | --- | --- | --- |
| **Code Server** | VS Code in the browser — a full IDE in a tab | `38001` | `ENABLE_CODE_SERVER=false` |
| **JupyterLab** | Notebooks + IDE | `38002` | `ENABLE_JUPYTER_LAB=false` |
| **Jupyter Notebook** | Classic notebooks | `38003` | `ENABLE_JUPYTER_NOTEBOOK=false` |
| **ttyd** | A full terminal in a browser tab | `38004` | `ENABLE_TTYD=false` |
| **SSH server** | Remote shell and tunneling | `38000` | Always on |
| **Conda (Miniconda)** | Environment manager | — | Always installed |
| **uv** | Fast Python package/env manager | — | Always installed |
| 🧱 **Claude Code** `@anthropic-ai/claude-code` | Anthropic agentic coding CLI | CLI | **New in 0.2.0 · pre-installed** |
| 🧱 **Codex** `@openai/codex` | OpenAI coding CLI | CLI | **New in 0.2.0 · pre-installed** |

Also baked into every image: `git`, `git-lfs`, `vim`, `nano`, `htop`, `ncdu`, `cmake`, `build-essential`, `g++`, `ffmpeg`, `wget`, `curl`, `screen`.

The four service bricks (Code Server, JupyterLab, Jupyter Notebook, ttyd) default to **ON**. The AI CLIs have no port and no toggle — they're always installed and ready in any terminal.

## Quickstart

You need Docker with the Compose V2 plugin (note: `docker compose`, **two words**).

```bash
# 1. Clone the repo and step in
git clone https://github.com/voidful/DevLEGO.git && cd DevLEGO

# 2. Create the Docker network
docker network create devlego

# 3. Copy the env template (add API keys if you want the AI CLIs authenticated — optional)
cp .env.example .env

# 4. Build and start everything in the background
docker compose up -d --build
```

Then open **Code Server** at [http://localhost:38001](http://localhost:38001) — default password: `changeme`.

> **Default credentials** come from `docker-compose.yml`: `USERNAME=devlego`, `PASSWORD=changeme`. Change these before exposing DevLEGO anywhere beyond your local machine.

## Configuring the AI CLIs

API keys are optional — unset keys are simply omitted, so the container still builds and runs without them. To authenticate Claude Code or Codex, provide keys via a `.env` file next to `docker-compose.yml` (Compose auto-loads it) or via your host shell. Start by copying the template:

```bash
cp .env.example .env
```

Then fill in the keys you need. The following variables are passed through to the container:

| Variable | CLI | Notes |
| --- | --- | --- |
| `ANTHROPIC_API_KEY` | Claude Code | API key |
| `ANTHROPIC_AUTH_TOKEN` | Claude Code | Optional — bearer-token gateways/proxies |
| `ANTHROPIC_BASE_URL` | Claude Code | Optional — custom/proxied API endpoint |
| `OPENAI_API_KEY` | Codex | API key |
| `CODEX_API_KEY` | Codex | Optional — key for non-interactive `codex exec` (CI) |

Compose uses the bare `- VAR` passthrough form, so any variable you leave unset is omitted from the container entirely (not set to an empty string). See [`.env.example`](./.env.example) for the full template.

> Codex's base URL is configured via its `config.toml` (`openai_base_url`), not an environment variable, so there is no `OPENAI_BASE_URL` passthrough.

## Enable / disable components

The four browser-facing service bricks are on by default. Disable any of them by setting its `ENABLE_*` variable to `false` (in `.env` or your host shell, picked up by `docker-compose.yml`):

```bash
ENABLE_CODE_SERVER=false
ENABLE_JUPYTER_LAB=false
ENABLE_JUPYTER_NOTEBOOK=false
ENABLE_TTYD=false
```

The SSH server always runs, and the AI CLIs (Claude Code, Codex) are always installed — neither has a toggle.

## The Builder

The **[Builder](https://voidful.github.io/DevLEGO/builder.html)** is a small companion web tool (`docs/builder.html`, linked from the landing page) that generates a ready-to-paste `docker run` command from the components and ports you select. Pick your bricks visually, copy the command, and go.

## Configuration files

| File | What it controls |
| --- | --- |
| `docker-compose.yml` | Username/password, mounted volumes, GPU reservation, and API-key env passthrough |
| `ports.sh` | Host/container port numbers |
| `versions.sh` | Pinned tool and VS Code extension versions |
| `component/*.sh` | One shell script per brick — the heart of each component |

## Add your own brick

Adding a component is deliberately LEGO-simple:

1. Drop a shell script into `component/` (for example `component/my-brick.sh`) that installs and sets up your tool.
2. Wire two lines into the `Dockerfile` — one `COPY` and one `RUN`:

   ```dockerfile
   COPY component/my-brick.sh .
   RUN bash ./my-brick.sh
   ```

3. Rebuild with `docker compose up -d --build`.

That's the whole contract. If your brick exposes a port, add it to `ports.sh`; if it pins a version, add it to `versions.sh`.

## Default ports

| Service | Port |
| --- | --- |
| SSH server | `38000` |
| Code Server | `38001` |
| JupyterLab | `38002` |
| Jupyter Notebook | `38003` |
| ttyd | `38004` |

Ports are defined in `ports.sh` — adjust them there if any collide with services on your host.

## Credits & references

DevLEGO is inspired by these excellent projects:

- [pojntfx/pojde](https://github.com/pojntfx/pojde) — browser-based development environments over SSH
- [p208p2002/docker-for-ai-dev](https://github.com/p208p2002/docker-for-ai-dev) — Docker setups for AI development

Built by [voidful (Eric Lam)](https://github.com/voidful).

## License

Released under the [MIT License](./LICENSE) — Copyright (c) 2024 Eric Lam.

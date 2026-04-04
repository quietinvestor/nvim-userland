# AGENTS.md

## Purpose

This repository builds and runs a containerized Neovim environment with Podman.

## Key Commands

- `make build`: build the container image
- `make rebuild`: rebuild without using the layer cache
- `make up`: create or replace the Podman pod
- `make down`: stop and remove the Podman pod
- `make nvim`: run Neovim inside the container
- `make shell`: open a `bash` shell inside the container

## Files That Matter

- `Dockerfile`: image definition
- `Makefile`: local workflow entry points
- `podman/nvim.yaml`: pod manifest template rendered with `envsubst`
- `config/`: tracked Neovim configuration copied into the image

## Volumes

- `volumes/projects/`: working directory inside the container at `/home/dev/projects`

Do not commit contents under `volumes/`.

## Editing Guidance

- Keep version pins explicit unless intentionally updating them.
- Do not hardcode host-specific absolute paths in the manifest beyond the `${ROOT_DIR}` template mechanism already used by the Makefile.
- Keep the builder and final image stages aligned when changing user, ownership, or copied home-directory content.
- Prefer minimal, targeted changes over broad refactors.

## Security Expectations

- Do not widen container privileges casually.
- Keep the Podman user-namespace and bind-mount model intact unless there is a clear reason to change it.
- If changing UID/GID mapping, volume mounts, or environment inheritance behavior, explain the permission and security tradeoff clearly.

# nvimpod

Run a preconfigured [Neovim](https://neovim.io/doc/) environment from a rootless [podman](https://podman.io/docs) container.

## Usage

| Command      | Description                               |
| ------------ | ----------------------------------------- |
| `make build` | Build the container image.                |
| `make up`    | Start or replace the Podman pod.          |
| `make down`  | Stop and remove the Podman pod.           |
| `make nvim`  | Run Neovim inside the container.          |
| `make shell` | Open a `bash` shell inside the container. |

## Projects Volume

The pod mounts only one host path:

- `volumes/projects/` -> `/home/dev/projects`

Anything you want to edit inside the container should live under `volumes/projects/`.

## Notes

The first `make up` after a fresh build may be slow while Podman prepares ID-mapped storage.

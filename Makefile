.PHONY: build down nvim rebuild shell up

CONTAINER := nvim-nvim
IMAGE := localhost/nvim:0.1.1
MANIFEST := podman/nvim.yaml
ROOT_DIR := $(CURDIR)

build:
	podman build --tag $(IMAGE) .

down:
	ROOT_DIR=$(ROOT_DIR) WAYLAND_DISPLAY=$(WAYLAND_DISPLAY) XDG_RUNTIME_DIR=$(XDG_RUNTIME_DIR) envsubst < $(MANIFEST) | podman kube down -

nvim:
	podman exec --interactive --tty $(CONTAINER) bash -lc 'exec nvim'

rebuild:
	podman build --no-cache --tag $(IMAGE) .

shell:
	podman exec --interactive --tty $(CONTAINER) bash

up:
	ROOT_DIR=$(ROOT_DIR) WAYLAND_DISPLAY=$(WAYLAND_DISPLAY) XDG_RUNTIME_DIR=$(XDG_RUNTIME_DIR) envsubst < $(MANIFEST) | podman kube play --replace --userns keep-id:uid=1001,gid=1001 -

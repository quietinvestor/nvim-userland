# 1. Pull Ubuntu image for builder.
FROM ubuntu:24.04@sha256:67efaecc0031a612cf7bb3c863407018dbbef0a971f62032b77aa542ac8ac0d2 AS builder

# 2. Set bash shell.
SHELL ["/bin/bash", "-c"]

# 3. Install common utilities and C.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git=1:2.43.0-1ubuntu7.3 \
    build-essential=12.10ubuntu1 \
    curl=8.5.0-2ubuntu10.8 \
    gpg=2.4.4-2ubuntu17.4 \
    jq=1.7.1-3ubuntu0.24.04.1 \
    python3=3.12.3-0ubuntu2.1 \
    python-is-python3=3.11.4-1 \
    python3-pip=24.0+dfsg-1ubuntu1.3 \
    python3-venv=3.12.3-0ubuntu2.1 \
    unzip=6.0-28ubuntu4.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 4. Install Go.
ENV GO_VERSION=1.26.1
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o go.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# 5. Install Helm.
ENV HELM_VERSION=4.0.1
RUN curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
    tar -xzf helm.tar.gz && \
    install -m 0755 linux-amd64/helm /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-amd64

# 6. Install Node.js and npm.
ENV NODE_VERSION=v25.8.1
RUN curl -fsSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz -o node.tar.xz && \
    tar -xJf node.tar.xz -C /usr/local --strip-components=1 && \
    rm -f node.tar.xz

# 7. Configure Terraform apt repository.
RUN curl https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com noble main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

# 8. Install Terraform.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    terraform=1.14.7-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 9. Install Neovim.
ENV NVIM_VERSION=0.12.0
RUN curl -LO https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz && \
    tar -zxvf nvim-linux-x86_64.tar.gz && \
    mkdir -p /opt/nvim && \
    mv nvim-linux-x86_64/* /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm -rf nvim-linux-x86_64.tar.gz

# 10. Install Lua.
ENV LUA_VERSION=5.4.8
RUN curl -fsSL https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz -o lua.tar.gz && \
    tar -xzf lua.tar.gz && \
    make -C lua-${LUA_VERSION} linux test && \
    make -C lua-${LUA_VERSION} install && \
    rm -rf lua.tar.gz lua-${LUA_VERSION}

# 11. Install LuaRocks.
ENV LUAROCKS_VERSION=3.13.0
RUN curl -fsSL https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -o luarocks.tar.gz && \
    tar -xzf luarocks.tar.gz && \
    cd luarocks-${LUAROCKS_VERSION} && \
    ./configure --lua-version=5.4 && \
    make && \
    make install && \
    cd / && \
    rm -rf luarocks.tar.gz luarocks-${LUAROCKS_VERSION}

# 12. Install Ruby.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ruby-full=1:3.2~ubuntu1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 13. Install Puppet gem.
ENV PUPPET_VERSION=8.10.0
RUN gem install --no-document puppet:${PUPPET_VERSION}

# 14. Create non-root user and home directory.
RUN useradd --create-home --shell /bin/bash dev

# 15. Switch to non-root user.
USER dev
WORKDIR /home/dev

# 16. Install Rust and cargo.
ENV RUST_VERSION=1.94.1
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VERSION}
ENV PATH="/home/dev/.cargo/bin:${PATH}"

# 17. Set Go path.
ENV PATH="/usr/local/go/bin:${PATH}"

# 18. Install tree-sitter CLI.
ENV TREE_SITTER_CLI_VERSION=0.26.8
RUN curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_CLI_VERSION}/tree-sitter-linux-x64.gz -o /tmp/tree-sitter.gz && \
    echo "9754a32800f0b970152782df177b4a47c711e34e651a7aceb384d8bd29fa136e  /tmp/tree-sitter.gz" | sha256sum -c - && \
    gunzip -c /tmp/tree-sitter.gz > /usr/local/bin/tree-sitter && \
    chmod 0755 /usr/local/bin/tree-sitter && \
    rm -f /tmp/tree-sitter.gz

# 19. Create directory for Neovim config.
RUN mkdir -p .config/nvim

# 20. Copy config to image.
COPY --chown=dev:dev config/ .config/nvim/

# 21. Restore Neovim plugins.
RUN nvim --headless +"Lazy! restore" +qa

# 22. Install Tree-sitter parsers.
RUN TS_PARSERS=$(nvim --headless +"lua io.stdout:write(table.concat(require('config.treesitter').parsers, ' '))" +qa 2>/dev/null) && \
    nvim --headless +"lua require('nvim-treesitter').install(require('config.treesitter').parsers):wait(300000)" +qa

# 23. Install Mason tools.
RUN nvim --headless +"MasonToolsInstallSync" +qa

# 24. Install Mason LSP servers.
RUN MASON_LSP_PACKAGES=$(nvim --headless +"lua io.stdout:write(table.concat(require('config.lspservers').mason, ' '))" +qa 2>/dev/null) && \
    nvim --headless +"MasonInstall ${MASON_LSP_PACKAGES}" +qa

# 25. Pull Ubuntu image for runtime.
FROM ubuntu:24.04@sha256:67efaecc0031a612cf7bb3c863407018dbbef0a971f62032b77aa542ac8ac0d2 AS final

# 26. Set bash shell.
SHELL ["/bin/bash", "-c"]
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color

# 27. Install runtime utilities and shared libraries.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    clang-tidy=1:18.0-59~exp2 \
    curl=8.5.0-2ubuntu10.8 \
    gcc=4:13.2.0-7ubuntu1 \
    git=1:2.43.0-1ubuntu7.3 \
    jq=1.7.1-3ubuntu0.24.04.1 \
    libicu74=74.2-1ubuntu3.1 \
    libatomic1=14.2.0-4ubuntu2~24.04.1 \
     python3=3.12.3-0ubuntu2.1 \
     python-is-python3=3.11.4-1 \
     python3-pip=24.0+dfsg-1ubuntu1.3 \
     python3-venv=3.12.3-0ubuntu2.1 \
     ripgrep=14.1.0-1 \
     ruby-full=1:3.2~ubuntu1 \
     unzip=6.0-28ubuntu4.1 \
     wget=1.21.4-1ubuntu4.1 \
     xdg-utils=1.1.3-4.1ubuntu3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 28. Install Puppet gem.
ENV PUPPET_VERSION=8.10.0
RUN gem install --no-document puppet:${PUPPET_VERSION}

# 29. Install Puppet lint gem.
ENV PUPPET_LINT_VERSION=5.1.1
RUN gem install --no-document puppet-lint:${PUPPET_LINT_VERSION}

# 30. Install tree-sitter CLI.
ENV TREE_SITTER_CLI_VERSION=0.26.8
RUN curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_CLI_VERSION}/tree-sitter-linux-x64.gz -o /tmp/tree-sitter.gz && \
    echo "9754a32800f0b970152782df177b4a47c711e34e651a7aceb384d8bd29fa136e  /tmp/tree-sitter.gz" | sha256sum -c - && \
    gunzip -c /tmp/tree-sitter.gz > /usr/local/bin/tree-sitter && \
    chmod 0755 /usr/local/bin/tree-sitter && \
    rm -f /tmp/tree-sitter.gz

# 31. Create non-root user and home directory.
RUN useradd --create-home --shell /bin/bash dev

# 32. Copy system toolchains from builder.
COPY --from=builder /usr/local/go /usr/local/go
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/node /usr/local/bin/node
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/bin/terraform /usr/bin/terraform
COPY --from=builder /opt/nvim /opt/nvim
RUN ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# 33. Copy Lua runtimes from builder.
COPY --from=builder /usr/local/bin/lua /usr/local/bin/lua
COPY --from=builder /usr/local/bin/luac /usr/local/bin/luac
COPY --from=builder /usr/local/bin/luarocks /usr/local/bin/luarocks
COPY --from=builder /usr/local/bin/luarocks-admin /usr/local/bin/luarocks-admin
COPY --from=builder /usr/local/share/lua /usr/local/share/lua
COPY --from=builder /usr/local/lib/lua /usr/local/lib/lua

# 34. Copy user-space toolchains and Neovim state from builder.
COPY --from=builder --chown=dev:dev /home/dev/.cargo /home/dev/.cargo
COPY --from=builder --chown=dev:dev /home/dev/.rustup /home/dev/.rustup
COPY --from=builder --chown=dev:dev /home/dev/.config/nvim /home/dev/.config/nvim
COPY --from=builder --chown=dev:dev /home/dev/.local/share/nvim /home/dev/.local/share/nvim
COPY --from=builder --chown=dev:dev /home/dev/.cache/nvim /home/dev/.cache/nvim
COPY --from=builder --chown=dev:dev /home/dev/.local/state/nvim /home/dev/.local/state/nvim

# 35. Switch to non-root user.
USER dev
WORKDIR /home/dev

# 36. Set paths.
ENV CARGO_HOME="/home/dev/.cargo"
ENV RUSTUP_HOME="/home/dev/.rustup"
ENV PATH="/home/dev/.cargo/bin:/home/dev/.local/share/nvim/mason/bin:/usr/local/go/bin:${PATH}"

ENTRYPOINT ["/bin/bash"]

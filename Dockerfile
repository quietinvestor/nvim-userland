# 1. Pull Ubuntu image.
FROM ubuntu:24.04@sha256:67efaecc0031a612cf7bb3c863407018dbbef0a971f62032b77aa542ac8ac0d2

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
    software-properties-common=0.99.49.4 \
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

# 6. Install Lua and luarocks.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    lua5.4=5.4.6-3build2 \
    luarocks=3.8.0+dfsg1-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 7. Install Nodejs and NPM.
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install --no-install-recommends -y \
    nodejs=22.22.2-1nodesource1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 8. Install Python, pip and venv.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3=3.12.3-0ubuntu2.1 \
    python-is-python3=3.11.4-1 \
    python3-pip=24.0+dfsg-1ubuntu1.3 \
    python3-venv=3.12.3-0ubuntu2.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 9. Install Ruby, gems and Puppet.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    ruby-full=1:3.2~ubuntu1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install puppet:8.10.0

# 10. Install Terraform.
RUN curl https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    terraform=1.14.7-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 11. Install Neovim.
ENV NVIM_VERSION=0.11.5
RUN curl -LO https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz && \
    tar -zxvf nvim-linux-x86_64.tar.gz && \
    mkdir -p /opt/nvim && \
    mv nvim-linux-x86_64/* /opt/nvim && \
    ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim && \
    rm -rf nvim-linux-x86_64.tar.gz

# 12. Create non-root user and home directory.
RUN useradd --create-home --shell /bin/bash dev

# 13. Switch to non-root user.
USER dev
WORKDIR /home/dev

# 14. Install Rust and cargo.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/home/dev/.cargo/bin:${PATH}"

# 15. Set Go path.
ENV PATH="/usr/local/go/bin:${PATH}"

# 16. Create directory for Neovim config.
RUN mkdir -p .config/nvim

# 17. Copy config to image.
COPY --chown=dev:dev config/ .config/nvim/


# 18. Install all plugins, LSPs, formatters and linters.
RUN nvim --headless +"Lazy! restore" +qa && \
    nvim --headless +"MasonToolsInstallSync" +qa && \
    SERVERS=$(nvim --headless +"lua io.stdout:write(table.concat(require('lazy.core.config').spec.plugins['mason-lspconfig.nvim'].opts.ensure_installed, ' '))" +qa 2>/dev/null) && \
    nvim --headless +"MasonInstall ${SERVERS}" +qa

ENTRYPOINT ["/bin/bash"]

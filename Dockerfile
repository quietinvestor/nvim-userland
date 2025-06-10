# 1. Pull Ubuntu image.
FROM ubuntu:24.04

# 2. Set bash shell.
SHELL ["/bin/bash", "-c"]

# 3. Install common utilities and C.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    apt-transport-https=2.8.3 \
    git=1:2.43.0-1ubuntu7.2 \
    build-essential=12.10ubuntu1 \
    curl=8.5.0-2ubuntu10.6 \
    gpg=2.4.4-2ubuntu17.2 \
    jq=1.7.1-3build1 \
    software-properties-common=0.99.49.2 \
    unzip=6.0-28ubuntu4.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 4. Install Go.
ENV GO_VERSION=1.24.4
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o go.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# 5. Install Helm.
RUN curl https://baltocdn.com/helm/signing.asc | \
    gpg --dearmor | \
    tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] \
    https://baltocdn.com/helm/stable/debian/ all main" | \
    tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    helm=3.18.1-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
    nodejs=22.16.0-1nodesource1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 8. Install Python, pip and venv.
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3=3.12.3-0ubuntu2 \
    python-is-python3=3.11.4-1 \
    python3-pip=24.0+dfsg-1ubuntu1.1 \
    python3-venv=3.12.3-0ubuntu2 && \
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
    terraform=1.12.1-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 11. Install Neovim.
ENV NVIM_VERSION=0.11.2
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
RUN nvim --headless +"Lazy! sync" +qa && \
    nvim --headless +"MasonToolsUpdateSync" +qa && \
    SERVERS=$(nvim --headless +"lua vim.print(table.concat(require('lazy.core.config').spec.plugins['mason-lspconfig.nvim'].opts.ensure_installed, ' '))" +qa 2>&1) && \
    nvim --headless +"MasonInstall ${SERVERS}" +qa

ENTRYPOINT ["/bin/bash"]

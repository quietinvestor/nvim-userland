# 1. Pull Ubuntu image.
FROM ubuntu:24.04

# 2. Install common utilities.
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https=2.7.14build2 \
    curl=8.5.0-2ubuntu10.6 \
    git=1:2.43.0-1ubuntu7.1 \
    gnupg=2.4.4-2ubuntu17 \
    jq=1.7.1-3build1 \
    #    ninja-build=1.11.1-2 \
    software-properties-common=0.99.49.1 \
    unzip=6.0-28ubuntu4.1 && \
    rm -rf /var/lib/apt/lists/*

# 3. Install C.
RUN apt-get update && \
    apt-get install -y \
    build-essential=12.10ubuntu1 && \
    rm -rf /var/lib/apt/lists/*

# 4. Install Cmake.
RUN apt-get update && \
    apt-get install -y \
    cmake=3.28.3-1build7 && \
    rm -rf /var/lib/apt/lists/*

# 5. Install Go.
RUN apt-get update && \
    apt-get install -y \
    golang=2:1.22~2build1 && \
    rm -rf /var/lib/apt/lists/*

# 6. Install Helm.
RUN curl https://baltocdn.com/helm/signing.asc | \
    gpg --dearmor | \
    tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] \
    https://baltocdn.com/helm/stable/debian/ all main" | \
    tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install -y \
    helm=3.16.3-1 && \
    rm -rf /var/lib/apt/lists/*

# 7. Install Lua and luarocks.
RUN apt-get update && \
    apt-get install -y \
    lua5.4=5.4.6-3build2 \
    luarocks=3.8.0+dfsg1-1 && \
    rm -rf /var/lib/apt/lists/*

# 8. Install Nodejs and NPM.
RUN apt-get update && \
    apt-get install -y \
    nodejs=18.19.1+dfsg-6ubuntu5 \
    npm=9.2.0~ds1-2 && \
    rm -rf /var/lib/apt/lists/*

# 9. Install Python, pip and venv.
RUN apt-get update && \
    apt-get install -y \
    python3=3.12.3-0ubuntu2 \
    python-is-python3=3.11.4-1 \
    python3-pip=24.0+dfsg-1ubuntu1.1 \
    python3-venv=3.12.3-0ubuntu2 && \
    rm -rf /var/lib/apt/lists/*

# 10. Install Ruby, gems and Puppet.
RUN apt-get update && \
    apt-get install -y \
    ruby=1:3.2~ubuntu1 \
    rubygems-integration=1.18 && \
    gem install puppet:8.10.0 && \
    rm -rf /var/lib/apt/lists/*

# 11. Install Rust and cargo.
RUN apt-get update && \
    apt-get install -y \
    rustc=1.75.0+dfsg0ubuntu1-0ubuntu7.1 && \
    cargo=1.75.0+dfsg0ubuntu1-0ubuntu7.1 && \
    rm -rf /var/lib/apt/lists/*

# 12. Install Terraform.
RUN curl https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y \
    terraform=1.10.3-1 && \
    rm -rf /var/lib/apt/lists/*

# 13. Install Neovim nightly.
#     Version not pinned as it changes continuously.
RUN add-apt-repository -y ppa:neovim-ppa/unstable && \
    apt-get update && \
    apt-get install -y neovim && \
    rm -rf /var/lib/apt/lists/*

# 14.
WORKDIR /root/

# 15.
RUN mkdir -p .config/nvim

# 16.
COPY config/ .config/nvim/

# 17. Install all plugins, LSPs, formatters and linters.
RUN nvim --headless +"Lazy! sync" +qa && \
    nvim --headless +"MasonToolsUpdateSync" +qa && \
    SERVERS=$(nvim --headless +"lua print(table.concat(require('plugins.mason')[2].opts.ensure_installed, ' '))" +qa 2>&1) && \
    nvim --headless +"LspInstall ${SERVERS}" +qa

ENTRYPOINT ["/bin/bash"]

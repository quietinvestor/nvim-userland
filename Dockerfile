FROM localhost/ubuntu-userland:1.0.0

USER root

RUN apt update && \
    apt install -y \
    curl=7.81.0-1ubuntu1.16 \
    git=1:2.34.1-1ubuntu1.10 \
    unzip=6.0-26ubuntu3.1 && \
    cd /opt/ && \
    curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz && \
    tar -zxvf nvim-linux64.tar.gz --one-top-level && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

ARG username

USER $username

WORKDIR /home/$username

RUN mkdir -p /home/$username/.config/nvim

COPY --chown=$username:$username config/init.lua /home/$username/.config/nvim/

RUN { curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash ; } && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install 21.6.2

ARG lsp_servers

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvim --headless +"Lazy! sync" +qa && \
    nvim --headless +"LspInstall $lsp_servers" +qa

ENTRYPOINT ["/bin/bash"]

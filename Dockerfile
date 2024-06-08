FROM localhost/ubuntu-userland:1.0.0

USER root

RUN apt update && \
    apt install -y \
    build-essential=12.10ubuntu1 \
    curl=8.5.0-2ubuntu10.1 \
    git=1:2.43.0-1ubuntu7.1 \
    unzip=6.0-28ubuntu4 && \
    cd /opt/ && \
    curl -LO https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz && \
    tar -zxvf nvim-linux64.tar.gz --one-top-level && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

ARG username

USER $username

WORKDIR /home/$username

RUN mkdir -p /home/$username/.config/nvim && \
    mkdir -p /home/$username/.local/bin

ENV PATH="/home/$username/.local/bin:${PATH}"

COPY --chown=$username:$username config/init.lua /home/$username/.config/nvim/

RUN { curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash ; } && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install 22.2.0 && \
    npm install tree-sitter-cli && \
    ln -s $HOME/node_modules/tree-sitter-cli/tree-sitter $HOME/.local/bin/tree-sitter

ARG lsp_servers

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvim --headless +"Lazy! sync" +qa && \
    nvim --headless +"LspInstall $lsp_servers" +qa

RUN echo "\nexport PROMPT_DIRTRIM=1" >> /home/$username/.bashrc

ENTRYPOINT ["/bin/bash"]

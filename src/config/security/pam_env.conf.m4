m4_include(user_config.m4)m4_dnl
m4_include(env_config.m4)m4_dnl

# Used to check whether this file has been read
PAM_USER_ENV       DEFAULT=1

EDITOR             DEFAULT=vim
VISUAL             DEFAULT=vim

# Set locale; also set in config/locale.conf but that isn't always read.
LANG               DEFAULT=m4_user_config_LANG.utf8
LANGUAGE           DEFAULT=m4_user_config_LANGUAGE

XDG_CONFIG_HOME    DEFAULT="m4_env_config_XDG_CONFIG_HOME"
XDG_DATA_HOME      DEFAULT="m4_env_config_XDG_DATA_HOME"
XDG_CACHE_HOME     DEFAULT="m4_env_config_XDG_CACHE_HOME"

# bash history
HISTFILE           DEFAULT="m4_env_config_XDG_DATA_HOME/bash/history"

m4_ifdef(??[[<<m4_env_config_CARGO>>]]??,m4_dnl
# Rust Cargo Configuration
CARGO_HOME         DEFAULT="m4_env_config_XDG_DATA_HOME/cargo"
)m4_dnl

m4_ifdef(??[[<<m4_env_config_CUDA_ROOT>>]]??,m4_dnl
# CUDA Configuration
CUDA_CACHE_PATH    DEFAULT="m4_env_config_XDG_CACHE_HOME/nv"
)m4_dnl

m4_ifdef(??[[<<m4_env_config_RUBY_GEM>>]]??,m4_dnl
# Ruby Gem Configuration Directories
GEMRC              DEFAULT="m4_env_config_XDG_CONFIG_HOME/gem/config.yaml"
GEM_HOME           DEFAULT="m4_env_config_XDG_DATA_HOME/gem"
GEM_SPEC_CACHE     DEFAULT="m4_env_config_XDG_CACHE_HOME/gem"
)m4_dnl

# gnupg
GNUPGHOME          DEFAULT="m4_env_config_XDG_DATA_HOME/gnupg"

m4_ifdef(??[[<<m4_env_config_GRIP>>]]??,m4_dnl
# grip
GRIPHOME           DEFAULT="m4_env_config_XDG_CACHE_HOME/grip"
)m4_dnl

# GTK
GTK2_RC_FILES=     DEFAULT="m4_env_config_XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# ICE
ICEAUTHORITY       DEFAULT="m4_env_config_XDG_CACHE_HOME/ICEauthority"

# KDE
KDEHOME            DEFAULT="m4_env_config_XDG_CONFIG_HOME/kde"

# less: disable history
LESSHISTFILE       DEFAULT=-

# npm
m4_dnl I've had ~/.npm created even when npm isn't installed so no program check
NPM_CONFIG_USERCONFIG DEFAULT="m4_env_config_XDG_CONFIG_HOME/npm/config"

m4_ifdef(??[[<<m4_env_config_PYTHON>>]]??,m4_dnl
# Python Environment
PYTHONSTARTUP      DEFAULT="m4_env_config_XDG_CONFIG_HOME/python/startup.py"
PYLINTRC           DEFAULT="m4_env_config_XDG_CONFIG_HOME/pylint/config"
PYLINTHOME         DEFAULT="m4_env_config_XDG_CACHE_HOME/pylint"
THEANORC           DEFAULT="m4_env_config_XDG_CONFIG_HOME/theano/config"
# Set Tensorflow loglevel to WARNING (default INFO)
TF_CPP_MIN_LOG_LEVEL DEFAULT=1
)m4_dnl

# OpenSSL Seed File (Defaults to $HOME/.rnd)
RANDFILE           DEFAULT="m4_env_config_XDG_CACHE_HOME/openssl/rnd"

m4_ifdef(??[[<<m4_env_config_RLWRAP>>]]??,m4_dnl
# RLWrap history file directory
RLWRAP_HOME        DEFAULT="m4_env_config_XDG_DATA_HOME/rlwrap"
)m4_dnl

# ssh-agent
SSH_AUTH_SOCK      DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"

m4_ifdef(??[[<<m4_env_config_TASK>>]]??,m4_dnl
# Task configuration file
TASKRC             DEFAULT="m4_env_config_XDG_CONFIG_HOME/task/config"
)m4_dnl

m4_ifdef(??[[<<m4_env_config_TERMINFO>>]]??,m4_dnl
# terminfo
# Setting TERMINFO causes the system path to no longer be checked by default
# Need to set TERMINFO_DIRS as well; and an empty entry (ends with :) searches
# the system path
TERMINFO           DEFAULT="m4_env_config_TERMINFO"
TERMINFO_DIRS      DEFAULT="m4_env_config_TERMINFO:"
)m4_dnl

# tmux
TMUX_TMPDIR        DEFAULT="${XDG_RUNTIME_DIR}"

# Vim Environment
VIMINIT            DEFAULT=":source m4_env_config_XDG_CONFIG_HOME/vim/vimrc"

# wget
WGETRC             DEFAULT="m4_env_config_XDG_CONFIG_HOME/wgetrc"

# WINE
m4_ifdef(??[[<<m4_env_config_WINE>>]]??,m4_dnl
WINEPREFIX         DEFAULT="m4_env_config_XDG_DATA_HOME/wine"
)m4_dnl

# xinit configuration
XINITRC            DEFAULT="m4_env_config_XDG_CONFIG_HOME/xinit/xinitrc"
XSERVERRC          DEFAULT="m4_env_config_XDG_CONFIG_HOME/xinit/xserverrc"

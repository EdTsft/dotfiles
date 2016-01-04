m4_include(user_config.m4)m4_dnl
m4_include(env_config.m4)m4_dnl
set -g fish_color_cwd yellow

# Coloured man pages
set -x LESS_TERMCAP_mb (printf "\e[01;31m")
set -x LESS_TERMCAP_md (printf "\e[01;38;5;74m")
set -x LESS_TERMCAP_me (printf "\e[0m")
set -x LESS_TERMCAP_se (printf "\e[0m")
set -x LESS_TERMCAP_so (printf "\e[38;5;246m")
set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_us (printf "\e[04;38;5;146m")

# Add user's bin to path
set --global fish_user_paths $fish_user_paths $HOME/bin

m4_ifdef(??[[<<m4_env_config_KEYCHAIN>>]]??,
keychain --eval --agents ssh -Q --quiet m4_user_config_PRIVATE_KEYS | source
)m4_dnl

m4_ifdef(??[[<<m4_env_config_GEM_BIN_PATH>>]]??,
set --global fish_user_paths $fish_user_paths (echo "m4_env_config_GEM_BIN_PATH" | sed 's/:/\n/g')
)

m4_ifdef(??[[<<m4_env_config_VIRTUALFISH>>]]??,
eval (python -m virtualfish auto_activation)
)
m4_include(user_config.m4)m4_dnl
m4_include(env_config.m4)m4_dnl
[user]
	name = m4_user_config_NAME
	email = m4_user_config_EMAIL
[color]
	ui = true
[core]
	editor = vim
	excludesfile = ~/.gitignore_global
[diff]
	tool = vimdiff
[merge]
	tool = vimdiff
[mergetool]
	keepBackup = false
[alias]
	a = add
	and-submodules = submodule update --init --recursive
	ap = add --patch
	b = branch
	bm = branch --merged
	cb = checkout --branch
	d = diff
	dc = diff --cached
	ds = diff --stat
	s = status
	ss = status --short
	showtrackedignored = ls-files -i --exclude-standard
	t = log --graph --oneline --decorate --author-date-order
	ta = log --graph --oneline --decorate --author-date-order --all
	tree = log --graph --oneline --decorate --author-date-order
	treea = log --graph --oneline --decorate --author-date-order --all
m4_ifdef(??[[<<m4_env_config_GIT_PUSH_DEFAULT_SIMPLE>>]]??,
[push]
	default = simple
)m4_dnl

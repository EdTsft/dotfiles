#!/bin/bash
set -e
# set -u # TODO
shopt -s nullglob
shopt -s dotglob

COLOUR_START='\033['
COLOUR_END=''

RED="${COLOUR_START}0;31m${COLOUR_END}"
GREEN="${COLOUR_START}0;32m${COLOUR_END}"
COLOUR_OFF="${COLOUR_START}0m${COLOUR_END}"

prep_dir=prep
patch_dir=.patch
dotfiles=(\
	.Rprofile\
	.bash_aliases\
	.bash_profile\
	.bashrc\
	.config/fish/config.fish\
	.config/fish/functions/fish_prompt.fish\
	.config/flake8
	.gitconfig\
	.gitignore_global\
	.hgrc\
	.profile\
	.pylintrc\
	.tmux.conf\
	.tmuxline.conf\
	.vimrc\
)
dotdirs=(.vim)
patchdirs=($(find * -maxdepth 1 -name applies -exec dirname {} \;))
export ROOTDIR=$(pwd)

if hash gcp &>/dev/null; then
	cpbin=gcp
else
	cpbin=cp
fi

PATCH_CMD="patch --no-backup-if-mismatch"

rm -f Makefile
# Write the static parts of the makefile
echo "# ******************** Autogenerated ********************
# * This file was autogenerated by configure.sh         *
# * Any changes will be overwritten on next configure.  *
# *******************************************************

PREP_DIR:=${prep_dir}
PATCH_DIR:=${patch_dir}
DOTFILES:=${dotfiles[@]}
PREPARED_DOTS:=\$(addprefix \$(PREP_DIR)/, \$(DOTFILES))
DOTDIRS:=${dotdirs[@]}

.SUFFIXES:
.PHONY: all prepare linkdirs \$(DOTDIRS)
all: prepare
prepare: \$(PREPARED_DOTS)
install: prepare linkdirs
	${cpbin} --verbose --recursive prep/. \$(HOME)
clean:
	rm -rf \$(PREP_DIR) \$(PATCH_DIR)
linkdirs: \$(DOTDIRS)
\$(DOTDIRS): % :
	ln -sfn \$(CURDIR)/\$@ \$(HOME)/\$@
\$(PREP_DIR):
	mkdir \$(PREP_DIR)
\$(PATCH_DIR):
	mkdir \$(PATCH_DIR)
\$(PREPARED_DOTS): \$(PREP_DIR)/% : % \$(PATCH_DIR)/%.patch \$(PATCH_DIR)/%.append | \$(PREP_DIR)
	${cpbin} --parents \$< \$(PREP_DIR)
	if [ -s \"\$(PATCH_DIR)/\$<.patch\" ]; then \\
	${PATCH_CMD} \"\$(PREP_DIR)/\$<\" \"\$(PATCH_DIR)/\$<.patch\"; \\
	fi
	if [ -s \"\$(PATCH_DIR)/\$<.append\" ]; then \\
	cat \"\$(PATCH_DIR)/\$<.append\" >> \"\$(PREP_DIR)/\$<\"; \\
	fi
" > Makefile

# Iterate over patch directories and apply if patchdir/applies returns 0
echo "Configuring patches"
echo "-------------------"
config_dir=/tmp/_dotfiles_config
mkdir -p "${config_dir}"
for patchdir in "${patchdirs[@]}"; do
	echo -n "${patchdir}... "
	if "${patchdir}/applies"; then
		echo -e "${GREEN}yes${COLOUR_OFF}"
		for patchfile in $(find ${patchdir} -type f -name '*.patch'); do
			if [ -z ${patchfile} ]; then
				break;
			fi
			patchbase="${patchfile#${patchdir}/}"
			patch_config_path="${config_dir}/${patchbase}"
			mkdir -p "$(dirname ${patch_config_path})"
			echo -n "${patchfile} " >> "${patch_config_path}"
		done
		for appendfile in $(find ${patchdir} -type f -name '*.append'); do
			if [ -z ${appendfile} ]; then
				break;
			fi
			appendbase="${appendfile#${patchdir}/}"
			append_config_path="${config_dir}/${appendbase}"
			mkdir -p "$(dirname ${append_config_path})"
			echo -n "${appendfile} " >> "${config_dir}/${appendbase}"
		done
	else
		echo -e "${RED}no${COLOUR_OFF}"
	fi
done

for dfile in "${dotfiles[@]}"; do
	mkdir -p $(dirname "$config_dir/$dfile.patch")
	touch "$config_dir/$dfile.patch"
	d_patches=($(cat "${config_dir}/$dfile.patch"))

	dpatch="$dfile.patch"
	echo "\$(PATCH_DIR)/$dpatch: ${d_patches[@]} | \$(PATCH_DIR)" >> Makefile
	echo "	rm -f \$@ && mkdir -p \$(dir \$@) && touch \$@" >> Makefile
	if [ -n "$d_patches" ]; then
		for d_patch in "${d_patches[@]}"; do
			echo "	combinediff-careful \"\$(PATCH_DIR)/$dpatch\" \"${d_patch}\" > \"\$(PATCH_DIR)/$dpatch\"" >> Makefile
		done
	fi

	touch "$config_dir/$dfile.append"
	d_appends=($(cat "$config_dir/$dfile.append"))

	dapp="$dfile.append"
	echo "\$(PATCH_DIR)/$dapp: ${d_appends[@]} | \$(PATCH_DIR)" >> Makefile
	echo "	rm -f \$@ && mkdir -p \$(dir \$@) && touch \$@" >> Makefile
	if [ -n "$d_appends" ]; then
		for d_app in "${d_appends[@]}"; do
			echo "	cat \"$d_app\" >> \"\$(PATCH_DIR)/$dapp\"" >> Makefile
		done
	fi
done
rm -rf "$config_dir"

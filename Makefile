HOME_DIR=${HOME}
BIN_DIR=/opt
GIT_DIR=${HOME_DIR}/git
TARGET=" dest_dir install-deb install-bin git install-src vim vundle bash fzf i3 light-prompt "
SHELL=/bin/bash

install: ${TARGET}
install-deb:
	cat install-deb | xargs sudo apt-get install -y
install-bin:
	mkdir -p ${BIN_DIR}
	TMP_DIR=$(shell mktemp -d); \
	while read bin; do \
	wget $${bin} -P $${TMP_DIR}; \
	if [[ $${bin##*.} == zip ]]; then sudo unzip -o "$${TMP_DIR}/$$(basename $${bin})" -d ${BIN_DIR}; \
	elif [[ $${bin##*.} == tgz ]]; then sudo tar -xzf "$${TMP_DIR}/$$(basename $${bin})" -C ${BIN_DIR}; fi; \
	done < install-bin
install-src:
	mkdir -p ${GIT_DIR}
	while read word; do \
	if [[ ! -e ${GIT_DIR}/$${word##*/} ]]; \
	then eval git clone https://github.com/$${word}.git ${GIT_DIR}/$${word##*/}; \
	fi;\
	done < install-src
dest_dir:
	mkdir -p ${HOME_DIR}
vim:
	rsync -r vim/ ${HOME_DIR}
git:
	rsync -r git/ ${HOME_DIR}
i3:
	rsync -r i3/ ${HOME_DIR}
bash:
	cat bash/.profile >> ${HOME_DIR}/.profile
	cat bash/.bashrc >> ${HOME_DIR}/.bashrc
light-prompt:
	cp ${GIT_DIR}/light-prompt/light-prompt.sh ${HOME_DIR}
	printf "# light-prompt\nsource ${HOME_DIR}/light-prompt.sh\n\n" >> ${HOME_DIR}/.bashrc
vundle:
	mkdir -p ${HOME_DIR}/.vim/bundle
	rsync ${GIT_DIR}/Vundle.vim ${HOME_DIR}/.vim/bundle
	vim +PluginInstall +qall
fzf:
	mkdir -p ${HOME_DIR}/.fzf
	cp ${GIT_DIR}/fzf/shell/key-bindings.bash ${HOME_DIR}/.fzf
	sudo cp ${GIT_DIR}/fzf/bin/fzf-tmux ${BIN_DIR}
	printf "# fzf\nsource ~/.fzf/key-bindings.bash\nexport  FZF_DEFAULT_OPTS=''\n\n" >> ${HOME_DIR}/.bashrc

clean:
	rm -rf dot
.PHONY: install ${TARGET} clean

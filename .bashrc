export PATH=$PATH:/home/vincenzo/.emacs.d/bin
export TERM="xterm-256color"

<<<<<<< HEAD
# Functions
 
rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

=======
>>>>>>> e9a5a61405e41f0cd3fb6c01962053a64a0aa29e
source ~/.aliasrc
eval "$(starship init bash)"

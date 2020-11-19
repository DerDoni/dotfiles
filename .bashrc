export PATH=$PATH:/home/vincenzo/.emacs.d/bin
export TERM="xterm-256color"


## ALIASES

alias vim="nvim"

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias status='git status'
alias tag='git tag'
alias newtag='git tag -a'


# Nix
alias uphome='home-manager switch -f ~/nix-config/home.nix'

# config
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

eval "$(starship init bash)"

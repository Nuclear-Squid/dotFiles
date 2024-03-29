#|
#| File    : ~/.bash_aliases
#| Author  : Léo Cazenave
#| Source  : https://github.com/Leo-Caz/dotFiles
#| Licence : WTFPL
#|
#| These aliases are used by both bash and zsh (requires bash 4 or newer).
#| For zsh-specific aliases, use ~/.zshrc.
#|

# color support? (mostly because of gVim) <<<
case "$TERM" in
  xterm*|rxvt*|screen|vt100)
    COLOR_TERM=$TERM;; # we know these terms have proper color support
  *)
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      COLOR_TERM=$TERM # we seem to have color support:
                       # assume it's compliant with ECMA-48 (ISO/IEC-6429)
    fi;;
esac # >>>

# enable color support for ls and grep when possible <<<
if [ "$COLOR_TERM" ]; then
  # export GREP_COLOR='1;32'
  # export GREP_OPTIONS='--color=auto'
  # find the option for using colors in ls, depending on the version: GNU or BSD
  ls --color -d . &>/dev/null 2>&1 \
    && alias ls='ls --group-directories-first --color=auto' \
    || alias ls='ls --group-directories-first -G' # BSD
else
  alias ls='ls --group-directories-first'
fi # >>>

# some handy ls aliases
if command -v exa >/dev/null 2>&1; then
  # super-fancy variants, powered by `exa` (rust)
  alias l='exa --group-directories-first'
  alias la='l -a'
  alias ll='l -l --git --time-style long-iso'
  alias lla='l -la --git --time-style long-iso'
else
  # good old stuff, works everywhere
  alias l='ls -C'
  alias la='ls -A'
  alias ll='ls -lhH'
  alias lla='ls -alhH'
fi

lt() {
  if command -v exa >/dev/null 2>&1; then
    exa --long --git --time-style long-iso --tree --level="$1"
  else
	echo "'exa' not active rn, dunno why"
  fi
}

# man pages look better in `most` than in `less`
if command -v most >/dev/null 2>&1; then
  alias man='man -P most'
fi

# list files modified today
lmru() {
  find "$1" -mtime -1 -print
}

# basic directory operations
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# cd, but better (what exactly do you mean by "just use `ls` you lazy fuck"?)
cl() {
	if [ "$#" = 0 ]
	then cd "$HOME" || return
	else
		cd "$1" || return
		# Only one thing in current dir and it’s another dir
		while [ "$(find ./ -mindepth 1 -maxdepth 1 | wc -l)" = 1 ] &&
		      [ "$(find ./ -mindepth 1 -maxdepth 1 -type d | wc -l)" = 1 ]
		do
			next_dir=$(ls -A)
			printf "Auto-jumped inside of \`%s\`\n" "$next_dir"
			cd "$next_dir" || return
		done
	fi
	ll
}

# create a folder and go inside it
cf() {
	mkdir -p "$@"
	cd "$1"
}

# Vim <3 Neovim <3 <3
# alias v="if [ -e .vimrc ]; then; vim -u .vimrc; else; vim; fi"
alias v=nvim
alias vi="neovide"  # The future is now, old man
alias nvi="nvim -u NONE"
alias vimrc="vim ~/.vimrc"
alias nvimrc="nvim ~/.config/nvim/init.vim"
alias lr="[ $RANGER_LEVEL ] && exit || ranger"
alias :q=exit

alias dual-screen="xrandr --auto --output HDMI-2 --mode 1920x1080 --right-of eDP-1"

# ring a bell to the window manager
# (requires `urgentOnBell` to be set to true for urxvt)
alias bell="echo -e '\a'"

# \_o<
alias ducksay="cowsay -f duck"
alias coin='echo "\_o<"'
alias pan='echo "\_x<"'

# Choo Choo mother fucker !!
alias choochoo="while [ 1 -eq 1 ]; do sl; done"

# smart SSH agent: http://beyond-syntax.com/blog/2012/01/on-demand-ssh-add/
#       (see also: https://gist.github.com/1998129)
alias ssh='( ssh-add -l > /dev/null || ssh-add ) && ssh'
alias git-push='( ssh-add -l > /dev/null || ssh-add ) && git push'
alias git-pull='( ssh-add -l > /dev/null || ssh-add ) && git pull'
alias git-fetch='( ssh-add -l > /dev/null || ssh-add ) && git fetch'

# add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i '\
'"$([ $? = 0 ] && echo terminal || echo error)" '\
'"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# geekiest thing ever
alias weather='curl wttr.in/Grenoble'

# Blender shortcut:
alias blender="snap run blender"

# wifi aliases:
alias wifi-mobile='nmcli con up Connard-wifi passwd-file ~/Code/dotFiles/config/other/4g_password'

# OSX style
alias open=xdg-open

# Convert a markdown file to pdf and opens it
pdfConvert() {
	if [ "$3" = "-N" ]
	then
		echo bite
		pandoc "$1" -N -o "$2" && open "$2" &
	else
		pandoc "$1" -o "$2" && open "$2" &
	fi
}

# Compiles C program and executes it
cexec() {
	[ ! -d Exec ] && mkdir Exec        # Create "Exec" folder for executable files
	execName=$(basename "$1" ".c")     # Remove file extention from executable file
	if clang "$1" -o Exec/"$execName"  # Compile program with correct path + check errors
	then
		./Exec/"$execName" "${@:2}"    # Execute script with every args (execpt $1)
	fi
}

# Compiles Rust (<3 <3 <3) program and executes it
rexec() {
	[ ! -d Exec ] && mkdir Exec        # Create "Exec" folder for executable files
	execName=$(basename "$1" ".rs")     # Remove file extention from executable file
	if rustc "$1" -o Exec/"$execName"  # Compile program with correct path + check errors
	then
		./Exec/"$execName" "${@:2}"    # Execute script with every args (execpt $1)
	fi
}

# trick to define default arguments
# (only works when commands are typed manually in a shell)
alias less='less -F'
alias tmux='tmux -2'
alias nautilus='nautilus --no-desktop'
alias nemo='nemo --no-desktop'

# CPU performance
alias watch_cpu="watch -n 1 'cat /proc/cpuinfo | grep -i mhz'"

# MRU
alias freq='cut -f1 -d" " $HISTFILE | sort | uniq -c | sort -nr | head -n 30'

# __vcs_info: print branch for bzr/git/hg/svn version control in CWD <<<
# http://blog.grahampoulter.com/2011/09/show-current-git-bazaar-or-mercurial.html
__vcs_info() {
  local dir="$PWD"
  local logo="#"
  local vcs
  local branch
  while [[ "$dir" != "/" ]]; do
    for vcs in git hg svn bzr; do
      if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
        case "$vcs" in
          git)
            # if type __git_ps1 > /dev/null 2>&1; then
            #   __git_ps1 "${1:-[± %s] }"; return # use __git_ps1 when available
            # fi
            logo="±"; branch=$(git branch 2>/dev/null | grep ^\* | sed s/^\*.//);;
          hg)
            logo="☿"; branch=$(hg branch 2>/dev/null);;
          svn)
            logo="‡"; branch=$(svn info 2>/dev/null\
                | grep -e '^Repository Root:'\
                | sed -e 's#.*/##');;
          bzr)
            local conf="${dir}/.bzr/branch/branch.conf" # normal branch
            [[ -f "$conf" ]] && branch=$(grep -E '^nickname =' "$conf" | cut -d' ' -f 3)
            conf="${dir}/.bzr/branch/location" # colo/lightweight branch
            [[ -z "$branch" ]] && [[ -f "$conf" ]] && branch="$(basename "$(< $conf)")"
            [[ -z "$branch" ]] && branch="$(basename "$(readlink -f "$dir")")";;
        esac
        # optional $1 of format string for printf, default "‡ [%s] "
        [[ -n "$branch" ]] && printf "${1:-[$logo %s] }" "$branch"
        return 0
      fi
    done
    dir="$(dirname "$dir")"
  done
} # >>>

# seconds <-> hh:mm:ss <<<
# Works with GNU sed (Linux…), not sure it works on OSX
__hms2sec() {
  # with sed and bc:
  echo $1 \
    | sed -E 's/(.*):(.+):(.+)/\1*3600+\2*60+\3/;s/(.+):(.+)/\1*60+\2/' \
    | bc
  # with awk:
  # num=`echo $1 | awk -F: '{ print NF-1 }'`
  # case "$num" in
  #   0) echo $1;;
  #   1) echo $1 | awk -F: '{ print $2 + $1*60 }';;
  #   2) echo $1 | awk -F: '{ print $3 + $2*60 + $1*3600 }';;
  # esac
}
__sec2hms() {
  # printf %02d:%02d:%02d\\n $(($1/3600)) $(($1%3600/60)) $(($1%60))
  # handling decimals:
  t=`echo $1 | sed -E 's/\..*$//'`
  d=`echo $1 | sed -E 's/^.*\.//'`
  if [ "$t" = "$1" ]; then
    printf %02d:%02d:%02d\\n $((t/3600)) $((t%3600/60)) $((t%60))
  else
    printf %02d:%02d:%02d.%d\\n $((t/3600)) $((t%3600/60)) $((t%60)) $d
  fi
}
# >>>

# vim: set fdm=marker fmr=<<<,>>> fdl=0 ft=sh:

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
export PATH=/home/astro/.local/bin:/home/astro/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/mnt/shared/bin
alias ,soup-build-serve="soupault && python3 -m http.server -d build/"
alias ,wcsort='find . -name "*.org" -print0 | wc -w --files0-from=- | sort -n'
alias ,serve="python3 -m http.server"


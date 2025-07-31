# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/bin/python3:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to local binaries
export PATH=~/.local/bin:$PATH

# GO Path
export PATH="$PATH:$(go env GOPATH)/bin"

# Load spaceship theme
source $(brew --prefix)/opt/spaceship/spaceship.zsh

# display current date and time
echo
TODAY=`date +"Today is: %A %d %B %Y"`
LAST_DAY=`date +"%Y-12-31"`
DAYS_IN_YEAR=`date -j -f "%Y-%m-%d" $LAST_DAY +"%j"`
CURRENT_NO_DAY=`date +%j`
TIME=`date +"The time: %R"`
echo "$TODAY — day no $CURRENT_NO_DAY of $DAYS_IN_YEAR, $TIME"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
plugins=(git npm)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

#Alias for python
alias python=python3
alias ppip:i="python -m pip install"
alias dj:man="python manage.py"
alias dj:migrate="dj:man migrate"
alias dj:migrations="dj:man makemigrations"
alias dj:run="dj:man runserver"
alias dj:shell="dj:man shell"
alias dj:test="dj:man test"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases for fzfed commands
alias fan='man $(compgen -c | fzf)'
alias tldf='tldr $(compgen -c | fzf)'

# Aliases for other commands
alias mergemaster='GIT_CURRENT=$(git branch --show-current) && git switch master && git pull && git switch $GIT_CURRENT && git merge master'

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"



# # Herd injected PHP 8.3 configuration.
# export HERD_PHP_83_INI_SCAN_DIR="/Users/stefan/Library/Application Support/Herd/config/php/83/"
#
#
# # Herd injected PHP binary.
# export PATH="/Users/stefan/Library/Application Support/Herd/bin/":$PATH
#

# # Herd injected NVM configuration
# export NVM_DIR="/Users/stefan/Library/Application Support/Herd/config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#
# [[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"


# # Herd injected PHP 8.4 configuration.
# export HERD_PHP_84_INI_SCAN_DIR="/Users/stefan/Library/Application Support/Herd/config/php/84/"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export MCP_CONFIG_PATH="$HOME/.claude/mcp.json"


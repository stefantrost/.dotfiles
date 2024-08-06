# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/bin/python3:$PATH
export PATH=~/.jetbrains-launchers:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to local binaries
export PATH=~/.local/bin:$PATH

# GO Path
export PATH="$PATH:$(go env GOPATH)/bin"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
source $(brew --prefix)/opt/spaceship/spaceship.zsh

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
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

alias rba='npm run start:bestellapp'
alias ra='npm run start:admin'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases for fzfed commands
alias fan='man $(compgen -c | fzf)'
alias tldf='tldr $(compgen -c | fzf)'

# Aliases for other commands
alias mergemaster='GIT_CURRENT=$(git branch --show-current) && git switch master && git pull && git switch $GIT_CURRENT && git merge master'

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"


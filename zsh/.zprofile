eval "$(/opt/homebrew/bin/brew shellenv)"

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

bindkey -s ^f "tmux-sessionizer\n"

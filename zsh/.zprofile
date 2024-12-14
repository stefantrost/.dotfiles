eval "$(/opt/homebrew/bin/brew shellenv)"

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

bindkey -s ^f "tmux-sessionizer\n"

export ANTHROPIC_API_KEY=$(security find-generic-password -a "$USER" -s 'claude-api-key' -w)

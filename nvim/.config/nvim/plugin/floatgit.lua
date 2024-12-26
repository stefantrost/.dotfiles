local state = {
  floating = {
    git = {
      buf = -1,
      win = -1,
    },
    commit = {
      buf = -1,
      win = -1,
      commit_win = -1,
    },
  },
}
function create_floating_commit(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns)
  local height = opts.height or math.floor(vim.o.lines)

  local col = math.floor(vim.o.columns)
  local row = math.floor(vim.o.lines)

  vim.cmd "Git commit"

  local win_id = vim.api.nvim_get_current_win()

  local buf = vim.api.nvim_win_get_buf(win_id)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = "GIT COMMIT",
    title_pos = "center",
    zindex = 99,
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win, commit_win = win_id }
end

local function create_floating_git(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  vim.cmd "G"

  local win_id = vim.api.nvim_get_current_win()

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_win_get_buf(win_id)
  end

  vim.api.nvim_win_close(win_id, false)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = "GIT",
    title_pos = "center",
    zindex = 80,
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function toggle_float_git()
  if not vim.api.nvim_win_is_valid(state.floating.git.win) then
    state.floating.git = create_floating_git { buf = state.floating.git.buf }
  else
    vim.api.nvim_win_hide(state.floating.git.win)
  end
end

local function toggle_float_commit()
  if not vim.api.nvim_win_is_valid(state.floating.commit.win) then
    state.floating.commit = create_floating_commit { buf = state.floating.commit.buf }
  else
    vim.api.nvim_win_hide(state.floating.commit.win)
    vim.api.nvim_win_hide(state.floating.commit.commit_win)
    vim.api.nvim_set_current_win(state.floating.git.win)
  end
end

vim.api.nvim_create_user_command("Floatnotes", toggle_float_git, {})

vim.keymap.set("n", "<leader>fg", toggle_float_git)
vim.keymap.set("n", "<leader>cf", toggle_float_commit)

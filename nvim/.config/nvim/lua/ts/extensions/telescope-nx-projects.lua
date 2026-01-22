local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Find nx.json by walking up directory tree
local function find_nx_root(start_path)
  local current = start_path or vim.fn.getcwd()
  local max_depth = 20

  for _ = 1, max_depth do
    local nx_json = current .. "/nx.json"
    if vim.fn.filereadable(nx_json) == 1 then
      return current
    end

    local parent = vim.fn.fnamemodify(current, ":h")
    if parent == current then
      break
    end -- reached filesystem root
    current = parent
  end

  return nil
end

-- Get list of all Nx projects
local function get_all_projects(nx_root)
  local cmd = string.format("cd %s && npx nx show projects", vim.fn.shellescape(nx_root))
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get Nx projects: " .. output, vim.log.levels.ERROR)
    return {}
  end

  local projects = {}
  for line in output:gmatch "[^\r\n]+" do
    if line ~= "" then
      table.insert(projects, line)
    end
  end

  if #projects == 0 then
    vim.notify("No Nx projects found in workspace", vim.log.levels.WARN)
  end

  return projects
end

-- Get project root directory for a specific project
local function get_project_root(nx_root, project_name)
  local cmd = string.format("cd %s && npx nx show project %s", vim.fn.shellescape(nx_root), vim.fn.shellescape(project_name))
  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to get project info for " .. project_name, vim.log.levels.WARN)
    return nx_root -- fallback to workspace root
  end

  -- Parse JSON output
  local ok, project_data = pcall(vim.json.decode, output)
  if ok and project_data and project_data.root then
    return nx_root .. "/" .. project_data.root
  end

  -- If JSON parsing fails, show error with output preview
  vim.notify(
    string.format("Failed to parse project info for %s. Output: %s", project_name, output:sub(1, 100)),
    vim.log.levels.WARN
  )
  return nx_root
end

-- Get project root directory asynchronously using plenary.job
local function get_project_root_async(nx_root, project_name, callback)
  local Job = require("plenary.job")
  local timeout_ms = 30000 -- 30 second timeout
  local callback_called = false
  local timer = nil

  local function call_callback_once(...)
    if not callback_called then
      callback_called = true
      if timer then
        timer:stop()
        timer:close()
      end
      callback(...)
    end
  end

  -- Set up timeout timer
  timer = vim.loop.new_timer()
  timer:start(timeout_ms, 0, function()
    vim.schedule(function()
      if not callback_called then
        vim.notify(
          string.format("Timeout getting project info for %s (nx not responding)", project_name),
          vim.log.levels.WARN
        )
        call_callback_once(nx_root) -- fallback to workspace root
      end
    end)
  end)

  local job = Job:new({
    command = "npx",
    args = { "nx", "show", "project", project_name },
    cwd = nx_root,
    on_exit = function(j, exit_code)
      vim.schedule(function()
        if callback_called then
          return -- timeout already fired
        end

        if exit_code ~= 0 then
          vim.notify("Failed to get project info for " .. project_name, vim.log.levels.WARN)
          call_callback_once(nx_root)  -- fallback to workspace root
          return
        end

        local output = table.concat(j:result(), "\n")
        local ok, project_data = pcall(vim.json.decode, output)

        if ok and project_data and project_data.root then
          call_callback_once(nx_root .. "/" .. project_data.root)
        else
          vim.notify(
            string.format("Failed to parse project info for %s", project_name),
            vim.log.levels.WARN
          )
          call_callback_once(nx_root)
        end
      end)
    end,
  })

  job:start()
end

-- Create a Telescope picker for Nx projects
local function create_project_picker(opts, on_select_callback)
  opts = opts or {}

  local nx_root = find_nx_root()
  if not nx_root then
    vim.notify("Not in an Nx workspace (nx.json not found)", vim.log.levels.WARN)
    return
  end

  -- Create async job finder
  local finder = finders.new_async_job {
    command_generator = function()
      return {
        "npx",
        "nx",
        "show",
        "projects",
      }
    end,
    entry_maker = function(line)
      if not line or line == "" then
        return nil
      end
      return {
        value = line,
        display = line,
        ordinal = line,
      }
    end,
    cwd = nx_root,
  }

  pickers
    .new(opts, {
      prompt_title = "Nx Projects",
      finder = finder,
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            -- Get project root asynchronously
            get_project_root_async(nx_root, selection.value, function(project_root)
              on_select_callback(project_root, nx_root, selection.value)
            end)
          end
        end)
        return true
      end,
    })
    :find()
end

-- Pick a project and open it in file explorer
local function nx_pick_project(opts)
  create_project_picker(opts, function(project_root, nx_root, project_name)
    -- Use Oil.nvim API to open directory
    local ok, oil = pcall(require, "oil")
    if ok then
      oil.open(project_root)
    else
      -- Fallback to netrw if Oil not available
      vim.cmd("edit " .. vim.fn.fnameescape(project_root))
    end
  end)
end

-- Pick a project and find files within it
local function nx_find_files(opts)
  create_project_picker(opts, function(project_root, nx_root, project_name)
    require("telescope.builtin").find_files {
      cwd = project_root,
      prompt_title = string.format("Find Files [%s]", project_name),
    }
  end)
end

-- Pick a project and grep within it
local function nx_grep(opts)
  create_project_picker(opts, function(project_root, nx_root, project_name)
    require("telescope.builtin").live_grep {
      cwd = project_root,
      prompt_title = string.format("Live Grep [%s]", project_name),
    }
  end)
end

-- Setup function to register keymaps
M.setup = function()
  vim.keymap.set("n", "<leader>np", nx_pick_project, { desc = "[N]x [P]ick project" })
  vim.keymap.set("n", "<leader>nf", nx_find_files, { desc = "[N]x [F]ind files in project" })
  vim.keymap.set("n", "<leader>ng", nx_grep, { desc = "[N]x [G]rep in project" })
end

return M

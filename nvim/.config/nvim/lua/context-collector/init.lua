-- lua/llm-collector/init.lua

local M = {}

-- Plugin state
M.collection = {}
M.config = {
  keymaps = {
    add_current = "<leader>xa",
    add_from_telescope = "<leader>xf",
    export = "<leader>xe",
    show = "<leader>xs",
    clear = "<leader>xx",
    remove_current = "<leader>xr",
  },
  output_format = {
    header = "=== LLM CONTEXT FILES ===",
    file_separator = "--- FILE: %s (%s) ---",
    end_separator = "--- END FILE ---",
  },
}

-- Add current buffer to collection
function M.add_current_buffer()
  local filepath = vim.fn.expand "%:p"
  if filepath == "" or filepath == "[No Name]" then
    vim.notify("Cannot add unnamed buffer", vim.log.levels.WARN)
    return
  end

  M.collection[filepath] = true
  local filename = vim.fn.expand "%:t"
  vim.notify("Added: " .. filename, vim.log.levels.INFO)
end

-- Add file from telescope picker
function M.add_from_telescope()
  local has_telescope, _ = pcall(require, "telescope")
  if not has_telescope then
    vim.notify("Telescope not found", vim.log.levels.ERROR)
    return
  end

  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  require("telescope.builtin").find_files {
    prompt_title = "Add File to LLM Collection",
    attach_mappings = function(prompt_bufnr, map)
      -- Allow multiple selections with Tab
      map("i", "<Tab>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          M.collection[selection.path] = true
          vim.notify("Added: " .. selection[1], vim.log.levels.INFO)
        end
      end)

      -- Select and close with Enter
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          M.collection[selection.path] = true
          vim.notify("Added: " .. selection[1], vim.log.levels.INFO)
        end
      end)

      return true
    end,
  }
end

-- Export collection to clipboard
function M.export_collection()
  local files = vim.tbl_keys(M.collection)
  if #files == 0 then
    vim.notify("No files in collection", vim.log.levels.WARN)
    return
  end

  -- Sort files for consistent output
  table.sort(files)

  local output = { M.config.output_format.header, "" }

  for _, filepath in ipairs(files) do
    -- Check if file still exists
    if vim.fn.filereadable(filepath) == 0 then
      vim.notify("Warning: File not readable: " .. filepath, vim.log.levels.WARN)
      goto continue
    end

    local filename = vim.fn.fnamemodify(filepath, ":t")
    local relative_path = vim.fn.fnamemodify(filepath, ":.")

    table.insert(output, string.format(M.config.output_format.file_separator, filename, relative_path))
    table.insert(output, "")

    -- Read file contents safely
    local ok, lines = pcall(vim.fn.readfile, filepath)
    if ok then
      table.insert(output, table.concat(lines, "\n"))
    else
      table.insert(output, "ERROR: Could not read file content")
    end

    table.insert(output, "")
    table.insert(output, M.config.output_format.end_separator)
    table.insert(output, "")

    ::continue::
  end

  -- Copy to clipboard
  local content = table.concat(output, "\n")
  vim.fn.setreg("+", content) -- System clipboard
  vim.fn.setreg("*", content) -- Primary selection (Linux)

  vim.notify(string.format("Exported %d files to clipboard", #files), vim.log.levels.INFO)
end

-- Show current collection
function M.show_collection()
  local files = vim.tbl_keys(M.collection)
  if #files == 0 then
    vim.notify("No files in LLM collection", vim.log.levels.INFO)
    return
  end

  table.sort(files)

  local lines = { "LLM Collection (" .. #files .. " files):", "" }
  for _, filepath in ipairs(files) do
    local relative_path = vim.fn.fnamemodify(filepath, ":.")
    local exists = vim.fn.filereadable(filepath) == 1 and "✓" or "✗"
    table.insert(lines, string.format("  %s %s", exists, relative_path))
  end

  -- Create floating window to show collection
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "filetype", "llm-collection")

  local width = math.min(vim.o.columns - 4, 80)
  local height = math.min(vim.o.lines - 4, #lines + 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " LLM Collection ",
    title_pos = "center",
  })

  -- Close with q or Escape
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
end

-- Clear collection
function M.clear_collection()
  local count = vim.tbl_count(M.collection)
  M.collection = {}
  vim.notify(string.format("Cleared %d files from collection", count), vim.log.levels.INFO)
end

-- Remove current buffer from collection
function M.remove_current_buffer()
  local filepath = vim.fn.expand "%:p"
  if M.collection[filepath] then
    M.collection[filepath] = nil
    local filename = vim.fn.expand "%:t"
    vim.notify("Removed: " .. filename, vim.log.levels.INFO)
  else
    vim.notify("Current buffer not in collection", vim.log.levels.WARN)
  end
end

-- Get collection stats
function M.get_stats()
  local files = vim.tbl_keys(M.collection)
  local readable_count = 0
  local total_size = 0

  for _, filepath in ipairs(files) do
    if vim.fn.filereadable(filepath) == 1 then
      readable_count = readable_count + 1
      local size = vim.fn.getfsize(filepath)
      if size > 0 then
        total_size = total_size + size
      end
    end
  end

  return {
    total = #files,
    readable = readable_count,
    size = total_size,
  }
end

-- Setup function
function M.setup(opts)
  opts = opts or {}

  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  -- Create commands
  vim.api.nvim_create_user_command("LLMCollectionAdd", M.add_current_buffer, {
    desc = "Add current buffer to LLM collection",
  })

  vim.api.nvim_create_user_command("LLMCollectionAddFromTelescope", M.add_from_telescope, {
    desc = "Add file from telescope to LLM collection",
  })

  vim.api.nvim_create_user_command("LLMCollectionExport", M.export_collection, {
    desc = "Export LLM collection to clipboard",
  })

  vim.api.nvim_create_user_command("LLMCollectionShow", M.show_collection, {
    desc = "Show LLM collection",
  })

  vim.api.nvim_create_user_command("LLMCollectionClear", M.clear_collection, {
    desc = "Clear LLM collection",
  })

  vim.api.nvim_create_user_command("LLMCollectionRemove", M.remove_current_buffer, {
    desc = "Remove current buffer from LLM collection",
  })

  -- Set up keymaps if enabled
  if M.config.keymaps then
    local keymaps = M.config.keymaps

    if keymaps.add_current then
      vim.keymap.set("n", keymaps.add_current, M.add_current_buffer, { desc = "Add current buffer to LLM collection" })
    end

    if keymaps.add_from_telescope then
      vim.keymap.set(
        "n",
        keymaps.add_from_telescope,
        M.add_from_telescope,
        { desc = "Add file from telescope to LLM collection" }
      )
    end

    if keymaps.export then
      vim.keymap.set("n", keymaps.export, M.export_collection, { desc = "Export LLM collection to clipboard" })
    end

    if keymaps.show then
      vim.keymap.set("n", keymaps.show, M.show_collection, { desc = "Show LLM collection" })
    end

    if keymaps.clear then
      vim.keymap.set("n", keymaps.clear, M.clear_collection, { desc = "Clear LLM collection" })
    end

    if keymaps.remove_current then
      vim.keymap.set(
        "n",
        keymaps.remove_current,
        M.remove_current_buffer,
        { desc = "Remove current buffer from LLM collection" }
      )
    end
  end

  -- Status line integration (optional)
  if M.config.statusline then
    vim.g.llm_collection_count = function()
      return vim.tbl_count(M.collection)
    end
  end
end

return M

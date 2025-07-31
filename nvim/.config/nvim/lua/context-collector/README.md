# llm-collector.nvim

A Neovim plugin for collecting files into a list and exporting their contents to clipboard for LLM context.

## Features

- ✅ Add files to collection from current buffer or telescope picker
- ✅ Export all collected files to clipboard with proper formatting
- ✅ Show collection in a floating window
- ✅ Remove files from collection
- ✅ File existence validation
- ✅ Customizable keymaps and output format
- ✅ User commands for all functionality

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "your-username/llm-collector.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Optional but recommended
  },
  config = function()
    require("llm-collector").setup({
      -- Optional configuration
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "your-username/llm-collector.nvim",
  requires = {
    "nvim-telescope/telescope.nvim", -- Optional
  },
  config = function()
    require("llm-collector").setup()
  end
}
```

## Configuration

Default configuration:

```lua
require("llm-collector").setup({
  keymaps = {
    add_current = '<leader>la',           -- Add current buffer
    add_from_telescope = '<leader>lf',    -- Add from telescope picker
    export = '<leader>le',                -- Export to clipboard
    show = '<leader>ls',                  -- Show collection
    clear = '<leader>lx',                 -- Clear collection
    remove_current = '<leader>lr',        -- Remove current buffer
  },
  output_format = {
    header = "=== LLM CONTEXT FILES ===",
    file_separator = "--- FILE: %s (%s) ---",
    end_separator = "--- END FILE ---",
  },
  statusline = false,  -- Enable statusline integration
})
```

To disable keymaps and use commands only:

```lua
require("llm-collector").setup({
  keymaps = false,
})
```

## Usage

### Keymaps (default)

- `<leader>la` - Add current buffer to collection
- `<leader>lf` - Open telescope picker to add files (supports multi-select with Tab)
- `<leader>le` - Export collection to clipboard
- `<leader>ls` - Show collection in floating window
- `<leader>lx` - Clear entire collection
- `<leader>lr` - Remove current buffer from collection

### Commands

- `:LLMCollectionAdd` - Add current buffer to collection
- `:LLMCollectionAddFromTelescope` - Add file from telescope picker
- `:LLMCollectionExport` - Export collection to clipboard
- `:LLMCollectionShow` - Show collection in floating window
- `:LLMCollectionClear` - Clear collection
- `:LLMCollectionRemove` - Remove current buffer from collection

### Telescope Integration

When using `<leader>lf` or `:LLMCollectionAddFromTelescope`:
- Press `Tab` to add files without closing the picker (multi-select)
- Press `Enter` to add file and close picker

## Output Format

The exported content will be formatted like this:

```
=== LLM CONTEXT FILES ===

--- FILE: init.lua (lua/llm-collector/init.lua) ---

-- File contents here...

--- END FILE ---

--- FILE: README.md (README.md) ---

# Another file contents...

--- END FILE ---
```

## Workflow Example

1. Open a file you want to include: `:e src/main.js`
2. Add it to collection: `<leader>la`
3. Add more files via telescope: `<leader>lf` (use Tab for multi-select)
4. Review your collection: `<leader>ls`
5. Export to clipboard: `<leader>le`
6. Paste into your LLM conversation

## Requirements

- Neovim >= 0.8.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (optional, for file picker functionality)

## License

MIT

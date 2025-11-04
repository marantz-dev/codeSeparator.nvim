# codeSeparator.nvim

Simple, dependency‑free Neovim plugin to insert readable, commented separators in your code:

- Box separators for section headers
- Single‑line separators for inline headings

It automatically uses the current buffer's `commentstring`, so the separators match the language's comment style.

https://github.com/user-attachments/assets/81fe245b-01ea-4006-b847-60e9685c3fce

## Features

- `:BoxSeparator` – prompts for text and inserts a 5‑line commented box
- `:LineSeparator` – prompts for text and inserts a single commented line
- Respects `commentstring` for every filetype
- Configurable border character, padding, and box width
- Tiny surface area, no dependencies

## Requirements

- Neovim 0.7+ (uses `vim.ui.input` and user commands)

## Installation

### lazy.nvim

```lua
{
  "marantz-dev/codeSeparator.nvim",
  config = function()
    require("codeSeparator").setup()
  end,
}
```

### packer.nvim

```lua
use({
  "marantz-dev/codeSeparator.nvim",
  config = function()
    require("codeSeparator").setup()
  end,
})
```

> If you use another manager, just ensure you call `require("codeSeparator").setup()` during startup.

## Setup

Call `setup` once, optionally overriding defaults.

```lua
require("codeSeparator").setup({
  -- Character used for borders and line separators
  char = "#",           -- default

  -- Spaces around the text inside the box
  padding = 2,           -- default

  -- Inner content width for the box. If nil, auto‑sizes to text length + padding
  box_width = nil,       -- default
})
```

## Usage

Run the provided commands (they will prompt you for the separator text):

- `:BoxSeparator` – inserts a 5‑line box with your text centered by padding
- `:LineSeparator` – inserts a single line with your text between repeated chars

Both commands insert a trailing blank line after the separator for readability.

### Examples (in a Lua file)

With defaults (`char = "#"`, `padding = 2`).

```
-- #############
-- #           #
-- #  Section  #
-- #           #
-- #############

-- ########## Todos ##########
```

Because the plugin reads the buffer's `commentstring`, the same commands in, say, a C file would use `//` and in a CSS file `/* */`, etc.

## Options explained

- `char` (string): The character used for the box borders and the repeated parts of line separators. Common choices: `#`, `-`, `*`, `=`, `~`.
- `padding` (integer): Spaces added on both sides of the text inside the box line.
- `box_width` (integer|nil): Inner width of the box (area between the side borders). If `nil`, it auto‑fits to your text + padding. If you set a value smaller than the text+padding, the text will overflow; choose a width large enough for a neat box.

## Suggested keymaps

Map whatever you like to the commands:

```lua
vim.keymap.set("n", "<leader>sb", ":BoxSeparator<CR>", { desc = "Box separator" })
vim.keymap.set("n", "<leader>sl", ":LineSeparator<CR>", { desc = "Line separator" })
```

If you prefer calling Lua directly:

```lua
vim.keymap.set("n", "<leader>sb", function()
  require("codeSeparator").box_separator()
end, { desc = "Box separator" })

vim.keymap.set("n", "<leader>sl", function()
  require("codeSeparator").line_separator()
end, { desc = "Line separator" })
```

## Notes

- In buffers without a `commentstring` configured, separators are inserted without comment markers.
- The plugin is intentionally minimal. If you need dynamic full‑width lines or centering against window width, consider extending the logic in your config or opening an issue/PR.

## License

MIT — see `LICENSE`.

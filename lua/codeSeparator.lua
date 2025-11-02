local M = {}

local config = {
	char = "#", -- character used for borders
	padding = 2, -- spaces around the text
	box_width = nil, -- optional fixed width (nil = auto)
}

function M.setup(user_config)
	config = vim.tbl_deep_extend("force", config, user_config or {})
end

-- Repeat a character N times
local function repeat_char(char, count)
	return string.rep(char, count)
end

-- Get comment prefix/suffix for current filetype
local function get_comment_wrappers()
	local commentstring = vim.bo.commentstring -- e.g. "// %s", "# %s", "/* %s */"
	local pre, post = commentstring:match("^(.-)%%s(.-)$")
	return vim.trim(pre or ""), vim.trim(post or "")
end

-- Apply comment syntax to a list of lines
local function comment_lines(lines)
	local pre, post = get_comment_wrappers()
	for i, line in ipairs(lines) do
		lines[i] = pre .. (pre ~= "" and " " or "") .. line .. (post ~= "" and " " .. post or "")
	end
end

-- Insert box separator
function M.box_separator()
	vim.ui.input({ prompt = "Enter box text: " }, function(input)
		if not input or input == "" then
			return
		end

		local padded_text = repeat_char(" ", config.padding) .. input .. repeat_char(" ", config.padding)
		local width = config.box_width or #padded_text
		local border = repeat_char(config.char, width + 2)
		local empty = config.char .. repeat_char(" ", width) .. config.char
		local line = config.char .. padded_text .. config.char

		local lines = { border, empty, line, empty, border }
		comment_lines(lines)
		table.insert(lines, "") -- un-commented blank line
		vim.api.nvim_put(lines, "l", true, true)
	end)
end

-- Insert single-line separator
function M.line_separator()
	vim.ui.input({ prompt = "Enter line text: " }, function(input)
		if not input or input == "" then
			return
		end

		local text = " " .. input .. " "
		local hashes = repeat_char(config.char, 10)
		local line = hashes .. text .. hashes

		local lines = { line }
		comment_lines(lines)
		table.insert(lines, "") -- un-commented blank line
		vim.api.nvim_put(lines, "l", true, true)
	end)
end

-- Register user commands
vim.api.nvim_create_user_command("BoxSeparator", function()
	M.box_separator()
end, {})

vim.api.nvim_create_user_command("LineSeparator", function()
	M.line_separator()
end, {})

-- Set default keymaps
vim.keymap.set("n", "<leader>z", "<cmd>LineSeparator<CR>", { desc = "Insert line separator" })
vim.keymap.set("n", "<leader>Z", "<cmd>BoxSeparator<CR>", { desc = "Insert box separator" })

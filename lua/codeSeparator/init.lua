local M = {}

local config = {
    char = "#",
    padding = 2,
    box_width = nil,
}

local function repeat_char(char, count)
    return string.rep(char, count)
end

local function get_comment_wrappers()
    local commentstring = vim.bo.commentstring
    local pre, post = commentstring:match("^(.-)%%s(.-)$")
    return vim.trim(pre or ""), vim.trim(post or "")
end

local function comment_lines(lines)
    local pre, post = get_comment_wrappers()
    for i, line in ipairs(lines) do
        lines[i] = pre .. (pre ~= "" and " " or "") .. line .. (post ~= "" and " " .. post or "")
    end
end

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
        table.insert(lines, "")
        vim.api.nvim_put(lines, "l", true, true)
    end)
end

-- Line separator
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
        table.insert(lines, "")
        vim.api.nvim_put(lines, "l", true, true)
    end)
end

function M.setup(user_config)
    config = vim.tbl_deep_extend("force", config, user_config or {})

    vim.api.nvim_create_user_command("BoxSeparator", function()
        M.box_separator()
    end, {})

    vim.api.nvim_create_user_command("LineSeparator", function()
        M.line_separator()
    end, {})
end

return M

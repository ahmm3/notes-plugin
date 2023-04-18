local M = {}

M.match_link = function(s)
    local pattern = "%[.*%]%((.+)%)"
    return string.match(s, pattern)
end

--- Returns true if s ends with extension
-- e.g. has_extension("file.md", ".md") == True
M.has_extension = function(s, ext)
    return s:sub(s:len() - ext:len() + 1) == ext
end

M.strip_extension = function(s, ext)
    if M.has_extension(s, ext) then
        return s:sub(0, s:len() - ext:len())
    end

    return s
end

-- todo: move to different file
M.open_popup_window = function(filepath)
    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor(ui.width / 2)
    local height = math.floor(ui.height / 2)

    local buffer = vim.api.nvim_create_buf(false, true)

    local opts = {
        relative = "editor",
        width = width,
        height = height,
        col = (ui.width - width) / 2,
        row = (ui.height - height) / 2,
        style = "minimal",
        border = "rounded",
        title = "Capture to a note - type 'Q' to quit",
        title_pos = "center",
    }

    vim.api.nvim_open_win(buffer, true, opts)
    vim.cmd("edit " .. filepath)

    -- Save and quit with Q
    vim.keymap.set("n", "Q", "<cmd>wq<cr>", { buffer = buffer, desc = "Write and quit" })
end

return M

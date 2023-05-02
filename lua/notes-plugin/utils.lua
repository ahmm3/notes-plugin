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

---comment
---@param opts any
---@return number window_id
---@return number buffer_id
M.open_popup_window = function(opts)
    local opts = opts or {}

    local ui = vim.api.nvim_list_uis()[1]
    local width = math.floor(ui.width / 2)
    local height = math.floor(ui.height / 2)

    local buffer = vim.api.nvim_create_buf(false, true)

    local default_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = (ui.width - width) / 2,
        row = (ui.height - height) / 2,
        style = "minimal",
        border = "rounded",
        title = "Popup window",
        title_pos = "center",
    }
    local win_opts = vim.tbl_extend("force", default_opts, opts)

    local window = vim.api.nvim_open_win(buffer, true, win_opts)

    -- Unlist the buffer so that it doesn't appear in the buffer list
    vim.api.nvim_buf_set_option(buffer, "bufhidden", "wipe")

    return window, buffer
end

M.open_file_in_popup = function(filepath)
    local _, buffer = M.open_popup_window({ title = "Capture a note - type 'Q' to quit" })

    vim.cmd("edit " .. filepath)

    -- Unlist the buffer so that it doesn't appear in the buffer list
    -- Has to be duplicated here after 'edit'
    vim.api.nvim_buf_set_option(0, "bufhidden", "wipe")

    -- Save and quit with Q
    vim.keymap.set("n", "Q", "<cmd>wq<cr>", { buffer = buffer, desc = "Write and quit" })
end

return M

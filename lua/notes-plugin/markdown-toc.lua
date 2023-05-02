local M = {}

local DEFAULT_STATE = {
    parent_window = nil,
    parent_buffer = nil,
    window = nil,
    buffer = nil,
    items = {},
    flat_items = {},
    autocmds = {},
}

M.state = {}

local function highlight_current_heading()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]
    local item = M.state.items[row]
    vim.api.nvim_win_set_cursor(M.state.parent_window, { item.row, 0 })
end

local function focus_current_heading()
    highlight_current_heading()
    vim.api.nvim_set_current_win(M.state.parent_window)
end

local function open_side_window_opts(user_opts)
    local default_opts = {
        position = "right",
        width = 50,
    }
    local opts = vim.tbl_extend("force", default_opts, user_opts or {})

    assert(
        opts.position == "right" or opts.position == "left",
        "`right` and `left` are the only options allowed for `position`"
    )

    return opts
end

local function set_window_and_buffer_options(winnr, bufnr, opts)
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")

    vim.api.nvim_win_set_option(winnr, "number", false)
    vim.api.nvim_win_set_option(winnr, "relativenumber", false)
    vim.api.nvim_win_set_option(winnr, "cursorcolumn", false)
    vim.api.nvim_win_set_option(winnr, "signcolumn", "no")
    vim.api.nvim_win_set_option(winnr, "winfixwidth", true)
    vim.api.nvim_win_set_option(winnr, "list", false)

    vim.wo.fillchars = "eob: "                    -- hide tildas indicating the end of file

    vim.api.nvim_win_set_width(winnr, opts.width) -- TODO: make this configurable
end

---Open window on the side
---@param opts any
---@return winnr number
---@return bufnr number
local function open_side_window(opts)
    local opts = open_side_window_opts(opts)

    local bufnr = vim.api.nvim_create_buf(false, true)

    if opts.position == "left" then
        vim.cmd("topleft vsplit")
    else
        vim.cmd("botright vsplit")
    end

    local winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winnr, bufnr)

    set_window_and_buffer_options(winnr, bufnr, opts)

    return winnr, bufnr
end

local function init_state()
    local parser = vim.treesitter.get_parser()
    local tstree = parser:parse()[1]

    local query_string = "((atx_heading) @heading)"
    local query = vim.treesitter.query.parse(parser:lang(), query_string)

    local state = vim.deepcopy(DEFAULT_STATE)

    for _, node in query:iter_captures(tstree:root()) do
        local node_text = vim.treesitter.get_node_text(node, 0)
        -- ts uses 0-based indexing, but we set cursor uses 1-based:
        local row = node:range() + 1

        table.insert(state.items, { text = node_text, row = row })
        table.insert(state.flat_items, node_text)
    end

    state.parent_window = vim.api.nvim_get_current_win()
    state.parent_buffer = vim.api.nvim_get_current_buf()

    return state
end

local function setup_autocmds()
    table.insert(
        M.state.autocmds,
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = 0,
            callback = highlight_current_heading,
        })
    )

    table.insert(
        M.state.autocmds,
        vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
            buffer = M.state.parent_buffer,
            callback = M.close,
        })
    )
end

local function setup_buffer_keybindings(bufnr)
    vim.keymap.set(
        "n",
        "<CR>",
        focus_current_heading,
        { buffer = bufnr, desc = "Focus current heading" }
    )
    vim.keymap.set("n", "<Esc>", M.close, { buffer = bufnr, desc = "Close table of contents" })
end

function M.open()
    local opts = require('notes-plugin').config.markdown_toc
    vim.print(opts)

    M.state = init_state()

    local window, bufnr = open_side_window(opts)
    M.state.window = window
    M.state.buffer = bufnr

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, M.state.flat_items)
    vim.api.nvim_win_set_cursor(window, { 1, 0 })
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

    setup_autocmds()
    setup_buffer_keybindings(bufnr)
end

function M.close()
    vim.api.nvim_buf_delete(M.state.buffer, { force = true })

    for _, id in ipairs(M.state.autocmds) do
        pcall(vim.api.nvim_del_autocmd, id)
    end

    M.state = vim.deepcopy(DEFAULT_STATE)
end

function M.toggle()
    if M.state and M.state.buffer then
        M.close()
    else
        M.open()
    end
end

return M

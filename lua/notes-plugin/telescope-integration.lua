local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")

local utils = require("notes-plugin.utils")

local M = {}

--- Telescope actions of inserting a link
M.action_insert_selection_as_link = function(prompt_bufnr)
    actions.close(prompt_bufnr)

    local entry = action_state.get_selected_entry()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    local filename = entry[1]
    if utils.has_extension(filename, ".md") then
        filename = utils.strip_extension(filename, ".md")
    end

    local link = string.format("[](%s)", filename)
    vim.api.nvim_put({ link }, "", false, false)
    vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] + 2 })

    vim.cmd("startinsert")
end

M.create_note = function(prompt_bufnr, cwd)
    actions.close(prompt_bufnr)
    local line = action_state.get_current_line()
    local fname = vim.fn.strftime("%Y%m%d%H%M%S-") .. line .. ".md"
    vim.cmd(string.format("edit %s/%s", cwd, fname))
end

--- Telescope file picker with overriden action
M.find_or_create_note = function(opts)
    opts = opts or {}
    opts.entry_maker = make_entry.gen_from_file(opts)

    local find_command = { "rg", "--files", opts.cwd }

    local picker = pickers.new(opts, {
        prompt_title = "Find or create note",
        finder = finders.new_oneshot_job(find_command, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            -- override detault action: if nothing is matched create a new note
            actions.select_default:replace_if(function()
                return action_state.get_selected_entry() == nil
            end, function()
                M.create_note(prompt_bufnr, opts.cwd)
            end)

            -- Create a new note even if something matches with M-RET
            map({ "i", "n" }, "<M-CR>", function()
                M.create_note(prompt_bufnr, opts.cwd)
            end, { desc = "create_note" })

            return true
        end,
    })
    picker:find()
end

return M

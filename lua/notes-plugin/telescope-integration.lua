local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")

local utils = require("notes-plugin.utils")

local M = {}

local current_line_to_filepath = function(prompt_bufnr)
    local cwd = action_state.get_current_picker(prompt_bufnr).cwd
    local line = action_state.get_current_line()
    return cwd .. "/" .. vim.fn.strftime("%Y%m%d%H%M%S-") .. line .. ".md"
end

--- Telescope action of inserting a link
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

M.action_edit_in_popup = function(prompt_bufnr)
    local cwd = action_state.get_current_picker(prompt_bufnr).cwd

    local selected_entry = action_state.get_selected_entry()
    local filepath
    if selected_entry then
        local filename = selected_entry[1]
        filepath = cwd .. "/" .. filename
    else -- create a new note
        filepath = current_line_to_filepath(prompt_bufnr)
    end

    actions.close(prompt_bufnr)
    utils.open_file_in_popup(filepath)
end

M.action_create_note_popup = function(prompt_bufnr)
    local filepath = current_line_to_filepath(prompt_bufnr)
    actions.close(prompt_bufnr)
    utils.open_file_in_popup(filepath)
end

M.action_create_note = function(prompt_bufnr)
    local filepath = current_line_to_filepath(prompt_bufnr)
    actions.close(prompt_bufnr)
    vim.cmd("edit " .. filepath)
end

--- Telescope file picker with overriden action
M.picker_find_or_create_note = function(opts)
    opts = opts or {}
    opts.entry_maker = make_entry.gen_from_file(opts)

    local find_command = { "rg", "--files", opts.cwd }

    local picker = pickers.new(opts, {
        prompt_title = "Find or create note",
        finder = finders.new_oneshot_job(find_command, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_prompt_bufnr, map)
            -- override detault action: if nothing is matched create a new note
            actions.select_default:replace_if(function()
                return action_state.get_selected_entry() == nil
            end, M.action_create_note)

            -- Create a new note even if something matches with M-RET
            map({ "i", "n" }, "<M-CR>", M.action_create_note, { desc = "create_note" })

            return true
        end,
    })
    picker:find()
end

return M

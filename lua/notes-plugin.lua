local actions = require("telescope.actions")
local markdown = require("notes-plugin.markdown")
local telescope_integration = require("notes-plugin.telescope-integration")

local M = {}

-- default config, this is filled in setup()
M.config = {}

local DEFAULT_OPTS = {
    notes_dir = nil,
    markdown_toc = {
        position = "right",
        width = 50,
    },
}

local function setup_user_commands()
    local notes_dir = M.config.notes_dir

    -- :ZettelFind finds and opens a note
    vim.api.nvim_create_user_command("ZettelFind", function(opts)
        opts = require("telescope.themes").get_dropdown({
            cwd = notes_dir,
        })
        telescope_integration.picker_find_or_create_note(opts)
    end, {})

    -- :ZettelCapture - like :ZettelFind but in a quick buffer
    vim.api.nvim_create_user_command("ZettelCapture", function(opts)
        opts = require("telescope.themes").get_dropdown({
            previewer = false,
            prompt_title = "Find a note for capture",
            cwd = notes_dir,
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(telescope_integration.action_edit_in_popup)

                -- Create a new note even if something matches with M-RET
                map(
                    { "i", "n" },
                    "<M-CR>",
                    telescope_integration.action_create_note_popup,
                    { desc = "create_note" }
                )

                return true
            end,
        })

        require("telescope.builtin").find_files(opts)
    end, {})

    -- :ZettelInsertLink - insert link under the cursor
    vim.api.nvim_create_user_command("ZettelInsertLink", function(opts)
        opts = require("telescope.themes").get_dropdown({
            previewer = false,
            prompt_title = "Find a note",
            cwd = notes_dir,
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(
                    telescope_integration.action_insert_selection_as_link
                )
                return true
            end,
        })

        require("telescope.builtin").find_files(opts)
    end, {})

    -- :ZettelIndex find index note
    vim.api.nvim_create_user_command("ZettelIndex", function(opts)
        vim.cmd(string.format("edit %s/index.md", notes_dir))
    end, {})
end

local function setup_autocmds()
    local augroup = vim.api.nvim_create_augroup("NotesPlugin", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.md", "*.mkd" },
        group = augroup,
        callback = function()
            -- local keybindings - available in markdown file
            vim.keymap.set(
                "n",
                "<CR>",
                markdown.follow_link,
                { buffer = true, desc = "Follow link" }
            )

            -- local leader keybindings - available in markdown file
            vim.keymap.set(
                "n",
                "<localleader>,",
                markdown.toggle_checkbox,
                { buffer = true, desc = "Toggle checkbox" }
            )
            vim.keymap.set(
                "n",
                "<localleader>t",
                M.toggle_toc,
                { buffer = true, desc = "Toggle table of contents" }
            )
            vim.keymap.set(
                "n",
                "<localleader>i",
                "<cmd>:ZettelInsertLink<cr>",
                { desc = "Insert link to note under the cursor" }
            )
        end,
    })
end

-- public interface
M.setup = function(opts)
    local config = vim.tbl_extend("force", DEFAULT_OPTS, opts or {})
    M.config = config

    M.config.notes_dir = vim.fn.expand(M.config.notes_dir)
    assert(vim.fn.isdirectory(M.config.notes_dir) == 1, "You have to specify a valid `notes_dir`")

    setup_user_commands()
    setup_autocmds()
end

-- Reexport
M.toggle_toc = require("notes-plugin.markdown-toc").toggle

return M

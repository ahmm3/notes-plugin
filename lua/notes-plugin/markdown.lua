local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("notes-plugin.utils")

local M = {}

M.find_parent_node = function(node, type)
    local root = ts_utils.get_root_for_node(node)
    if node == root then
        return nil
    end
    if node:type() == type then
        return node
    end
    return M.find_parent_node(node:parent(), type)
end

M.find_child_node = function(node, type)
    for child in node:iter_children() do
        if child:type() == type then
            return child
        end
    end
end

--- Get markdown node under the cursor
---
--- This hackery is needed because markdown treesitter parser is actually composed of two
--- parsers: markdown, and markdown_inline; if our cursor lands on the inline one it
--- can't get to the markdown parents
---
--- @return tsnode | nil
M.get_markdown_node_at_cursor = function()
    -- get node under the cursor - may be inside an inline - that's why all the hackery
    local parser = vim.treesitter.get_parser()
    local node = ts_utils.get_node_at_cursor(0)
    local row, col = node:range()
    return parser:named_node_for_range({ row, col, row, col })
end

M.toggle_checkbox = function()
    local node = M.get_markdown_node_at_cursor()

    local list_item = M.find_parent_node(node, "list_item")
    if not list_item then
        return
    end

    local unchecked_checkbox = M.find_child_node(list_item, "task_list_marker_unchecked")
    if unchecked_checkbox then
        local row_start, col_start, row_end, col_end = unchecked_checkbox:range()
        vim.api.nvim_buf_set_text(0, row_start, col_start, row_end, col_end, { "[x]" })
        return
    end

    local checked_checkbox = M.find_child_node(list_item, "task_list_marker_checked")
    if checked_checkbox then
        local row_start, col_start, row_end, col_end = checked_checkbox:range()
        vim.api.nvim_buf_set_text(0, row_start, col_start, row_end, col_end, { "[ ]" })
        return
    end
end

--- Follow a link under the cursor
-- Right now this function will follow any link on our line, even if the cursor is not on it.
-- TODO: This needs to be rebuilt around treesitter, or text object
M.follow_link = function()
    local line = vim.api.nvim_get_current_line()
    local link_name = utils.match_link(line)
    if not link_name then
        return
    end

    local filepath = string.format("%s/%s", require("notes-plugin").config.notes_dir, link_name)

    -- see if we can open the file as it is
    if vim.fn.filereadable(filepath) == 1 then
        vim.cmd(string.format("edit %s", filepath))
    else -- if not append .md
        vim.cmd(string.format("edit %s.md", filepath))
    end
end

return M

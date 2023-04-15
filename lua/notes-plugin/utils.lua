local M = {}

M.match_link = function(s)
    local pattern = '%[.*%]%((.+)%)'
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

return M

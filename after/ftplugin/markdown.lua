-- special highlighting for markdown
vim.cmd([[hi! link @punctuation.special.markdown Normal]])

vim.cmd([[hi! link @code_block_info_string.markdown Comment]])
vim.cmd([[hi! link @punctuation.delimiter.markdown Comment]])
vim.cmd([[hi! link @punctuation.delimiter.markdown_inline Comment]])

-- link text
vim.cmd([[hi! @text.reference.markdown_inline guifg=#83a598 gui=underline]])

-- CodeBlock capture is added from the "headlines" plugin
vim.cmd([[hi! CodeBlock guibg=#2d2d2d]])

-- highlighting for headers
vim.cmd([[hi! link @h1_marker.markdown GruvboxGreenBold]])
vim.cmd([[hi! link @h1_content.markdown GruvboxGreenBold]])
vim.cmd([[hi! link @h2_marker.markdown GruvboxAquaBold]])
vim.cmd([[hi! link @h2_content.markdown GruvboxAquaBold]])
vim.cmd([[hi! link @h3_marker.markdown GruvboxBlueBold]])
vim.cmd([[hi! link @h3_content.markdown GruvboxBlueBold]])
vim.cmd([[hi! link @h4_marker.markdown GruvboxPurpleBold]])
vim.cmd([[hi! link @h4_content.markdown GruvboxPurpleBold]])
vim.cmd([[hi! link @h5_marker.markdown GruvboxRedBold]])
vim.cmd([[hi! link @h5_content.markdown GruvboxRedBold]])
vim.cmd([[hi! link @h6_marker.markdown GruvboxYellowBold]])
vim.cmd([[hi! link @h6_content.markdown GruvboxYellowBold]])

vim.cmd([[hi! @text.todo.unchecked.markdown gui=bold guifg=#fbf1c7]])
vim.cmd([[hi! @text.todo.checked.markdown gui=bold guifg=#504945]])
vim.cmd([[hi! @list_item_done.markdown guifg=#504945]])
vim.cmd([[hi! link @text.literal.markdown GruvboxPurple]])

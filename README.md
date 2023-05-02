# notes-plugin
## Public interface
### Markdown actions
``` lua
-- Follow link under the cursor
-- Mapped to <CR>
require('notes-plugin').follow_link()

-- Toggle checkbox before the cursor
-- Mapped to <localleader>t
require('notes-plugin').toggle_checkbox()
```

### Markdown table of contents
``` lua
-- Toggle table of contents for the current buffer
require('notes-plugin').toggle_toc()
```

- It will highlight the current heading in the parent window
- Hitting RET will focus the heading
- Table of contents will be closed when the buffer in the parent window is changed

### Other actions
``` lua
-- Edit index file
-- :ZettelIndex
```

### Telescope integration
#### Find or create a note
``` lua
-- Find or create a note
-- :ZettelFind

-- Use M-RET to create the note note with the current name even if something is selected
```

#### Insert link to an existing note
``` lua
-- :ZettelInsertLink
```

#### Quickly create / edit note in a popup window
``` lua
-- :ZettelCapture
-- Use M-RET to create the note note with the current name even if something is selected
```

## Markdown tweaks
- Better syntax highlighting - for now hard coded to gruvbox
  + Independently colored headlines
  + Improved code blocks

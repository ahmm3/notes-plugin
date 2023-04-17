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

## Markdown tweaks
- Better syntax highlighting - for now hard coded to gruvbox
  + Independently colored headlines
  + Improved code blocks

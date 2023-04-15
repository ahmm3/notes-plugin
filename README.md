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
``` lua
-- Find or create a note
-- :ZettelFind

-- Insert link to an existing note
-- :ZettelInsertLink
```

## Markdown tweaks
- Better syntax highlighting - for now hard coded to gruvbox
  + Independently colored headlines
  + Improved code blocks

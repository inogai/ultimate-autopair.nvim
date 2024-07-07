# Ultimate-autopair.nvim

This is a personal fork of the [altermo/ultimate-autopair.nvim](https://github.com/altermo/ultimate-autopair.nvim).
Query the original repository for more information.

## Changes

Added a new extension `surroundtsnode`.

Instead of surrounding the pairs with where `internal_pairs[{idx}].surround` is
`true`, it will surround the topmost `TSNode` that immediately follows the cursor.

It still obeys the `internal_pairs[{idx}].dosurround` option.

Enable it as follows:

```lua
local ua = require("ultimate-autopair")
local configs = {
  ua.extend_default({
    ...
    extensions = {
      ...
      surroundtsnode = { p = 20 },
      suround = { p = 0 },
    },
  }),
}
ua.init(configs)
```

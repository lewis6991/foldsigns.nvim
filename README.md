# foldsigns.nvim

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Simple plugin to display signs on folded lines.

## Requirements

- Neovim >= 0.5.0

## Installation

[packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use 'lewis6991/foldsigns.nvim'
```

[vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'lewis6991/foldsigns.nvim'
```

## Usage

```lua
require('foldsigns').setup()
```

If using [packer.nvim](https://github.com/wbthomason/packer.nvim) foldsigns can
be setup directly in the plugin spec:

```lua
use {
  'lewis6991/foldsigns.nvim',
  config = function()
    require('foldsigns').setup()
  end
}
```

Configuration can be passed to the setup function. Here is an example with all
the default settings:

```lua
require('foldsigns').setup {
  -- List of lua patterns to match against sign names to include.
  -- By default all signs are included.
  include = nil,

  -- List of lua patterns to match against sign names to exclude.
  exclude = nil,
}
```

## Example

If you want to exclude specific signs run:

```viml
echo sign_getplaced(0, {'group':'*'})
```

You should see output like:

```
[{
  'bufnr': 1,
  'signs': [
    {'lnum': 9, 'id': 9, 'name': 'GitSignsChange', 'priority': 6, 'group': 'gitsigns_ns'},
    {'lnum': 10, 'id': 1, 'name': 'LspDiagnosticsSignError', 'priority': 10, 'group': 'vim_lsp_signs: 1'},
    {'lnum': 10, 'id': 10, 'name': 'GitSignsAdd', 'priority': 6, 'group': 'gitsigns_ns'},
    {'lnum': 13, 'id': 2, 'name': 'LspDiagnosticsSignError', 'priority': 10, 'group': 'vim_lsp_signs:1'},
    {'lnum': 14, 'id': 3, 'name': 'LspDiagnosticsSignError', 'priority': 10, 'group': 'vim_lsp_signs:1'}
  ]
}]
```

To exclude all `GitSigns` signs:

```lua
require('foldsigns').setup {
  exclude = {'GitSigns.*'},
}
```

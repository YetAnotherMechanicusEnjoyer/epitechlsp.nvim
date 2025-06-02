# Epitech Language Server Protocol

<img src="https://i.ibb.co/Y7vsTrDT/Screenshot-20250525-144831.png" alt="Example Image" border="0">

## Table of Content

- [About](#about)
- [Installation](#installation)
  * [Dependencies](#dependencies)
- [Neovim](#neovim)
  * [Lazy](#lazynvim)
  * [Packer](#packernvim)
  * [Vim Plug](#vim-plug)
- [License](#license)

## About

> [!WARNING]
> Only people with access rights to EPITECH's private repos can use this plugin.
>
> You need the [banana coding](https://github.com/Epitech/banana-coding-style-checker.git) style checker.

## Installation

### Dependencies

> [!IMPORTANT]
> Make sure to have [banana-vera](https://gist.github.com/Sigmanificient/6ef147920ad057ef6bcd9b057f81d83d) installed or compiled by yourself.

## Neovim

Copy and Paste the code block corresponding to your neovim config's plugin manager.

### lazy.nvim
```lua
{
  "YetAnotherMechanicusEnjoyer/epitechlsp.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = true
}
```

### packer.nvim
```lua
use {
  "YetAnotherMechanicusEnjoyer/epitechlsp.nvim",
  requires = {
    "neovim/nvim-lspconfig"
  },
  config = function()
    require("epitechlsp").setup()
  end
}
```

### vim-plug
`init.vim` ou `init.lua`
```vim
Plug 'neovim/nvim-lspconfig'
Plug 'YetAnotherMechanicusEnjoyer/epitechlsp.nvim'
```
`init.lua`
```lua
require("epitechlsp").setup()
```

## Licence
[MIT](https://github.com/YetAnotherMechanicusEnjoyer/epitechlsp.nvim/blob/main/LICENSE)

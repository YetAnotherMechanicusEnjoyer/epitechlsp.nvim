# Epitech Language Server Protocol

<img src="https://cdn.discordapp.com/attachments/451371722428383236/1376180453018701974/Screenshot_20250525_144831.png?ex=6834636c&is=683311ec&hm=b4b918abc7b4303706841650ca07fc2754cf5f8eb1c6a63356b0cf8931bd4c50&" />

## Table of Content

- [About](#about)
- [Installation](#installation)
  * [Dependencies](#dependencies)
- [Neovim](#neovim)
  * [Lazy](#lazynvim)
  * [Packer](#packernvim)
  * [Vim Plug](#vim-plug)

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
  "ton-plugin/nom-du-plugin",
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

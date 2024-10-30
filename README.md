# Macroni

Save your macros for future use in Neovim! 🤌

- [Rationale](#rationale)
- [Installation](#installation)
- [Macro Basics](#macro-basics)
- [Yanking Macros](#yanking-macros)
- [Saving Macros](#saving-macros)
    - [Into your macroni config](#saving-macros) (recommended)
    - [Directly into a keymap](#saving-directly-into-a-keymap)
    - [Directly into a lua function](#saving-directly-into-a-lua-function)
- [Playing Saved Macros](#playing-saved-macros)
- [Advanced Usage](#advanced-usage)
- [Thank You](#thank-you)

## Rationale

Q: Why use Macroni at all when you can just yank directly from your register?

A: Because then you have to deal with escaping termcodes, quotes, etc. yourself. Macroni escapes all that stuff for you, so you can paste directly to a mapping or function, or save to your config for quick access via Macroni's handy [Telescope picker](https://github.com/nvim-telescope/telescope.nvim) 💅

## Installation

1. Install using your favourite package manager:

    **Using [packer.nvim](https://github.com/wbthomason/packer.nvim):**

    ```lua
    use { 'jesseleite/nvim-macroni' }
    ```

    **Using [lazy.nvim](https://github.com/folke/lazy.nvim):**

    ```lua
    {
      'jesseleite/nvim-macroni',
      lazy = false,
      opts = {
        -- All of your `setup(opts)` and saved macros will go here
      },
    }
    ```

2. If you're using [Telescope](https://github.com/nvim-telescope/telescope.nvim), don't forget to load the extension and map the fuzzy picker:

    ```lua
    require('telescope').load_extension('macroni')
    ```

    ```lua
    vim.keymap.set({'n', 'v'}, '<Leader>m', function ()
      require('telescope').extensions.macroni.saved_macros()
    end)
    ```

3. Order pizza! 🍕 🤘 😎


## Macro Basics

If you want to learn more about the basics of how to record macros, check out my [NeovimConf talk](https://youtu.be/5x3dXo8aDCI?si=9_hKDsRXiC76AWDK)! 📺


## Usage

### Yanking Macros

Simply run `:YankMacro [register]` to yank a recorded macro from a register, then paste the macro...

- [Into your macroni config](#saving-macros) (recommended)
- [Directly into a keymap](#saving-directly-into-a-keymap)
- [Directly into a lua function](#saving-directly-into-a-lua-function)

With the first option, Macroni will automatically populate your [saved macros](#into-your-macroni-config) into a handy [Telescope picker](https://github.com/nvim-telescope/telescope.nvim). You can also configure keymaps from here as well.

That said, don't be afraid to bypass Macroni's config and paste them directly into your own neovim keymaps and functions where it makes sense! Macroni escapes termcodes so that they are [keymap-friendly](#into-a-keymap), and provides a handy `run()` function for use inside your [custom functions](#into-a-lua-function).

### Saving Macros

To save macros to your Macroni config, simply add a `macros` table within your `setup(opts)`:

```lua
require('macroni').setup({
  macros = {
    make_todo_list_item = '^i-<Space>[<Space>]<Space><Esc>',
  }
})
```

If you wish to define a `keymap` for a saved macro, you may use table syntax:

```lua
require('macroni').setup({
  macros = {
    make_todo_list_item = {
      macro = '^i-<Space>[<Space>]<Space>',
      keymap = '<Leader>t',
    },
  }
})
```

By default, macro keymaps are mapped to both normal and visual modes (`{'n', 'v'}`), so that macros can be played back over multiline selections.

### Playing Saved Macros

On top of your configured keymaps, all configured macros will be automatically added to Macroni's [Telescope](https://github.com/nvim-telescope/telescope.nvim) picker (see [Installation](#installation) for more info). Selecting a macro from this picker will play it back on the current line / on your selected lines.

## Advanced Usage

#### Advanced Keymap Configuration

For more advanced keymap control, you may provide optional `desc` and `mode` keys, which will be passed to `vim.keymap.set` under the hood:

```lua
require('macroni').setup({
  macros = {
    make_todo_list_item = {
      macro = '^i-<Space>[<Space>]<Space>',
      keymap = '<Leader>t',
      mode = { 'n', 'v' }, -- By default, macros will be mapped to both normal & visual modes
      desc = 'Make a markdown list item!', -- Description for whichkey or similar
    },
  }
})
```

#### Customizing Escaped Characters on Yank

By default, macroni will replace termcodes and escape quotes when [yanking](#yanking-macros), so that you can easily paste as a lua string. If you wish to extend the list of escaped characters, you may add the following configuration:

```lua
require('macroni').setup({
  yank = {
    escape_characters = { '"', "'" }, -- By default, single and double quote are escaped
  },
})
```

#### Saving Directly Into a Keymap

If you want to save a [yanked macro](#yanking-macros) directly into your own keymap, simply paste it in:

```lua
vim.keymap.set('n', '<Leader>t', '^i-<Space>[<Space>]<Space><Esc>', { remap = true })
```

_Note: It is recommended that you set the `remap = true` option, to ensure that your macro is run more accurately as if you had manually run it yourself!_

#### Saving Directly Into a Lua Function

You can also use macroni's `run()` helper to execute a [yanked macro](#yanking-macros) from within a function:

```lua
local make_todo_list_item = function ()
  require('macroni').run('^i-<Space>[<Space>]<Space><Esc>')
end
```

## Thank You!

Thank you for checking out Macroni!

Here's where can find me on the internet...

[jesseleite.com](https://jesseleite.com)<br>
[vimfornormalpeople.com](https://vimfornormalpeople.com)<br>
[X](https://x.com/jesseleite85)<br>
[My Neovim config BTW](https://github.com/jesseleite/dotfiles/tree/master/nvim)<br>
[My NeovimConf talk on macros](https://youtu.be/5x3dXo8aDCI?si=9_hKDsRXiC76AWDK) 📺<br>

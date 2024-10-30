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

2. If you're using [Telescope](https://github.com/nvim-telescope/telescope.nvim), don't forget to map Macroni's fuzzy picker!

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

If you wish to define a keymap for a saved macro, you may use table syntax:

```lua
require('macroni').setup({
  macros = {
    make_todo_list_item = {
      macro = '^i-<Space>[<Space>]<Space><Esc>',  -- Your macros then goes here
      keymap = '<Leader>t',                       -- Along with your desired keymap (optional)
      desc = 'Make a markdown todo list item!',   -- And a keymap description (optional)
    },
  }
})
```

### Playing Saved Macros

Your configured macros will be automatically added to Macroni's [Telescope](https://github.com/nvim-telescope/telescope.nvim) picker (see [Installation](#installation) for more info). Selecting a macro from this picker will play it back on the current line / on your selected lines.

## Advanced Usage

#### Saving Directly Into a Keymap

If you want to save a [yanked macro](#yanking-macros) directly into a keymap, simply paste it in:

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
[my neovim config btw](https://github.com/jesseleite/dotfiles/tree/master/nvim)<br>

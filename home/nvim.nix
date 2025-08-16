{ config, pkgs, lib, ... }:

{
  programs.nixvim = {
    enable = true;

    globals.mapleader = ";";

    extraPackages = with pkgs; [
      nodejs
      yarn
      python3
      ripgrep
    ];

    extraPlugins = with pkgs.vimPlugins; [
      neo-tree-nvim
      lazygit-nvim
      telescope-nvim
      lualine-nvim
      barbecue-nvim
      legendary-nvim
      mini-nvim
      dressing-nvim
      nvim-colorizer-lua
      gitsigns-nvim
      coc-nvim
      coc-css
      coc-json
      coc-html
      coc-pyright
      coc-rust-analyzer
      coc-clangd
      coc-tsserver
      coc-yaml
      coc-toml
      minimap-vim
    # ] ++ [
    #   (pkgs.vimPlugins."minimap.vim")
    ];

    extraConfigLua = ''
      vim.g.neovide_opacity = 0.95
      vim.g.neovide_normal_opacity = 0.95
      vim.g.neovide_scroll_animation_length = 0.1
      vim.g.coc_global_extensions = { 'coc-discord-rpc' }
      vim.o.guifont = "Monocraft Nerd Font:h10"

      vim.opt.termguicolors = true
      vim.wo.number = true
      vim.o.softtabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true
      vim.o.tabstop = 4
      vim.g.mapleader = ';'

      pcall(function() require('mini.starter').setup() end)
      pcall(function() require('mini.cursorword').setup() end)
      pcall(function() require('mini.fuzzy').setup() end)
      pcall(function() require('mini.hipatterns').setup() end)
      pcall(function() require('mini.map').setup() end)
      pcall(function() require('mini.comment').setup() end)
      pcall(function() require('mini.move').setup() end)
      pcall(function() require('mini.trailspace').setup() end)

      pcall(function()
        local lualine = require('lualine')
        lualine.setup {
          options = { icons_enabled = true, theme = 'iceberg_dark', component_separators = { left = '', right = ''}, section_separators = { left = '', right = ''}, disabled_filetypes = { statusline = {}, winbar = {} }, always_divide_middle = true, globalstatus = false, refresh = { statusline = 1000, tabline = 1000, winbar = 1000 } },
          sections = { lualine_a = {'mode'}, lualine_b = {'branch', 'diff', 'diagnostics'}, lualine_c = {'filename'}, lualine_x = {'encoding', 'fileformat', 'filetype'}, lualine_y = {'progress'}, lualine_z = {'location'} },
          inactive_sections = { lualine_c = {'filename'}, lualine_x = {'location'} },
        }
      end)

      pcall(function()
        local neotree = require('neo-tree')
        neotree.setup {
          filesystem = {
            filtered_items = {
              visible = true,
              hide_dotfiles = false,
              hide_gitignored = true,
            }
          }
        }
      end)

      pcall(function()
        require("colorizer").setup {
          filetypes = { "*" },
          user_default_options = { RGB = true, RRGGBB = true, names = true, RRGGBBAA = true, AARRGGBB = true, rgb_fn = true, hsl_fn = true, css = true, css_fn = true, mode = "background", tailwind = true, sass = { enable = false, parsers = { "css" }, }, virtualtext = "■", always_update = false },
          buftypes = {},
        }
      end)

      pcall(function() require("barbecue.ui").toggle(true) end)

      vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? coc#pum#next(1) : "<Tab>"', { noremap = true, expr = true })
      vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? coc#pum#prev(1) : "<C-h>"', { noremap = true, expr = true })
      vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "\\<CR>"', { noremap = true, silent = true, expr = true })


      vim.keymap.set('n', '<Leader>m', MiniMap.toggle)
      vim.cmd('highlight Normal guibg=#050010')
      vim.cmd('tnoremap <Esc> <C-\\><C-n>')
    '';
  };
}

